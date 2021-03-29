import SnapKit
// import ThumbprintResources
import UIKit

// MARK: - Protocols
public protocol RadioGroupDelegate: AnyObject {
    func radioGroup(_ radioGroup: RadioGroup, didSelect radio: Radio?)
}

public protocol RadioStackDelegate: AnyObject {
    func radioStack(_ radioStack: RadioStack, didSelectRadioAt index: Int?)
}

// MARK: - RadioGroup
// The collective state manager for a set of related radios
// Changes to the selected radio are notified via the radioGroup(_ : didSelect:) method of the RadioGroup delegate.
public final class RadioGroup {
    public weak var delegate: RadioGroupDelegate?

    public init(delegate: RadioGroupDelegate? = nil) {
        self.delegate = delegate
    }

    private var radios: Set<Radio> = []
    public var selectedRadio: Radio? {
        didSet {
            guard selectedRadio == nil || radios.contains(selectedRadio!) else { // swiftlint:disable:this force_unwrapping
                assertionFailure("Cannot select a radio that has not been registered with this group")
                selectedRadio = nil
                return
            }

            guard selectedRadio != oldValue else { return }
            if selectedRadio?.isSelected != true { selectedRadio?.isSelected = true }

            oldValue?.isSelected = false
            delegate?.radioGroup(self, didSelect: selectedRadio)
        }
    }

    public func registerRadio(_ radio: Radio) {
        guard !radios.contains(radio) else { return }

        radio.addTarget(self, action: #selector(radioIsSelectedDidChange(_:)), for: .valueChanged)
        radios.insert(radio)
    }

    @objc private func radioIsSelectedDidChange(_ sender: Radio) {
        if sender.isSelected {
            selectedRadio = sender
        }
    }

    public func unregisterRadio(_ radio: Radio) {
        guard radios.contains(radio) else { return }

        if radio == selectedRadio { selectedRadio = nil }
        radio.removeTarget(self, action: #selector(radioIsSelectedDidChange(_:)), for: .valueChanged)
        radios.remove(radio)
    }
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

// MARK: - Radio Stack
/// A convenience class for displaying a group of text only radioViews with consistent styling and spacing.
public final class RadioStack: UIView, RadioGroupDelegate, UIContentSizeCategoryAdjusting {
    /// The radios belonging to this stack
    let radioViews: [Radio]

    /// A delegate conforming to RadioStackDelegate
    public weak var delegate: RadioStackDelegate?

    public var spacing: CGFloat {
        get { stack.spacing }
        set { stack.spacing = newValue }
    }

    /// Sets the numberOfLines of each `Radio` in the stack.
    public var numberOfLines: Int = 1 {
        didSet {
            radioViews.forEach { $0.numberOfLines = numberOfLines }
        }
    }

    public var adjustsFontForContentSizeCategory: Bool {
        didSet {
            guard adjustsFontForContentSizeCategory != oldValue else { return }

            for radio in radioViews {
                radio.adjustsFontForContentSizeCategory = adjustsFontForContentSizeCategory
            }
        }
    }

    private let stack: UIStackView
    private let radioGroup: RadioGroup

    /// Initializes a new RadioStack with the given radio titles
    ///
    /// - Parameters:
    ///   - titles: An array of titles with which to create the radio buttons
    ///   - adjustsFontForContentSizeCategory: Boolean indicating whether the radios in this stack should support Dynamic Type.
    public init(titles: [String], adjustsFontForContentSizeCategory: Bool = true) {
        self.radioGroup = RadioGroup()
        self.radioViews = titles.map({ Radio(text: $0, adjustsFontForContentSizeCategory: adjustsFontForContentSizeCategory) })
        self.adjustsFontForContentSizeCategory = adjustsFontForContentSizeCategory

        self.stack = UIStackView(arrangedSubviews: radioViews)
        stack.axis = .vertical
        stack.alignment = .leading
        stack.spacing = Space.three

        super.init(frame: .null)

        radioViews.forEach({ radioGroup.registerRadio($0) })
        radioGroup.delegate = self

        addSubview(stack)

        stack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func setSelectedTitle(_ title: String) {
        radioGroup.selectedRadio = radioViews.first(where: { $0.text == title })
    }

    // RadioGroupDelegate
    public func radioGroup(_ radioGroup: RadioGroup, didSelect radio: Radio?) {
        if let radio = radio {
            delegate?.radioStack(self, didSelectRadioAt: radioViews.firstIndex(of: radio))
        } else {
            delegate?.radioStack(self, didSelectRadioAt: nil)
        }
    }
}

// MARK: - RadioImage
internal class RadioImage: UIView {
    override var intrinsicContentSize: CGSize {
        CGSize(width: 20, height: 20)
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
