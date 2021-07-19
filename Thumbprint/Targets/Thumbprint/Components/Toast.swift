import UIKit

private protocol ToastViewDelegate: AnyObject {
    func actionDidFire()
}

/**
 * A wrapper around ToastView to handle the toast presentation and dismissal animations
 */
public class Toast: UIView {
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

    private let onTimeout: (() -> Void)?
    private var didTriggerAction: Bool = false
    private var hideToastConstraint: NSLayoutConstraint?
    private let toastView: ToastView

    private lazy var slidingContainer = UIView()

    public init(message: String,
                action: Toast.Action? = nil,
                presentationDuration: TimeInterval = 5.0,
                onTimeout: (() -> Void)? = nil) {
        self.presentationDuration = presentationDuration
        self.toastView = ToastView(message: message, action: action)
        self.onTimeout = onTimeout

        super.init(frame: .null)

        toastView.delegate = self

        slidingContainer.addManagedSubview(toastView)
        addManagedSubview(slidingContainer)

        let leftRightPadding: CGFloat = 16
        let bottomOffset: CGFloat = 8

        toastView.snapToSuperviewEdges(.all)

        slidingContainer.snapToSuperviewEdges(.horizontal, inset: leftRightPadding)
        hideToastConstraint = slidingContainer.topAnchor.constraint(equalTo: bottomAnchor)
        let bottomConstraint = slidingContainer.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -bottomOffset)
        bottomConstraint.priority = .defaultLow
        let heightConstraint = slidingContainer.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 1.0, constant: -bottomOffset)
        heightConstraint.priority = .sceneSizeStayPut
        NSLayoutConstraint.activate([bottomConstraint, heightConstraint])
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
                self.hideToastConstraint?.isActive = false
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
                self.hideToastConstraint?.isActive = true
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
        toastView.linkButton?.isEnabled = false
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
            if let action = action {
                linkButton?.title = action.text
            }
        }
    }

    fileprivate weak var delegate: ToastViewDelegate?

    private lazy var stackView: UIStackView = makeStackView()
    private lazy var messageLabel: UILabel = makeMessageLabel()
    fileprivate lazy var linkButton: Button? = makeActionButton()

    public init(message: String, action: Toast.Action? = nil) {
        self.message = message
        self.action = action

        super.init(frame: .null)

        let topBottomPadding: CGFloat = 8
        let leftRightPadding: CGFloat = 16

        backgroundColor = Color.black
        clipsToBounds = true
        layer.cornerRadius = CornerRadius.base

        addManagedSubview(stackView)
        stackView.snapToSuperviewEdges(.horizontal, inset: leftRightPadding)
        stackView.snapToSuperviewEdges(.vertical, inset: topBottomPadding)
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
        label.textColor = Color.white
        label.text = message
        label.textAlignment = .left
        label.numberOfLines = 0
        label.setContentHuggingPriority(.required, for: .vertical)
        return label
    }

    func makeActionButton() -> Button? {
        guard let actionText = action?.text else { return nil }
        let button = Button(theme: .link, size: .text)
        button.contentHorizontalAlignment = .right
        button.title = actionText
        button.addTarget(self, action: #selector(didTapActionButton), for: .touchUpInside)
        button.setContentHuggingPriority(.required, for: .vertical)
        button.setContentHuggingPriority(.required, for: .horizontal)
        return button
    }

    func makeStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
        stackView.setContentHuggingPriority(.required, for: .vertical)

        stackView.addArrangedSubview(messageLabel)
        if let linkButton = self.linkButton { stackView.addArrangedSubview(linkButton) }

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
