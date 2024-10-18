import Combine
import SnapKit
import UIKit

private protocol ToastViewDelegate: AnyObject {
    func actionDidFire()
}

private class KeyboardTracker {
    var keyboardHeight: CGFloat = 0
    let keyboardNotificationPublisher = PassthroughSubject<NotificationCenter.Publisher.Output, Never>()
    private var subscriptions = Set<AnyCancellable>()

    init() {
        NotificationCenter.default.publisher(for: UIView.keyboardWillShowNotification).sink { notification in
            self.keyboardHeight = (notification.userInfo?[UIView.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height ?? 0
            self.keyboardNotificationPublisher.send(notification)
        }.store(in: &subscriptions)
        NotificationCenter.default.publisher(for: UIView.keyboardWillHideNotification).sink { notification in
            self.keyboardHeight = 0
            self.keyboardNotificationPublisher.send(notification)
        }.store(in: &subscriptions)
    }
}

/**
 * A wrapper around ToastView to handle the toast presentation and dismissal animations
 */
public class Toast: UIView {
    public struct Theme: Equatable, Sendable {
        public let backgroundColor: UIColor
        public let textColor: UIColor
        public let iconColor: UIColor
        public let icon: Icon?

        private init(backgroundColor: UIColor, textColor: UIColor, iconColor: UIColor, icon: Icon?) {
            self.backgroundColor = backgroundColor
            self.textColor = textColor
            self.iconColor = iconColor
            self.icon = icon
        }

        public static func `default`(_ icon: Icon? = nil) -> Theme {
            Theme(backgroundColor: Color.black, textColor: Color.white, iconColor: Color.white, icon: icon)
        }

        public static func alert(_ icon: Icon? = Icon.notificationAlertsBlockedFilledMedium) -> Theme {
            Theme(backgroundColor: Color.red500, textColor: Color.white, iconColor: Color.white, icon: icon)
        }

        public static func success(_ icon: Icon? = Icon.contentModifierCircleCheckFilledMedium) -> Theme {
            Theme(backgroundColor: Color.green500, textColor: Color.white, iconColor: Color.white, icon: icon)
        }

        public static func info(_ icon: Icon? = Icon.notificationAlertsInfoFilledMedium) -> Theme {
            Theme(backgroundColor: Color.blue500, textColor: Color.white, iconColor: Color.white, icon: icon)
        }

        public static func caution(_ icon: Icon? = Icon.notificationAlertsWarningFilledMedium) -> Theme {
            Theme(backgroundColor: Color.yellow300, textColor: Color.black, iconColor: Color.black, icon: icon)
        }
    }

    private static var keyboardTracker: KeyboardTracker?

    /// Call this function inside of UIApplicationDelegate's application(_:didFinishLaunchingWithOptions:)
    /// to have toasts reposition themselves above the software keyboard
    public static func registerForKeyboardNotifications() {
        keyboardTracker = KeyboardTracker()
    }

    public struct Action {
        public let text: String
        public let handler: () -> Void

        public init(text: String, handler: @escaping () -> Void) {
            self.text = text
            self.handler = handler
        }
    }

    public let presentationDuration: TimeInterval

    public var message: String {
        get { toastView.message }
        set { toastView.message = newValue }
    }

    public var action: Toast.Action? {
        get { toastView.action }
        set { toastView.action = newValue }
    }

    public var theme: Toast.Theme {
        get { toastView.theme }
        set { toastView.theme = newValue }
    }

    private let onTimeout: (() -> Void)?
    private var didTriggerAction: Bool = false
    private var hideToastConstraint: Constraint?
    private let toastView: ToastView
    private var subscriptions = Set<AnyCancellable>()

    private let leftRightPadding: CGFloat = 16
    private var bottomConstraint: Constraint?

    private var bottomInset: CGFloat {
        (Self.keyboardTracker?.keyboardHeight ?? 0) + 8
    }

    private lazy var slidingContainer = UIView()

    public init(message: String,
                theme: Toast.Theme = Toast.Theme.default(),
                action: Toast.Action? = nil,
                presentationDuration: TimeInterval = 5.0,
                onTimeout: (() -> Void)? = nil) {
        self.presentationDuration = presentationDuration
        self.toastView = ToastView(message: message, theme: theme, action: action)
        self.onTimeout = onTimeout

        super.init(frame: .null)

        toastView.delegate = self

        slidingContainer.addSubview(toastView)
        addSubview(slidingContainer)

        toastView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        slidingContainer.snp.makeConstraints { make in
            self.hideToastConstraint = make.top.equalTo(self.snp.bottom).priority(.required).constraint
            make.left.right.equalToSuperview().inset(leftRightPadding)
            self.bottomConstraint = make.bottom.equalToSuperview().inset(bottomInset).priority(.medium).constraint
            make.height.equalToSuperview().offset(-bottomInset).priority(.medium)
        }

        Self.keyboardTracker?.keyboardNotificationPublisher.sink(receiveValue: { [weak self] notification in
            self?.updateBottomConstraint(notification: notification)
        }).store(in: &subscriptions)
    }

    private func updateBottomConstraint(notification: NotificationCenter.Publisher.Output) {
        let durationKey = UIResponder.keyboardAnimationDurationUserInfoKey
        let duration = notification.userInfo![durationKey] as! Double

        let curveKey = UIResponder.keyboardAnimationCurveUserInfoKey
        let curveValue = notification.userInfo![curveKey] as! Int
        let curve = UIView.AnimationCurve(rawValue: curveValue)!

        let animator = UIViewPropertyAnimator(
            duration: duration,
            curve: curve
        ) {
            self.bottomConstraint?.update(inset: self.bottomInset)
            self.layoutIfNeeded()
        }

        animator.startAnimation()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Toast Presentation Animators
    public func showToast(animated: Bool = true, completion: (() -> Void)? = nil) {
        alpha = 1
        layoutIfNeeded()
        UIView.animate(
            withDuration: animated ? 0.65 : 0,
            delay: 0,
            usingSpringWithDamping: 0.58,
            initialSpringVelocity: 0.8,
            options: [.curveEaseInOut],
            animations: { [weak self] in
                guard let self else { return }
                hideToastConstraint?.deactivate()
                layoutIfNeeded()
            },
            completion: { _ in completion?() }
        )
    }

    public func hideToast(animated: Bool = true, completion: (() -> Void)? = nil) {
        guard superview != nil else { return }
        layoutIfNeeded()
        UIView.animate(
            withDuration: animated ? Duration.three : 0,
            delay: 0,
            options: [.curveEaseInOut],
            animations: { [weak self] in
                guard let self else { return }
                hideToastConstraint?.activate()
                alpha = 0
                layoutIfNeeded()
            },
            completion: { _ in completion?() }
        )
    }

    public func didDismiss() {
        if !didTriggerAction {
            onTimeout?()
        }
    }
}

extension Toast: ToastViewDelegate {
    func actionDidFire() {
        didTriggerAction = true
        toastView.linkButton.isEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.hideToast(animated: true)
        }
    }
}

public class ToastView: UIView {
    public var message: String {
        didSet {
            messageLabel.text = message
        }
    }

    public var action: Toast.Action? {
        didSet {
            updateLinkButton()
        }
    }

    public var theme: Toast.Theme {
        didSet {
            messageLabel.textColor = theme.textColor
            backgroundColor = theme.backgroundColor
            iconView.tintColor = theme.iconColor
            updateLinkButton()
            updateIconView()
        }
    }

    fileprivate weak var delegate: ToastViewDelegate?

    private lazy var stackView: UIStackView = makeStackView()
    private lazy var messageLabel: UILabel = makeMessageLabel()
    private lazy var iconView: UIImageView = makeIconView()
    private lazy var iconContainerView: UIView = .init()
    fileprivate lazy var linkButton: UIButton = makeActionButton()

    private func updateLinkButton() {
        guard let action else {
            linkButton.showsInStackView = false
            return
        }
        linkButton.showsInStackView = true
        let textStyle = Font.TextStyle.title6

        let attributedTitle = NSAttributedString(string: action.text, attributes: [
            .foregroundColor: theme.textColor,
            .font: textStyle.scaledFont(compatibleWith: .current),
            .underlineStyle: NSUnderlineStyle.single.rawValue,
        ])

        linkButton.setAttributedTitle(attributedTitle, for: .normal)
    }

    private func updateIconView() {
        iconContainerView.showsInStackView = theme.icon != nil
        iconView.image = theme.icon?.image
    }

    public init(message: String, theme: Toast.Theme, action: Toast.Action? = nil) {
        self.message = message
        self.action = action
        self.theme = theme

        super.init(frame: .null)

        let topBottomPadding: CGFloat = Space.three
        let leftRightPadding: CGFloat = Space.three

        backgroundColor = theme.backgroundColor
        clipsToBounds = true
        layer.cornerRadius = CornerRadius.base

        iconContainerView.addSubview(iconView)
        iconView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.bottom.lessThanOrEqualToSuperview()
        }
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(leftRightPadding)
            make.top.bottom.equalToSuperview().inset(topBottomPadding)
        }
        updateLinkButton()
        updateIconView()
    }

    @available(*, unavailable)
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - View Constructors
private extension ToastView {
    func makeMessageLabel() -> UILabel {
        let label = Label(textStyle: .text1, adjustsFontForContentSizeCategory: false)
        label.textColor = theme.textColor
        label.text = message
        label.textAlignment = .left
        label.numberOfLines = 0
        label.setContentHuggingPriority(.required, for: .vertical)
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return label
    }

    func makeIconView() -> UIImageView {
        let imageView = UIImageView()
        imageView.setContentHuggingPriority(.required, for: .horizontal)
        imageView.setContentCompressionResistancePriority(.required, for: .vertical)
        imageView.setContentCompressionResistancePriority(.required, for: .horizontal)
        imageView.tintColor = theme.iconColor
        return imageView
    }

    func makeActionButton() -> UIButton {
        let button = UIButton()
        button.contentHorizontalAlignment = .right
        button.addTarget(self, action: #selector(didTapActionButton), for: .touchUpInside)
        button.setContentHuggingPriority(.required, for: .horizontal)
        button.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        return button
    }

    func makeStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = Space.two
        stackView.alignment = .center
        stackView.setContentHuggingPriority(.required, for: .vertical)

        stackView.addArrangedSubview(iconContainerView)
        iconContainerView.snp.makeConstraints { make in
            make.height.equalToSuperview()
        }

        stackView.addArrangedSubview(messageLabel)
        stackView.addArrangedSubview(linkButton)

        stackView.setCustomSpacing(Space.three, after: messageLabel)

        return stackView
    }
}

// MARK: - Actions
private extension ToastView {
    @objc func didTapActionButton() {
        action?.handler()
        delegate?.actionDidFire()
    }
}
