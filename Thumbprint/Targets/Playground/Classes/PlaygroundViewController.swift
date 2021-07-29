import RxCocoa
import RxGesture
import RxSwift
import SnapKit
import Thumbprint
import UIKit

class PlaygroundViewController: UIViewController {
    init() {
        super.init(nibName: nil, bundle: nil)

        componentsListViewController.delegate = self
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // MARK: Configure views
        view.backgroundColor = Color.black

        playgroundView.addSubview(playgroundBackgroundView)

        view.addSubview(playgroundView)
        view.addSubview(showComponentsListButton)
        view.addSubview(componentsListShadowCard)
        view.addSubview(inspectorShadowCard)

        let componentsListNavigationController = UINavigationController(rootViewController: componentsListViewController)
        NavigationBar.configure(componentsListNavigationController.navigationBar)
        componentsListNavigationController.navigationBar.prefersLargeTitles = true

        let dismissComponentsListBarButtonItem = UIBarButtonItem(image: Icon.navigationCloseMedium, style: .plain, target: self, action: #selector(hideComponentsList(_:)))
        dismissComponentsListBarButtonItem.accessibilityLabel = "Close"
        componentsListViewController.navigationItem.rightBarButtonItem = dismissComponentsListBarButtonItem

        addChild(componentsListNavigationController)
        componentsListShadowCard.addSubview(componentsListNavigationController.view)
        componentsListNavigationController.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        componentsListNavigationController.didMove(toParent: self)

        let inspectorNavigationController = UINavigationController(rootViewController: inspectorViewController)
        NavigationBar.configure(inspectorNavigationController.navigationBar)
        inspectorNavigationController.navigationBar.prefersLargeTitles = true
        addChild(inspectorNavigationController)
        inspectorShadowCard.addSubview(inspectorNavigationController.view)
        inspectorNavigationController.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        inspectorNavigationController.didMove(toParent: self)

        iPhoneMaskSwitchContainer.addSubview(iPhoneMaskSwitchLabel)
        iPhoneMaskSwitchContainer.addSubview(iPhoneMaskSwitch)
        view.addSubview(iPhoneMaskSwitchContainer)

        // MARK: Set up constraints
        playgroundBackgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        playgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        showComponentsListButton.snp.makeConstraints { make in
            make.top.leading.equalTo(view.safeAreaLayoutGuide).inset(Space.four)
        }

        iPhoneMaskSwitchLabel.snp.makeConstraints { make in
            make.centerY.leading.equalToSuperview()
            make.top.bottom.equalToSuperview().priority(999)
        }

        iPhoneMaskSwitch.snp.makeConstraints { make in
            make.leading.equalTo(iPhoneMaskSwitchLabel.snp.trailing).offset(Space.one)
            make.centerY.trailing.equalToSuperview()
            make.top.greaterThanOrEqualToSuperview()
            make.bottom.lessThanOrEqualToSuperview()
        }

        iPhoneMaskSwitchContainer.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(Space.three)
            make.right.equalToSuperview().inset(Space.three)
        }

        updateLayoutForSizeClass()
        updateComponentsListVisible()
        updateInspectorVisible()

        // MARK: Subscribe to observables

        // Tap the background to deselect the currently selected inspectable view, if any.
        playgroundBackgroundView.rx.tapGesture(configuration: { recognizer, _ in
            recognizer.cancelsTouchesInView = false
        })
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }

                self.selectedView = nil
                self.hideInspector()
                self.view.endEditing(true)
            })
            .disposed(by: disposeBag)

        showComponentsListButton.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] _ in
            self?.showComponentsList(animated: true)
        }).disposed(by: disposeBag)

        // Long press the background to reset the playground.
        playgroundBackgroundView.rx.longPressGesture(configuration: { recognizer, _ in
            recognizer.cancelsTouchesInView = false
        })
            .when(.began)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }

                self.impactFeedbackGenerator.impactOccurred()

                self.playgroundBackgroundView.backgroundColor = Color.white
                self.showComponentsList(animated: true)
                self.hideInspector()

                self.inspectableViews.forEach { inspectableView in
                    if let view = inspectableView as? UIView {
                        view.removeFromSuperview()
                    }
                }
                self.inspectableViews = []

                self.inspectableBorderViewsDisposeBag = DisposeBag()
            })
            .disposed(by: disposeBag)

        iPhoneMaskSwitch.rx.value
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }

                self.isIPhoneMaskVisible = $0

                UIView.animate(
                    withDuration: Duration.five,
                    delay: 0,
                    options: .curveEaseInOut,
                    animations: {
                        self.iPhoneMaskSwitchLabel.textColor = self.isIPhoneMaskVisible
                            ? Color.white
                            : Color.black
                        self.layoutIPhoneMask()
                    }
                )
            })
            .disposed(by: disposeBag)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        sidebarWidth = min(view.frame.width * 0.3, 300)

        updateLayoutForSizeClass()
        layoutIPhoneMask()
        updateComponentsListVisible()
        updateInspectorVisible()
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        if traitCollection.horizontalSizeClass != previousTraitCollection?.horizontalSizeClass {
            updateLayoutForSizeClass()
        }
    }

    // Shake device to change playground's background to a random color.
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        super.motionEnded(motion, with: event)

        if event?.type == .motion, motion == .motionShake {
            playgroundBackgroundView.backgroundColor = PlaygroundColorView.allColors.randomElement()!.0 // swiftlint:disable:this force_unwrapping
        }
    }

    // MARK: - Private
    // MARK: Constants
    private static let iPhoneMaskSize = CGSize(width: 375, height: 667)

    // MARK: Playground
    private let playgroundView: UIView = {
        let playgroundView = UIView()

        let mask = UIView()
        mask.backgroundColor = .black
        playgroundView.mask = mask

        return playgroundView
    }()

    private let playgroundBackgroundView: UIView = {
        let playgroundBackgroundView = UIView()
        playgroundBackgroundView.backgroundColor = Color.white
        return playgroundBackgroundView
    }()

    private let impactFeedbackGenerator = UIImpactFeedbackGenerator(style: .heavy)
    private let disposeBag = DisposeBag()
    private var sidebarWidth: CGFloat = 300

    // MARK: Components list
    private let componentsListViewController: ComponentsListViewController = {
        let componentsListViewController = ComponentsListViewController()
        componentsListViewController.title = "Components"
        return componentsListViewController
    }()

    private let showComponentsListButton: IconButton = {
        let showComponentsListButton = IconButton(icon: Icon.contentActionsAddMedium, accessibilityLabel: "Add")
        showComponentsListButton.accessibilityHint = "Add a component to the playground"
        showComponentsListButton.alpha = 0
        return showComponentsListButton
    }()

    private let componentsListShadowCard = ShadowCard()
    private var isComponentsListVisible = true

    // MARK: Inspector
    private let inspectorViewController: InspectorViewController = {
        let inspectorViewController = InspectorViewController()
        return inspectorViewController
    }()

    private let inspectorShadowCard = ShadowCard()
    private let inspectorFooter = Footer(showShadowByDefault: true)
    private var isInspectorVisible = false
    private var inspectableViews: [InspectableView] = []
    private var selectedView: (UIView & InspectableView)? {
        didSet {
            oldValue?.inspectableBorderView.isSelected = false
            selectedView?.inspectableBorderView.isSelected = true
        }
    }

    private var inspectableBorderViewsDisposeBag = DisposeBag()

    // MARK: iPhone mask
    private var iPhoneMaskSwitchContainer = UIView()
    private var iPhoneMaskSwitch = UISwitch()
    private var iPhoneMaskSwitchLabel: Label = {
        let iPhoneMaskSwitchLabel = Label(textStyle: .title7)
        iPhoneMaskSwitchLabel.text = "Show iPhone overlay:"
        return iPhoneMaskSwitchLabel
    }()

    private var isIPhoneMaskVisible: Bool = false

    // MARK: Helper functions

    /// Update playground layout after the view's size has changed.
    private func updateLayoutForSizeClass() {
        iPhoneMaskSwitchContainer.isHidden = traitCollection.horizontalSizeClass != .regular || traitCollection.verticalSizeClass != .regular

        switch traitCollection.horizontalSizeClass {
        case .regular:
            componentsListShadowCard.mainView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
            componentsListShadowCard.snp.remakeConstraints { make in
                make.leading.top.bottom.equalTo(view.safeAreaLayoutGuide).inset(Space.four)
                make.width.equalTo(sidebarWidth)
            }
            showComponentsList(animated: false)

            inspectorShadowCard.mainView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
            inspectorShadowCard.snp.remakeConstraints { make in
                make.trailing.top.bottom.equalTo(view.safeAreaLayoutGuide).inset(Space.four)
                make.width.equalTo(sidebarWidth)
            }

        case .compact, .unspecified:
            fallthrough
        @unknown default:
            componentsListShadowCard.mainView.layer.maskedCorners = []
            componentsListShadowCard.snp.remakeConstraints { make in
                make.edges.equalToSuperview()
            }
            hideComponentsList(animated: false)

            inspectorShadowCard.mainView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            inspectorShadowCard.snp.remakeConstraints { make in
                make.leading.bottom.trailing.equalToSuperview()
                make.height.equalToSuperview().multipliedBy(0.5)
            }
        }
    }

    /// Update the visibility of the components list after `isComponentsListVisible` has changed.
    private func updateComponentsListVisible() {
        switch traitCollection.horizontalSizeClass {
        case .regular:
            let translationX: CGFloat = sidebarWidth
                + Space.four // Components list's left margin
                + view.safeAreaInsets.left // Additional left margin from safe area
                + Space.two // Approximated buffer for components list's shadow
            componentsListShadowCard.transform = isComponentsListVisible
                ? .identity
                : CGAffineTransform(translationX: -translationX, y: 0)

        case .compact, .unspecified:
            fallthrough
        @unknown default:
            componentsListShadowCard.transform = isComponentsListVisible
                ? .identity
                : CGAffineTransform(translationX: 0, y: view.frame.height)
        }
    }

    /// Update the visibility of the inspector after `isInspectorVisible` has changed.
    private func updateInspectorVisible() {
        switch traitCollection.horizontalSizeClass {
        case .regular:
            let translationX: CGFloat = sidebarWidth
                + Space.four // Inspector's right margin
                + view.safeAreaInsets.right // Additional right margin from safe area
                + Space.two // Approximated buffer for inspector's shadow
            inspectorShadowCard.transform = isInspectorVisible
                ? .identity
                : CGAffineTransform(translationX: translationX, y: 0)

        case .compact, .unspecified:
            fallthrough
        @unknown default:
            inspectorShadowCard.transform = isInspectorVisible
                ? .identity
                : CGAffineTransform(translationX: 0, y: view.frame.height * 0.5 + Space.two)
        }
    }

    /// Lay out the iPhone mask after `isIPhoneMaskVisible` or the size of the playground has changed.
    private func layoutIPhoneMask() {
        playgroundView.mask?.frame = isIPhoneMaskVisible
            ? CGRect(
                x: (playgroundView.frame.width - Self.iPhoneMaskSize.width) / 2,
                y: (playgroundView.frame.height - Self.iPhoneMaskSize.height) / 2,
                width: Self.iPhoneMaskSize.width,
                height: Self.iPhoneMaskSize.height
            ) : playgroundView.bounds

        // Ensure any footers in the playground remain pinned to the mask's new frame.
        inspectableViews
            .compactMap({ $0 as? Footer })
            .forEach {
                $0.snp.remakeConstraints { make in
                    if let iPhoneMask = playgroundView.mask {
                        make.leading.equalToSuperview().inset(iPhoneMask.frame.minX)
                        make.bottom.equalToSuperview().inset(playgroundView.frame.maxY - iPhoneMask.frame.maxY)
                        make.width.equalTo(iPhoneMask.frame.width)
                    } else {
                        make.leading.trailing.bottom.equalToSuperview()
                    }
                }
            }

        // Ensure any tab bars in the playground remain pinned to the mask's new frame.
        inspectableViews
            .compactMap({ $0 as? UITabBar })
            .forEach {
                $0.snp.remakeConstraints { make in
                    if let iPhoneMask = playgroundView.mask {
                        make.leading.equalToSuperview().inset(iPhoneMask.frame.minX)
                        make.bottom.equalToSuperview().inset(playgroundView.frame.maxY - iPhoneMask.frame.maxY)
                        make.width.equalTo(iPhoneMask.frame.width)
                    } else {
                        make.leading.trailing.equalToSuperview()
                        make.bottom.equalToSuperview().inset(playgroundView.safeAreaInsets.bottom)
                    }
                }
            }
    }

    /// Show the components list
    private func showComponentsList(animated: Bool) {
        isComponentsListVisible = true

        switch traitCollection.horizontalSizeClass {
        case .regular:
            break
        case .compact, .unspecified:
            fallthrough
        @unknown default:
            if isInspectorVisible {
                hideInspector()
            }
        }

        UIView.animateKeyframes(withDuration: animated ? 0.6 : 0, delay: 0, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5) {
                self.showComponentsListButton.alpha = 0
            }

            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5) {
                self.updateComponentsListVisible()
            }
        })
    }

    /// Hide the componeents list.
    private func hideComponentsList(animated: Bool) {
        isComponentsListVisible = false

        UIView.animateKeyframes(withDuration: animated ? 0.6 : 0, delay: 0, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5) {
                self.updateComponentsListVisible()
            }

            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5) {
                self.showComponentsListButton.alpha = 1
            }
        })
    }

    /// Hide the components list (animated).
    @objc private func hideComponentsList(_ sender: Any? = nil) {
        hideComponentsList(animated: true)
    }

    /// Show the inspector (animated).
    private func showInspector() {
        guard !isInspectorVisible else { return }

        isInspectorVisible = true

        UIView.animate(withDuration: Duration.five, delay: 0, options: .curveEaseOut, animations: {
            self.updateInspectorVisible()

            let translationX: CGFloat = self.sidebarWidth
                + Space.four // Inspector's right margin
                + self.view.safeAreaInsets.right // Additional right margin from safe area
                + Space.two // Approximated buffer for inspector's shadow
            self.iPhoneMaskSwitchContainer.transform = CGAffineTransform(translationX: -translationX, y: 0)
        }, completion: nil)
    }

    /// Hide the inspector (animated).
    private func hideInspector() {
        guard isInspectorVisible else { return }

        isInspectorVisible = false

        UIView.animate(withDuration: Duration.five, delay: 0, options: .curveEaseIn, animations: {
            self.updateInspectorVisible()
            self.iPhoneMaskSwitchContainer.transform = .identity
        }, completion: nil)
    }
}

// MARK: - ComponentsListViewControllerDelegate
extension PlaygroundViewController: ComponentsListViewControllerDelegate {
    func componentsListViewController(_ componentsListViewController: ComponentsListViewController, addViewForComponent componentType: InspectableView.Type) {
        switch traitCollection.horizontalSizeClass {
        case .regular:
            break
        case .compact, .unspecified:
            fallthrough
        @unknown default:
            hideComponentsList(animated: true)
        }

        let inspectableViewToAdd = componentType.makeInspectable()
        inspectableViews.append(inspectableViewToAdd)

        if let footer = inspectableViewToAdd as? Footer {
            playgroundView.addSubview(footer)
            footer.snp.makeConstraints { make in
                make.leading.bottom.trailing.equalToSuperview()
            }

        } else if let tabBar = inspectableViewToAdd as? UITabBar {
            playgroundView.addSubview(tabBar)
            tabBar.snp.makeConstraints { make in
                make.leading.trailing.equalToSuperview()
                make.bottom.equalToSuperview().inset(playgroundView.safeAreaInsets.bottom)
            }

        } else {
            playgroundView.addSubview(inspectableViewToAdd)

            if inspectableViewToAdd.disableDrag {
                inspectableViewToAdd.snp.makeConstraints { make in
                    make.center.equalToSuperview()
                }
            } else {
                inspectableViewToAdd.makeDraggable(in: playgroundView)
                let initialPosition = randomPointInPlayground()
                inspectableViewToAdd.snp.makeConstraints { make in
                    make.centerX.equalTo(initialPosition.x)
                    make.centerY.equalTo(initialPosition.y)
                }
            }
        }

        // Tap an inspectable view to select it and open it in the inspector.
        (inspectableViewToAdd as UIView).rx.tapGesture(configuration: { recognizer, _ in
            recognizer.cancelsTouchesInView = false
        })
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self,
                      self.selectedView == nil || (self.selectedView! !== inspectableViewToAdd) // swiftlint:disable:this force_unwrapping
                else { return }

                self.selectedView = inspectableViewToAdd

                if inspectableViewToAdd.inspectableProperties.isEmpty {
                    self.hideInspector()
                } else {
                    self.inspectorViewController.inspectedView = inspectableViewToAdd
                    self.inspectorViewController.title = type(of: inspectableViewToAdd).name
                    self.showInspector()
                }
            })
            .disposed(by: inspectableBorderViewsDisposeBag)
    }

    /// Return a random point inside the playground at which a new component can be placed.
    private func randomPointInPlayground() -> CGPoint {
        var minX, maxX, minY, maxY: CGFloat
        if let iPhoneMask = playgroundView.mask {
            minX = iPhoneMask.frame.minX
            maxX = iPhoneMask.frame.maxX
            minY = iPhoneMask.frame.minY
            maxY = iPhoneMask.frame.maxY
        } else {
            minX = 0
            maxX = playgroundView.bounds.width
            minY = 0
            maxY = playgroundView.bounds.height
        }

        // Ensure point chosen isn't obscured by components list or inspector.
        if isComponentsListVisible {
            minX = max(minX, componentsListShadowCard.frame.maxX)
        }
        if isInspectorVisible {
            switch traitCollection.horizontalSizeClass {
            case .regular:
                maxX = min(maxX, inspectorShadowCard.frame.minX)
            case .compact, .unspecified:
                fallthrough
            @unknown default:
                maxY = min(maxY, inspectorShadowCard.frame.minY)
            }
        }

        return CGPoint(x: CGFloat.random(in: minX ... maxX),
                       y: CGFloat.random(in: minY ... maxY))
    }
}
