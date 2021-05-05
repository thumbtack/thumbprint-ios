import Combine
import SnapKit
import UIKit

// MARK: - Protocols
public protocol RadioStackDelegate: AnyObject {
    func radioStack(_ radioStack: RadioStack, didSelectRadioAt index: Int?)
}

// MARK: - Radio
/// A radio control, associated with a radio group, that affords a single selection among a group of options.
public final class Radio: Control, UIContentSizeCategoryAdjusting {
    // MARK: - Public State Management

    /// True if the radio is in an erroneous state. Radios in an error state display in red.
    public var hasError: Bool = false { didSet { updateInputState() } }

    /// True if the radio should be available for user selection. Disabled radios display in gray.
    public override var isEnabled: Bool { didSet { updateInputState() } }

    /// True if the radio should highlight.  Highlighted radios display in blue.
    public override var isHighlighted: Bool { didSet { updateInputState() } }

    /// True if the user is currently interacting with the radio. Selected radios display with a blue dot fill.
    public override var isSelected: Bool {
        didSet {
            guard isSelected != oldValue else { return }

            radioImage.isSelected = isSelected
            sendActions(for: .valueChanged)
            updateInputState()
        }
    }

    /// Sets the text of the radio label. If the radio was initialized with a custom view, this has no effect
    public var text: String? {
        get { (contentView as? Label)?.text }
        set { (contentView as? Label)?.text = newValue }
    }

    /// Sets the numberOfLines of the radio label. If the radio was initialized with a custom view, this has no
    /// effect
    public var numberOfLines: Int = 1 {
        didSet {
            guard let label = contentView as? Label else { return }
            label.numberOfLines = numberOfLines
        }
    }

    /// Sets the textStyle of the radius label. If the radius was initialized with a custom view, this has no
    /// effect
    public var textStyle: Font.TextStyle = .text1 {
        didSet {
            guard let label = contentView as? Label else { return }
            label.textStyle = textStyle
        }
    }

    public var adjustsFontForContentSizeCategory: Bool {
        didSet {
            guard adjustsFontForContentSizeCategory != oldValue else { return }

            (contentView as? UIContentSizeCategoryAdjusting)?.adjustsFontForContentSizeCategory = adjustsFontForContentSizeCategory
        }
    }

    // MARK: - First Responder Overrides
    public override var canBecomeFirstResponder: Bool { true }

    @discardableResult
    public override func becomeFirstResponder() -> Bool {
        defer { isSelected = true }
        return super.becomeFirstResponder()
    }

    @discardableResult
    public override func resignFirstResponder() -> Bool {
        defer { updateInputState() }
        return super.resignFirstResponder()
    }

    // MARK: - Layout
    public let contentView: UIView?

    public override var forFirstBaselineLayout: UIView {
        contentView?.forFirstBaselineLayout ?? super.forFirstBaselineLayout
    }

    public override var forLastBaselineLayout: UIView {
        contentView?.forLastBaselineLayout ?? super.forLastBaselineLayout
    }

    // MARK: - Internal Implementation
    internal let radioImage = RadioImage()

    // MARK: - Private Implementation
    private let containerView = UIView()
    private var radioImageCenterYConstraint: Constraint?

    /// Initializes a new radio with default styled text. The radio will create and manage the state (visually) of
    /// the created label.
    ///
    /// - Parameters:
    ///    - text: The text to display next to the radio
    ///    - adjustsFontForContentSizeCategory: Boolean indicating whether the label should support Dynamic Type.
    public convenience init(text: String?, adjustsFontForContentSizeCategory: Bool = true) {
        let label = Label(
            textStyle: Font.TextStyle.text1,
            adjustsFontForContentSizeCategory: adjustsFontForContentSizeCategory
        )
        label.text = text
        label.setContentHuggingPriority(.required, for: .vertical)
        self.init(contentView: label, adjustsFontForContentSizeCategory: adjustsFontForContentSizeCategory)
    }

    /// Initializes a new radio with an optional contentView view.
    /// If the contentView conforms to InputStateConfigurable, it will receive callbacks when the radio's state changes.
    /// If contentView is nil, only a radio control will be displayed
    ///
    /// - Parameters:
    ///    - contentView: The view to display next to the radio, or nil to display a radio by itself
    public init(contentView: UIView? = nil, adjustsFontForContentSizeCategory: Bool = true) {
        self.contentView = contentView
        self.adjustsFontForContentSizeCategory = adjustsFontForContentSizeCategory

        super.init(frame: .null)

        addSubview(containerView)

        containerView.addSubview(radioImage)

        if let contentView = contentView {
            (contentView as? UIContentSizeCategoryAdjusting)?.adjustsFontForContentSizeCategory = adjustsFontForContentSizeCategory
            containerView.addSubview(contentView)

            contentView.snp.makeConstraints { make in
                make.left.equalTo(radioImage.snp.right).offset(Space.two)
                make.top.equalToSuperview().priority(.low)
                make.right.equalToSuperview()
                make.bottom.equalToSuperview().priority(.low)
            }

            containerView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
                make.height.greaterThanOrEqualTo(contentView)
            }

            radioImage.snp.makeConstraints { make in
                make.left.equalToSuperview()
                make.size.equalTo(radioImage.intrinsicContentSize)
                if let label = contentView as? UILabel {
                    radioImageCenterYConstraint = make.centerY.equalTo(label.snp.firstBaseline).offset(-label.font.capHeight / 2.0).constraint
                    make.top.equalToSuperview().priority(.low)
                    make.top.greaterThanOrEqualToSuperview()
                } else {
                    make.top.equalToSuperview()
                }
            }

        } else {
            containerView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }

            radioImage.snp.makeConstraints { make in
                make.edges.equalToSuperview()
                make.size.equalTo(radioImage.intrinsicContentSize)
            }
        }

        addTapRecognizer()
        updateInputState()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if traitCollection.preferredContentSizeCategory != previousTraitCollection?.preferredContentSizeCategory {
            setNeedsUpdateConstraints()
        }
    }

    public override func updateConstraints() {
        if let label = contentView as? UILabel {
            radioImageCenterYConstraint?.update(offset: -label.font.capHeight / 2.0)
        }

        super.updateConstraints()
    }

    private func updateInputState() {
        let inputState = self.inputState(hasError: hasError)
        radioImage.isSelected = isSelected
        radioImage.inputState = inputState

        if let inputConfigurableView = contentView as? InputStateConfigurable {
            inputConfigurableView.inputStateDidChange(to: inputState)
        }
    }

    private func addTapRecognizer() {
        let tapRecognizer = UITapGestureRecognizer()
        addGestureRecognizer(tapRecognizer)
        tapRecognizer.addTarget(self, action: #selector(didTap))
    }

    @objc private func didTap() {
        sendActions(for: .touchUpInside)
        isSelected = true
    }
}

// MARK: - RadioImage
internal class RadioImage: UIView {
    override var intrinsicContentSize: CGSize {
        Self.backgroundFillImage?.size ?? super.intrinsicContentSize
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        intrinsicContentSize
    }

    var isSelected: Bool = false {
        didSet {
            innerDot.isHidden = !isSelected
        }
    }

    var inputState: InputState = .default {
        didSet {
            updateInnerCircleColor()
            updateOuterCircleColor()
        }
    }

    private func updateInnerCircleColor() {
        switch inputState {
        case .default, .highlighted:
            innerDot.tintColor = Color.blue
        case .disabled:
            innerDot.tintColor = Color.gray
        case .error:
            innerDot.tintColor = Color.red
        }
    }

    private func updateOuterCircleColor() {
        switch inputState {
        case .default:
            outerRing.tintColor = isSelected ? Color.blue : Color.gray
            backgroundFill.tintColor = .clear
        case .disabled:
            outerRing.tintColor = Color.gray300
            backgroundFill.tintColor = Color.white
        case .error:
            outerRing.tintColor = Color.red
            backgroundFill.tintColor = .clear
        case .highlighted:
            outerRing.tintColor = Color.blue
            backgroundFill.tintColor = .clear
        }
    }

    private let innerDot: UIImageView
    private let outerRing: UIImageView
    private let backgroundFill: UIImageView

    private static let innerDotImage = UIImage(named: "Radio-InnerDot", in: Bundle.thumbprint, compatibleWith: nil)
    private static let outerRingImage = UIImage(named: "Radio-OuterRing", in: Bundle.thumbprint, compatibleWith: nil)
    private static let backgroundFillImage = UIImage(named: "Radio-BackgroundFill", in: Bundle.thumbprint, compatibleWith: nil)

    init() {
        assert(RadioImage.innerDotImage != nil, "InnerDotImage should not be nil")
        assert(RadioImage.outerRingImage != nil, "OuterRingImage should not be nil")
        assert(RadioImage.backgroundFillImage != nil, "BackgroundFillImage should not be nil")

        self.innerDot = UIImageView(image: RadioImage.innerDotImage)
        self.outerRing = UIImageView(image: RadioImage.outerRingImage)
        self.backgroundFill = UIImageView(image: RadioImage.backgroundFillImage)

        super.init(frame: .null)

        addSubview(backgroundFill)
        addSubview(outerRing)
        addSubview(innerDot)

        backgroundFill.snp.makeConstraints { make in
            make.size.equalTo(RadioImage.backgroundFillImage?.size ?? .zero)
            make.edges.equalToSuperview()
        }

        outerRing.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        innerDot.snp.makeConstraints { make in
            make.size.equalTo(RadioImage.innerDotImage?.size ?? .zero)
            make.center.equalToSuperview()
        }

        backgroundColor = .clear

        defer { // swiftlint:disable:this inert_defer
            isSelected = false
            inputState = .default
        }
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
