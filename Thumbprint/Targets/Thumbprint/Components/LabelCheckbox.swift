import UIKit

public final class LabelCheckbox: Control, UIContentSizeCategoryAdjusting {
    public enum LabelPlacement: String {
        case leading
        case trailing
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
    public var labelPlacement: LabelPlacement = .trailing {
        didSet {
            guard labelPlacement != oldValue else {
                return
            }

            apply(labelPlacement: labelPlacement)
        }
    }

    private func apply(labelPlacement: LabelPlacement) {
        label.removeFromSuperview()
        checkbox.removeFromSuperview()
        switch labelPlacement {
        case .trailing:
            contentsStack.addArrangedSubview(checkbox)
            contentsStack.addArrangedSubview(label)

        case .leading:
            contentsStack.addArrangedSubview(label)
            contentsStack.addArrangedSubview(checkbox)
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
        }
    }

    public var contentInsets: NSDirectionalEdgeInsets = .zero {
        didSet {
            guard contentInsets != oldValue else {
                return
            }

            leadingInsetConstraint.constant = -contentInsets.leading
            topInsetConstraint.constant = -contentInsets.top
            trailingInsetConstraint.constant = -contentInsets.trailing
            bottomInsetConstraint.constant = -contentInsets.bottom
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
    private let contentsStack: UIStackView = {
        let stack = UIStackView()
        stack.spacing = Space.two
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    private let checkbox = Checkbox()
    private let label: Label

    private lazy var leadingInsetConstraint: NSLayoutConstraint = {
        leadingAnchor.constraint(equalTo: contentsStack.leadingAnchor)
    }()
    private lazy var topInsetConstraint: NSLayoutConstraint = {
        topAnchor.constraint(equalTo: contentsStack.topAnchor)
    }()
    private lazy var trailingInsetConstraint: NSLayoutConstraint = {
        contentsStack.trailingAnchor.constraint(equalTo: trailingAnchor)
    }()
    private lazy var bottomInsetConstraint: NSLayoutConstraint = {
        contentsStack.bottomAnchor.constraint(equalTo: bottomAnchor)
    }()

    /// Creates and returns a new checkbox with label.
    ///
    /// - Parameters:
    ///   - text: Initial text value of the label
    ///   - adjustsFontForContentSizeCategory: Boolean indicating whether the label should support Dynamic Type.
    public required init(text: String? = nil, adjustsFontForContentSizeCategory: Bool = true) {
        self.adjustsFontForContentSizeCategory = adjustsFontForContentSizeCategory
        self.label = Label(textStyle: .text1, adjustsFontForContentSizeCategory: adjustsFontForContentSizeCategory)

        super.init(frame: .null)

        //  Set up the contents stack.
        addSubview(contentsStack)
        NSLayoutConstraint.activate([leadingInsetConstraint, topInsetConstraint, trailingInsetConstraint, bottomInsetConstraint])

        label.text = text
        label.textAlignment = .natural

        // Will add to contentsStack the right way.
        apply(labelPlacement: labelPlacement)

        checkbox.isUserInteractionEnabled = false

        setContentHuggingPriority(.required, for: .horizontal)
        setContentHuggingPriority(.required, for: .vertical)
    }

    public override func layoutSubviews() {
        if !isEnabled {
            label.textColor = InputState.disabled.markableControlTextColor
        } else if hasError {
            label.textColor = InputState.error.markableControlTextColor
        } else {
            var shouldSetLabelTextColor: Bool = true
            if let attributedText = label.attributedText {
                // If label.attributedText sets a foregroundColor for any of its segments, then don't override with InputState.markableControlTextColor.
                attributedText.enumerateAttribute(
                    .foregroundColor,
                    in: NSRange(location: 0, length: attributedText.length),
                    options: .longestEffectiveRangeNotRequired
                ) { foregroundColorValue, _, stop in
                    if foregroundColorValue != nil {
                        shouldSetLabelTextColor = false
                        stop.pointee = true
                    }
                }
            }
            if shouldSetLabelTextColor {
                label.textColor = InputState.default.markableControlTextColor
            }
        }

        super.layoutSubviews()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
