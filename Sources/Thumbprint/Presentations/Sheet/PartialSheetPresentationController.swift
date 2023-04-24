import UIKit

// TODO: (team) Much of what's included in this delegate has been added to UIAdaptivePresentationControllerDelegate
// in iOS 13.  Once we're on a minimum target of iOS 13, we can get rid of PartialSheetPresentationControllerDelegate and
// just use UIAdaptivePresentationControllerDelegate directly (for which UIPresentationController already has a delegate
// property)
@objc
public protocol PartialSheetPresentationControllerDelegate: UIAdaptivePresentationControllerDelegate {
    @objc
    optional func partialSheetPresentationControllerShouldDismissSheet(_ partialSheetPresentationController: PartialSheetPresentationController) -> Bool

    @objc
    optional func partialSheetPresentationControllerWillDismissSheet(_ partialSheetPresentationController: PartialSheetPresentationController)

    @objc
    optional func partialSheetPresentationControllerDidDismissSheet(_ partialSheetPresentationController: PartialSheetPresentationController)
}

open class PartialSheetPresentationController: UIPresentationController {
    public static let partialSheetDidPresentNotification = Notification.Name("PartialSheetDidPresentNotification")
    public static let partialSheetDidDismissNotification = Notification.Name("PartialSheetDidDismissNotification")

    private class SizeTransitionCoordinator: NSObject, UIViewControllerTransitionCoordinator {
        var isAnimated: Bool { false }
        var presentationStyle: UIModalPresentationStyle { .none }
        var initiallyInteractive: Bool { false }
        var isInterruptible: Bool { false }
        var isInteractive: Bool { false }
        var isCancelled: Bool { false }
        var transitionDuration: TimeInterval { Duration.three }
        var percentComplete: CGFloat { 0 }
        var completionVelocity: CGFloat { 0 }
        var completionCurve: UIView.AnimationCurve { .easeInOut }
        var targetTransform: CGAffineTransform { .identity }

        var alongsideAnimations: [(UIViewControllerTransitionCoordinatorContext) -> Void] = []
        var alongsideCompletions: [(UIViewControllerTransitionCoordinatorContext) -> Void] = []
        var containerView: UIView

        required init(containerView: UIView) {
            self.containerView = containerView
        }

        func viewController(forKey key: UITransitionContextViewControllerKey) -> UIViewController? { nil }
        func view(forKey key: UITransitionContextViewKey) -> UIView? { nil }
        func notifyWhenInteractionEnds(_ handler: @escaping (UIViewControllerTransitionCoordinatorContext) -> Void) {}
        func notifyWhenInteractionChanges(_ handler: @escaping (UIViewControllerTransitionCoordinatorContext) -> Void) {}

        func animate(
            alongsideTransition animation: ((UIViewControllerTransitionCoordinatorContext) -> Void)?,
            completion: ((UIViewControllerTransitionCoordinatorContext) -> Void)? = nil
        ) -> Bool {
            if let animation = animation { alongsideAnimations.append(animation) }
            if let completion = completion { alongsideCompletions.append(completion) }
            return true
        }

        func animateAlongsideTransition(
            in view: UIView?,
            animation: ((UIViewControllerTransitionCoordinatorContext) -> Void)?,
            completion: ((UIViewControllerTransitionCoordinatorContext) -> Void)? = nil
        ) -> Bool {
            if let animation = animation { alongsideAnimations.append(animation) }
            if let completion = completion { alongsideCompletions.append(completion) }
            return true
        }
    }

    private static let grabberHeight: CGFloat = 4
    private static let grabberWidth: CGFloat = 48
    private static let grabberMidYOffset: CGFloat = (PartialSheetPresentationController.grabberHeight / 2) + Space.two

    private let dimmedView: UIView = {
        let result = UIView()
        result.backgroundColor = .black
        result.alpha = 0
        return result
    }()

    private let grabberView: UIView = {
        let result = UIView()
        result.backgroundColor = Color.gray300
        result.isUserInteractionEnabled = false
        result.alpha = 0
        result.isHidden = true
        result.layer.cornerRadius = 2

        return result
    }()

    private var currentTransitionCoordinator: UIViewControllerTransitionCoordinator?

    internal let backgroundTapGestureRecognizer = UITapGestureRecognizer()
    internal let panGestureRecognizer = UIPanGestureRecognizer()

    public var partialSheetDelegate: PartialSheetPresentationControllerDelegate? {
        get {
            delegate as? PartialSheetPresentationControllerDelegate
        }
        set {
            delegate = newValue
        }
    }

    public var isGrabberViewHidden: Bool {
        get {
            grabberView.isHidden
        }
        set {
            grabberView.isHidden = newValue
        }
    }

    public var isPanToDismissEnabled: Bool {
        get {
            panGestureRecognizer.isEnabled
        }
        set {
            panGestureRecognizer.isEnabled = newValue
        }
    }

    open override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()

        guard let containerView = containerView else {
            fatalError("Somehow reached presentationTransitionWillBegin with no container view being set")
        }

        presentedViewController.view.layer.cornerRadius = 14
        presentedViewController.view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        presentedViewController.view.layer.masksToBounds = true

        containerView.addSubview(dimmedView)
        containerView.addSubview(grabberView)
        containerView.addGestureRecognizer(panGestureRecognizer)
        dimmedView.addGestureRecognizer(backgroundTapGestureRecognizer)

        backgroundTapGestureRecognizer.addTarget(self, action: #selector(backgroundTapGestureRecognizerHandler(sender:)))
        panGestureRecognizer.addTarget(self, action: #selector(panGestureRecognizerHandler(sender:)))

        if let transitionCoordinator = presentedViewController.transitionCoordinator {
            currentTransitionCoordinator = transitionCoordinator

            let size = self.size(forChildContentContainer: presentedViewController, withParentContainerSize: containerView.bounds.size)
            presentedViewController.viewWillTransition(to: size, with: transitionCoordinator)

            grabberView.center = CGPoint(
                x: containerView.bounds.midX,
                y: containerView.bounds.maxY - Self.grabberMidYOffset
            )

            transitionCoordinator.animate(alongsideTransition: { _ in
                self.dimmedView.alpha = 0.5
                self.grabberView.alpha = 1

                let frameOfPresentedView = self.frameOfPresentedViewInContainerView
                self.grabberView.center = CGPoint(
                    x: frameOfPresentedView.midX,
                    y: frameOfPresentedView.minY - Self.grabberMidYOffset
                )
            }, completion: { _ in
                self.currentTransitionCoordinator = nil
            })

        } else {
            dimmedView.alpha = 0.5
            grabberView.alpha = 1
        }

        NotificationCenter.default.post(name: PartialSheetPresentationController.partialSheetDidPresentNotification, object: nil)
    }

    @objc
    private func backgroundTapGestureRecognizerHandler(sender: UITapGestureRecognizer) {
        guard let shouldDismissSheetMethod = partialSheetDelegate?.partialSheetPresentationControllerShouldDismissSheet else {
            presentingViewController.dismiss(animated: true, completion: nil)
            return
        }

        if shouldDismissSheetMethod(self) {
            presentingViewController.dismiss(animated: true, completion: nil)
        }
    }

    @objc
    private func panGestureRecognizerHandler(sender: UIPanGestureRecognizer) {
        guard sender.state == .began else {
            return
        }

        guard let shouldDismissSheetMethod = partialSheetDelegate?.partialSheetPresentationControllerShouldDismissSheet else {
            presentingViewController.dismiss(animated: true, completion: nil)
            return
        }

        if shouldDismissSheetMethod(self) {
            presentingViewController.dismiss(animated: true, completion: nil)
        }
    }

    public override func dismissalTransitionWillBegin() {
        super.dismissalTransitionWillBegin()

        guard let containerView = containerView else {
            fatalError("Somehow reached dismissalTransitionWillBegin with no container view being set")
        }

        partialSheetDelegate?.partialSheetPresentationControllerWillDismissSheet?(self)

        if let transitionCoordinator = presentedViewController.transitionCoordinator {
            currentTransitionCoordinator = transitionCoordinator

            transitionCoordinator.animate(alongsideTransition: { _ in
                self.dimmedView.alpha = 0
                self.grabberView.alpha = 0

                self.grabberView.center = CGPoint(
                    x: containerView.bounds.midX,
                    y: containerView.bounds.maxY - Self.grabberMidYOffset
                )
            }, completion: { _ in
                self.currentTransitionCoordinator = nil
            })
        } else {
            dimmedView.alpha = 0
            grabberView.alpha = 0
        }
    }

    public override func dismissalTransitionDidEnd(_ completed: Bool) {
        super.dismissalTransitionDidEnd(completed)

        if completed {
            partialSheetDelegate?.partialSheetPresentationControllerDidDismissSheet?(self)

            NotificationCenter.default.post(name: PartialSheetPresentationController.partialSheetDidDismissNotification, object: nil)
        }
    }

    open override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()

        let frameOfPresentedView = frameOfPresentedViewInContainerView
        presentedView?.frame = frameOfPresentedView

        grabberView.bounds = CGRect(x: 0, y: 0, width: Self.grabberWidth, height: Self.grabberHeight)
        grabberView.center = CGPoint(
            x: frameOfPresentedView.midX,
            y: frameOfPresentedView.minY - Self.grabberMidYOffset
        )

        grabberView.frame = grabberView.frame.integral

        dimmedView.frame = frameOfScrimInContainerView
    }

    open var frameOfScrimInContainerView: CGRect {
        CGRect(origin: .zero, size: containerView?.bounds.size ?? .zero)
    }

    open override var frameOfPresentedViewInContainerView: CGRect {
        guard let parentSize = containerView?.bounds.size else {
            return .zero
        }

        let contentContainerSize = size(forChildContentContainer: presentedViewController, withParentContainerSize: parentSize)

        let rect = CGRect(
            x: 0,
            y: parentSize.height - contentContainerSize.height,
            width: contentContainerSize.width,
            height: contentContainerSize.height
        )

        return rect.integral
    }

    open override func size(forChildContentContainer container: UIContentContainer, withParentContainerSize parentSize: CGSize) -> CGSize {
        // If the presented view controller has a preferredContentSize set, use it
        let preferredContentSize = presentedViewController.preferredContentSize
        if preferredContentSize != .zero {
            let bottomInset: CGFloat = containerView?.safeAreaInsets.bottom ?? 0

            let maxHeight: CGFloat = parentSize.height - (containerView?.safeAreaInsets.top ?? 0) - Space.six
            let height: CGFloat = ceil(min(
                preferredContentSize.height + bottomInset,
                maxHeight
            ))
            return CGSize(width: parentSize.width, height: height)
        }

        // Otherwise, use the default
        return CGSize(width: parentSize.width, height: parentSize.height / 2)
    }

    public override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        currentTransitionCoordinator = coordinator
        super.viewWillTransition(to: size, with: coordinator)

        let calculatedSize = self.size(forChildContentContainer: presentedViewController, withParentContainerSize: size)
        if presentedViewController.preferredContentSize != calculatedSize {
            presentedViewController.viewWillTransition(to: calculatedSize, with: coordinator)
        }

        coordinator.animate(alongsideTransition: { _ in
            self.containerView?.layoutIfNeeded()
        }, completion: { _ in
            self.currentTransitionCoordinator = nil
        })
    }

    public override func preferredContentSizeDidChange(forChildContentContainer container: UIContentContainer) {
        super.preferredContentSizeDidChange(forChildContentContainer: container)

        containerView?.setNeedsLayout()

        if let containerView = containerView, currentTransitionCoordinator == nil {
            let sizeTransitionCoordinator = SizeTransitionCoordinator(containerView: containerView)
            currentTransitionCoordinator = sizeTransitionCoordinator

            let calculatedSize = size(forChildContentContainer: presentedViewController, withParentContainerSize: containerView.bounds.size)
            presentedViewController.viewWillTransition(to: calculatedSize, with: sizeTransitionCoordinator)

            UIView.animate(withDuration: sizeTransitionCoordinator.transitionDuration, delay: 0, options: [.curveEaseInOut, .layoutSubviews], animations: {
                containerView.layoutIfNeeded()

                sizeTransitionCoordinator.alongsideAnimations.forEach { $0(sizeTransitionCoordinator) }
            }, completion: { _ in
                sizeTransitionCoordinator.alongsideCompletions.forEach { $0(sizeTransitionCoordinator) }
                self.currentTransitionCoordinator = nil
            })
        }
    }
}
