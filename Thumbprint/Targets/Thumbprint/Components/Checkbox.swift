import UIKit

public final class LabeledCheckbox: Control, UIContentSizeCategoryAdjusting {
    public enum ContentPlacement: String {
        case left
        case right
    }

    // MARK: - Public State Management
    /// The mark displayed within the checkbox.  One of: empty, intermediate, or checked
    public var mark: Checkbox.Mark {
        get {
            checkbox.mark
        }
        set {
            checkbox.mark = newValue
        }
    }

    /// True if the checkbox is in an error state. If true, checkbox and optional label display in red.
    public var hasError: Bool {
        get {
            checkbox.hasError
        }
        set {
            checkbox.hasError = newValue
            setNeedsLayout()
        }
    }

    /// Sets the text of the checkbox label. If the checkbox was initialized with a custom view, this has no effect
    public var text: String? {
        get {
            label.text
        }
        set {
            label.text = newValue
        }
    }

    /// Sets the attributed text of the checkbox label. If the checkbox was initialized with a custom view, this has no effect.
    public var attributedText: NSAttributedString? {
        get {
            label.attributedText
        }
        set {
            label.attributedText = newValue
        }
    }

    /// Sets the content placement in accordance to the checkbox. If right, content will be placed to the right of the checkbox.
    public var contentPlacement: ContentPlacement = .right {
        didSet {
            if contentPlacement != oldValue {
                if contentPlacement == .right {
                    label.textAlignment = .left
                    NSLayoutConstraint.deactivate(leftAlignmentConstraints)
                    NSLayoutConstraint.activate(rightAlignmentConstraints)
                } else {
                    label.textAlignment = .right
                    NSLayoutConstraint.deactivate(rightAlignmentConstraints)
                    NSLayoutConstraint.activate(leftAlignmentConstraints)
                }
            }
        }
    }

    /// Sets the numberOfLines of the checkbox label. If the checkbox was initialized with a custom view, this has no
    /// effect
    public var numberOfLines: Int {
        get {
            label.numberOfLines
        }
        set {
            label.numberOfLines = newValue
        }
    }

    /// Sets the textStyle of the checkbox label. If the checkbox was initialized with a custom view, this has no
    /// effect
    public var textStyle: Font.TextStyle {
        get {
            label.textStyle
        }
        set {
            label.textStyle = newValue
            setNeedsUpdateConstraints()
        }
    }

    public var contentInsets: UIEdgeInsets = .zero {
        didSet {
            if contentInsets != oldValue {
                labelLeftSuperviewConstraint.constant = contentInsets.left
                checkboxLeftSuperviewConstraint.constant = contentInsets.left

                labelRightSuperviewConstraint.constant = 0 - contentInsets.right
                checkboxRightSuperviewConstraint.constant = 0 - contentInsets.right

                labelTopConstraint.constant = contentInsets.top
                checkboxTopConstraint.constant = contentInsets.top

                labelBottomConstraint.constant = 0 - contentInsets.bottom
                checkboxBottomConstraint.constant = 0 - contentInsets.bottom
            }
        }
    }

    /// If false, prevents user from interacting with the view and displays checkbox and optional label in gray.
    public override var isEnabled: Bool {
        didSet {
            checkbox.isEnabled = isEnabled
            setNeedsLayout()
        }
    }

    /// If true, overrides default input state to display checkbox in blue.
    /// Note: Checkbox will not appear selected if isEnabled == false, or hasError = true
    public override var isHighlighted: Bool {
        didSet {
            checkbox.isHighlighted = isHighlighted
        }
    }

    public override var isSelected: Bool {
        didSet {
            checkbox.isSelected = isSelected
        }
    }

    public var adjustsFontForContentSizeCategory: Bool {
        didSet {
            guard adjustsFontForContentSizeCategory != oldValue else { return }

            label.adjustsFontForContentSizeCategory = adjustsFontForContentSizeCategory
        }
    }

    // MARK: - Layout
    public override var forFirstBaselineLayout: UIView {
        label.forFirstBaselineLayout
    }

    public override var forLastBaselineLayout: UIView {
        label.forLastBaselineLayout
    }

    /// Sets the size of one checkbox edge (the checkbox is always square).  Defaults to 20.
    public var checkBoxSize: CGFloat {
        get {
            checkbox.checkBoxSize
        }
        set {
            checkbox.checkBoxSize = newValue
        }
    }

    // MARK: - Private Implementation
    private let checkbox = Checkbox()
    private let label: Label
    private var checkboxIconCenterYConstraint: NSLayoutConstraint?

    private lazy var checkboxLeftSuperviewConstraint = checkbox.leftAnchor.constraint(equalTo: leftAnchor)
    private lazy var checkboxRightSuperviewConstraint = checkbox.rightAnchor.constraint(equalTo: rightAnchor)
    private lazy var labelLeftSuperviewConstraint = label.leftAnchor.constraint(equalTo: leftAnchor)
    private lazy var labelRightSuperviewConstraint = label.rightAnchor.constraint(equalTo: rightAnchor)

    private lazy var labelTopConstraint = label.topAnchor.constraint(greaterThanOrEqualTo: topAnchor)
    private lazy var labelBottomConstraint = label.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor)
    private lazy var checkboxTopConstraint = checkbox.topAnchor.constraint(greaterThanOrEqualTo: topAnchor)
    private lazy var checkboxBottomConstraint = checkbox.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor)

    private lazy var leftAlignmentConstraints: [NSLayoutConstraint] = [
        label.rightAnchor.constraint(equalTo: checkbox.leftAnchor, constant: 0 - Space.two),
        labelLeftSuperviewConstraint,
        checkboxRightSuperviewConstraint,
    ]

    private lazy var rightAlignmentConstraints: [NSLayoutConstraint] = [
        checkbox.rightAnchor.constraint(equalTo: label.leftAnchor, constant: 0 - Space.two),
        checkboxLeftSuperviewConstraint,
        labelRightSuperviewConstraint,
    ]

    /// Creates and returns a new checkbox with label.
    ///
    /// - Parameters:
    ///   - text: Initial text value of the label
    ///   - adjustsFontForContentSizeCategory: Boolean indicating whether the label should support Dynamic Type.
    public required init(text: String? = nil, adjustsFontForContentSizeCategory: Bool = true) {
        self.adjustsFontForContentSizeCategory = adjustsFontForContentSizeCategory
        self.label = Label(textStyle: .text1, adjustsFontForContentSizeCategory: adjustsFontForContentSizeCategory)

        super.init(frame: .null)

        label.text = text
        label.textAlignment = .left

        addSubview(checkbox)
        addSubview(label)

        checkbox.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false

        // The original implementation of this class utilized SnapKit's remakeConstraints()
        // method for dealing with left/right alignment swapping.  However, this method has
        // proven be to both slow and buggy (https://github.com/SnapKit/SnapKit/issues/571),
        // so we've opted to fall back to the vanilla Auto Layout API.
        NSLayoutConstraint.activate(
            rightAlignmentConstraints +
                [
                    labelTopConstraint,
                    labelBottomConstraint,
                    checkboxTopConstraint,
                    checkboxBottomConstraint,
                ]
        )

        let constant: CGFloat = (0 - label.font.capHeight) / 2.0
        self.checkboxIconCenterYConstraint = checkbox.centerYAnchor.constraint(equalTo: label.firstBaselineAnchor, constant: constant)
        checkboxIconCenterYConstraint?.isActive = true

        checkbox.isUserInteractionEnabled = false

        setContentHuggingPriority(.required, for: .horizontal)
        setContentHuggingPriority(.required, for: .vertical)

        setNeedsUpdateConstraints()
    }

    public override func layoutSubviews() {
        if !isEnabled {
            label.textColor = InputState.disabled.markableControlTextColor
        } else if hasError {
            label.textColor = InputState.error.markableControlTextColor
        } else {
            label.textColor = InputState.default.markableControlTextColor
        }

        super.layoutSubviews()
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
        let constant: CGFloat = (0 - label.font.capHeight) / 2.0
        checkboxIconCenterYConstraint?.constant = constant

        super.updateConstraints()
    }

    public override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        super.endTracking(touch, with: event)

        if isTouchInside {
            switch checkbox.mark {
            case .empty, .intermediate:
                checkbox.mark = .checked
            case .checked:
                checkbox.mark = .empty
            }

            sendActions(for: .valueChanged)
        }
    }

    public override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if let result = super.hitTest(point, with: event) {
            if result.isDescendant(of: self) {
                return self
            }

            return result
        }

        return nil
    }
}

public class Checkbox: Control {
    private static let dashImage = UIImage(named: "Checkbox-Dash", in: Bundle.thumbprint, compatibleWith: nil)
    private static let checkImage = UIImage(named: "Checkbox-Check", in: Bundle.thumbprint, compatibleWith: nil)
    private static let borderImage = UIImage(named: "Checkbox-Border", in: Bundle.thumbprint, compatibleWith: nil)
    private static let fillImage = UIImage(named: "Checkbox-BackgroundFill", in: Bundle.thumbprint, compatibleWith: nil)

    public enum Mark: String {
        case empty
        case intermediate
        case checked
    }

    private let backgroundImageView: UIImageView = .init(image: Checkbox.fillImage)
    private let borderImageView: UIImageView = .init(image: Checkbox.borderImage)
    private let markImageView: UIImageView = .init()

    /// True if the checkbox is in an error state. If true, checkbox and optional label display in red.
    public var hasError: Bool = false {
        didSet {
            if hasError != oldValue {
                setNeedsLayout()
            }
        }
    }

    /// If false, prevents user from interacting with the view and displays checkbox and optional label in gray.
    public override var isEnabled: Bool {
        didSet {
            if isEnabled != oldValue {
                setNeedsLayout()
            }
        }
    }

    /// If true, overrides default input state to display checkbox in blue.
    /// Note: Checkbox will not appear selected if isEnabled == false, or hasError = true
    public override var isHighlighted: Bool {
        didSet {
            if isHighlighted != oldValue {
                setNeedsLayout()
            }
        }
    }

    public override var isSelected: Bool {
        didSet {
            if isSelected, mark == .empty {
                mark = .checked
            } else if !isSelected, mark != .empty {
                mark = .empty
            }
        }
    }

    /// The mark displayed within the checkbox.  One of: empty, intermediate, or checked
    public var mark: Mark = .empty {
        didSet {
            if mark != oldValue {
                isSelected = mark == .checked || mark == .intermediate
                setNeedsLayout()
            }
        }
    }

    /// Sets the size of one checkbox edge (the checkbox is always square).  Defaults to 20.
    public var checkBoxSize: CGFloat = 20 {
        didSet {
            if Int(ceil(checkBoxSize)) != Int(ceil(oldValue)) {
                invalidateIntrinsicContentSize()
            }
        }
    }

    required override init(frame: CGRect = .null) {
        super.init(frame: frame)

        addSubview(backgroundImageView)
        addSubview(borderImageView)
        addSubview(markImageView)

        setContentCompressionResistancePriority(.required, for: .vertical)
        setContentCompressionResistancePriority(.required, for: .horizontal)
        setContentHuggingPriority(.required, for: .horizontal)
        setContentHuggingPriority(.required, for: .vertical)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func layoutSubviews() {
        switch mark {
        case .checked:
            markImageView.image = Self.checkImage
        case .intermediate:
            markImageView.image = Self.dashImage
        case .empty:
            markImageView.image = nil
        }

        switch (mark, hasError, isEnabled) {
        // Disabled state
        case (_, _, false):
            backgroundImageView.tintColor = Color.gray200
            borderImageView.tintColor = Color.gray300
            markImageView.tintColor = Color.gray

        // Empty checkbox, no error
        case (.empty, false, _):
            backgroundImageView.tintColor = Color.white
            borderImageView.tintColor = isHighlighted ? Color.blue : Color.gray
            markImageView.tintColor = Color.white

        // Empty checkbox, error
        case (.empty, true, _):
            backgroundImageView.tintColor = Color.white
            borderImageView.tintColor = Color.red
            markImageView.tintColor = Color.red

        // Non-Empty, no error
        case (_, false, _):
            backgroundImageView.tintColor = Color.blue
            borderImageView.tintColor = Color.blue
            markImageView.tintColor = Color.white

        // Non-empty, error
        case (_, true, _):
            backgroundImageView.tintColor = Color.red
            borderImageView.tintColor = Color.red
            markImageView.tintColor = Color.white
        }

        super.layoutSubviews()

        let rect = CGRect(x: 0, y: 0, width: checkBoxSize, height: checkBoxSize).integral
        backgroundImageView.frame = rect
        borderImageView.frame = rect
        markImageView.frame = rect
    }

    public override var intrinsicContentSize: CGSize {
        CGSize(width: checkBoxSize, height: checkBoxSize)
    }

    public override func sizeThatFits(_ size: CGSize) -> CGSize {
        intrinsicContentSize
    }

    public override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        switch mark {
        case .empty, .intermediate:
            mark = .checked
        case .checked:
            mark = .empty
        }

        super.endTracking(touch, with: event)
        sendActions(for: .valueChanged)
    }
}
