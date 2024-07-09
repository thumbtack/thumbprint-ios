import UIKit

open class PartialSheetPresentation: NSObject, UIViewControllerTransitioningDelegate {
    private class PercentDrivenInteractiveTransition: UIPercentDrivenInteractiveTransition, UIViewControllerAnimatedTransitioning {
        private var presentedViewFrame: CGRect = .zero
        private let triggerPercentage: CGFloat = 0.42

        let panGestureRecognizer: UIPanGestureRecognizer

        required init(panGestureRecognizer: UIPanGestureRecognizer) {
            self.panGestureRecognizer = panGestureRecognizer

            super.init()

            panGestureRecognizer.addTarget(self, action: #selector(panGestureRecognizerHandler))
        }

        override func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
            if let viewController = transitionContext.viewController(forKey: .from) {
                presentedViewFrame = transitionContext.initialFrame(for: viewController)
            }

            super.startInteractiveTransition(transitionContext)
        }

        @objc
        private func panGestureRecognizerHandler(_ panGestureRecognizer: UIPanGestureRecognizer) {
            switch panGestureRecognizer.state {
            case .changed:
                let translation: CGPoint = panGestureRecognizer.translation(in: nil)
                let verticalDelta: CGFloat = translation.y / presentedViewFrame.height
                let verticalPercentage: CGFloat = max(min(verticalDelta, 1), 0)

                update(verticalPercentage)

            case .cancelled:
                cancel()

            case .ended:
                if percentComplete > triggerPercentage {
                    finish()
                } else {
                    cancel()
                }

            default:
                break
            }
        }

        public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
            transitionContext?.isInteractive == true ? 0.5 : 0.2
        }

        public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
            guard let view = transitionContext.view(forKey: UITransitionContextViewKey.from) else {
                transitionContext.completeTransition(false)
                return
            }

            UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: .curveLinear, animations: {
                view.transform = CGAffineTransform(translationX: 0, y: view.bounds.height)
            }, completion: { _ in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            })
        }
    }

    open func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        PartialSheetPresentationController(presentedViewController: presented, presenting: presenting)
    }

    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let partialSheetPresentationController = dismissed.partialSheetPresentationController else {
            return nil
        }

        return PercentDrivenInteractiveTransition(panGestureRecognizer: partialSheetPresentationController.panGestureRecognizer)
    }

    public func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        guard let percentDrivenInteractiveTransition = animator as? PercentDrivenInteractiveTransition, percentDrivenInteractiveTransition.panGestureRecognizer.state == .began else {
            return nil
        }

        return percentDrivenInteractiveTransition
    }
}
