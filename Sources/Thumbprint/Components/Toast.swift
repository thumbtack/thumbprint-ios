import SnapKit
import UIKit

private protocol ToastViewDelegate: AnyObject {
    func actionDidFire()
}

/**
 * A wrapper around ToastView to handle the toast presentation and dismissal animations
 */
public class Toast: UIView {
    public enum IconType: Equatable {
        case defaultForTheme
        case custom(Icon?)

        func resolvedIcon(for theme: Toast.Theme) -> Icon? {
            switch self {
            case let .custom(icon):
                return icon
            case .defaultForTheme:
                return theme.defaultIcon
            }
        }
    }

    public enum Theme {
        case `default`
        case alert
        case success
        case info
        case caution

        var backgroundColor: UIColor {
            switch self {
            case .default:
                return Color.black
            case .alert:
                return Color.red500
            case .success:
                return Color.green500
            case .info:
                return Color.blue500
            case .caution:
                return Color.yellow300
            }
        }

        var textColor: UIColor {
            switch self {
            case .default, .alert, .success, .info:
                return Color.white
            case .caution:
                return Color.black
            }
        }

        var iconColor: UIColor {
            switch self {
            case .default, .alert, .success, .info:
                return Color.white
            case .caution:
                return Color.black
            }
        }

        var defaultIcon: Icon? {
            switch self {
            case .default:
                return nil
            case .alert:
                return Icon.notificationAlertsBlockedFilledMedium
            case .caution:
                return Icon.notificationAlertsWarningFilledMedium
            case .info:
                return Icon.notificationAlertsInfoFilledMedium
            case .success:
                return Icon.contentModifierCircleCheckFilledMedium
            }
        }
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

    public var iconType: Toast.IconType {
        get { toastView.iconType }
        set { toastView.iconType = newValue }
    }

    public var theme: Toast.Theme {
        get { toastView.theme }
        set { toastView.theme = newValue }
    }

    private let onTimeout: (() -> Void)?
    private var didTriggerAction: Bool = false
    private var hideToastConstraint: Constraint?
    private let toastView: ToastView

    private lazy var slidingContainer = UIView()

    public init(message: String,
                theme: Toast.Theme = .default,
                iconType: Toast.IconType = .defaultForTheme,
                action: Toast.Action? = nil,
                presentationDuration: TimeInterval = 5.0,
                onTimeout: (() -> Void)? = nil) {
        self.presentationDuration = presentationDuration
        self.toastView = ToastView(message: message, theme: theme, iconType: iconType, action: action)
        self.onTimeout = onTimeout

        super.init(frame: .null)

        toastView.delegate = self

        slidingContainer.addSubview(toastView)
        addSubview(slidingContainer)

        let leftRightPadding: CGFloat = 16
        let bottomOffset: CGFloat = 8

        toastView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        slidingContainer.snp.makeConstraints { make in
            self.hideToastConstraint = make.top.equalTo(self.snp.bottom).priority(.required).constraint
            make.left.right.equalToSuperview().inset(leftRightPadding)
            make.bottom.equalToSuperview().offset(-bottomOffset).priority(.low)
            make.height.equalToSuperview().offset(-bottomOffset).priority(.medium)
        }
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
                guard let self = self else { return }
                self.hideToastConstraint?.deactivate()
                self.layoutIfNeeded()
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
                guard let self = self else { return }
                self.hideToastConstraint?.activate()
                self.alpha = 0
                self.layoutIfNeeded()
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

    var resolvedIcon: Icon? {
        return iconType.resolvedIcon(for: theme)
    }

    public var iconType: Toast.IconType {
        didSet {
            updateIconView()
        }
    }

    fileprivate weak var delegate: ToastViewDelegate?

    private lazy var stackView: UIStackView = makeStackView()
    private lazy var messageLabel: UILabel = makeMessageLabel()
    private lazy var iconView: UIImageView = makeIconView()
    private lazy var iconContainerView: UIView = UIView()
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
        iconContainerView.showsInStackView = resolvedIcon != nil
        iconView.image = resolvedIcon?.image
    }

    public init(message: String, theme: Toast.Theme, iconType: Toast.IconType, action: Toast.Action? = nil) {
        self.message = message
        self.action = action
        self.theme = theme
        self.iconType = iconType

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
