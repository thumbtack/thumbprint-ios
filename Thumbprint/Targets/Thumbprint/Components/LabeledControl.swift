import UIKit

/**
 Generic class for controls built off a tappable control (aka "root control") and a wrappable label next to it. Currently used as a base class for
 checkbox and radio button labeled controls but could be used for other simple controls with a similar layout even without subclassing.

 The control is supposed to offer a simple action (therefore compliance with `SimpleControl` and be graphical in nature which is why
 we are not requiring compliance with `UIContentSizeCategoryAdjusting`.

 The facilities this class provides are the following:
 - Proxies the root control to the whole surface including the label.
 - Allows for enabled/error state to reflect on the label as well.
 - Allows for configuration of the label to appear on either the leading or trailing side of the control
 - Allows configuring the label to wrap text if desired.
 - Aligns the graphical control's vertical center to the top line of the label
 - Exposes the label's content hugging and content compression resistance priorities so they can be adjusted if needed within a larger layout. The
 rest of the internal layout of the control is hardcoded.
 */
open class LabeledControl<T>: Control, UIContentSizeCategoryAdjusting where T: SimpleControl {
    // MARK: - Types

    /// Typealias for the control being used so fancy Swift type stuff can be done elsewhere.
    public typealias Control = T

    /// Controls the placement of the label contents respective to the root control.
    public enum ContentPlacement: CaseIterable {
        case leading
        case trailing
    }

    // MARK: - Initializers

    /**
     Creates and returns a new labeled control with the given parameters.
     - Parameter control: Optionally it can be initialized with an already created control. Defaults to a control created with no parameters, but can
     be used for testing purposes or with control types that are not directly supported by Thumbprint and where access to the root control may be needed.
     - Parameter label: The main label of the labeled control, the one that `control` will align against.
     - Parameter content: A view that must contain `label` and any other contents to display next to the control and be tappable. It must be able
     to adjust to being thrown into a horizontal stack view. If nil (the default), `label` will be used as the whole content.
     - Parameter adjustsFontForContentSizeCategory: Boolean indicating whether the label should initially support Dynamic Type. Defaults
     to `true`
     */
    public init(
        control: T = T(),
        label: UILabel,
        content: (UIView & UIContentSizeCategoryAdjusting)? = nil,
        adjustsFontForContentSizeCategory: Bool = true
    ) {
        self.rootControl = control
        self.adjustsFontForContentSizeCategory = adjustsFontForContentSizeCategory
        self.content = content ?? label
        self.label = label

        super.init(frame: .null)

        //  Set up the contents stack.
        addSubview(contentsStack)
        NSLayoutConstraint.activate([leadingInsetConstraint, topInsetConstraint, trailingInsetConstraint, bottomInsetConstraint])

        self.content.translatesAutoresizingMaskIntoConstraints = false
        contentContainer.addSubview(self.content)
        NSLayoutConstraint.activate([
            self.content.topAnchor.constraint(greaterThanOrEqualTo: contentContainer.topAnchor),
            contentContainer.bottomAnchor.constraint(greaterThanOrEqualTo: self.content.bottomAnchor),
        ])
        self.content.snapToSuperview(edges: .horizontal)

        rootControl.isUserInteractionEnabled = false
        rootControl.translatesAutoresizingMaskIntoConstraints = false
        rootControlContainer.addSubview(rootControl)
        NSLayoutConstraint.activate([
            rootControl.topAnchor.constraint(greaterThanOrEqualTo: rootControlContainer.topAnchor),
            rootControlContainer.bottomAnchor.constraint(greaterThanOrEqualTo: rootControl.bottomAnchor),
        ])
        rootControl.snapToSuperview(edges: .horizontal)

        // We really don't want root control to be any other size than what it wants.
        rootControl.setContentHuggingPriority(.required - 1.0, for: .horizontal)
        rootControl.setContentHuggingPriority(.required - 1.0, for: .vertical)
        rootControl.setContentCompressionResistancePriority(.required - 1.0, for: .horizontal)
        rootControl.setContentCompressionResistancePriority(.required - 1.0, for: .vertical)

        // Will add to contentsStack the right way.
        apply(contentPlacement: contentPlacement)

        // Turn on the shrink ray.
        heightShrinkerConstraint.isActive = true

        // Initialize root control/label alignment.
        setNeedsUpdateConstraints()
    }

    /**
     Convenience initializer for labeled controls that just contain a standard label with provided static content.
     */
    public convenience init(text: String? = nil, adjustsFontForContentSizeCategory: Bool = true) {
        let label = Label(textStyle: .text1, adjustsFontForContentSizeCategory: adjustsFontForContentSizeCategory)
        label.text = text
        label.textAlignment = .natural
        self.init(label: label, adjustsFontForContentSizeCategory: adjustsFontForContentSizeCategory)
    }

    @available(*, unavailable)
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UI Configuration

    /// The text displayed on the label. Same rules as for UILabel apply.
    public var text: String? {
        get {
            label.text
        }
        set {
            guard label.text != newValue else {
                return
            }

            label.text = newValue
            updateLabelTextColor()
        }
    }

    /// Access to the attributed text content of the label. Same rules as for UILabel apply.
    public var attributedText: NSAttributedString? {
        get {
            label.attributedText
        }
        set {
            guard label.attributedText != newValue else {
                return
            }

            label.attributedText = newValue
            updateLabelTextColor()
            labelLayoutDidChange()
        }
    }

    /// Access of placement of the label relative to the graphical control. Defaults to displaying the label on the trailing side of the control.
    public var contentPlacement: ContentPlacement = .trailing {
        didSet {
            guard contentPlacement != oldValue else {
                return
            }

            apply(contentPlacement: contentPlacement)
        }
    }

    /// Sets the maximum number of lines of the label. As with `UILabel` setting 0 means the text will wrap indefinitely. Default value is 1.
    public var numberOfLines: Int {
        get {
            label.numberOfLines
        }
        set {
            label.numberOfLines = newValue
        }
    }

    /// Additional content insets around the root control and label. The additional area will be part of the tapping target.
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

    // MARK: - Private Implementation

    private let contentsStack: UIStackView = {
        let stack = UIStackView()
        stack.spacing = Space.two
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    /**
     Direct access to the main label, the one that `rootControl` aligns against.

     Remember to call `labelLayoutDidChange` if you make any changes on it that may affect its layout.
     */
    public let label: UILabel

    /**
     Since we give access to the labeled control's main label, there may be situations where the contents and formatting are changed such that the layout
     is no longer valid for aligning the label and `rootControl`. There is no good way for `LabeledControl` to detect all such instances so if
     configuration logic makes changes to a labeled control's label that may affect layout you should call this method.
     */
    public func labelLayoutDidChange() {
        setNeedsUpdateConstraints()
    }

    /// Explicitly declared internal as we need access to it in module subclasses (See `LabeledCheckbox` and `LabeledRadio`).
    internal let rootControl: T

    private let rootControlContainer = UIView()

    private let content: UIView & UIContentSizeCategoryAdjusting

    private let contentContainer = UIView()

    /**
     Needed due to the implicit ambiguity of not knowing whether rootControl or the content determine height and stack top/bottom.
     */
    private lazy var heightShrinkerConstraint: NSLayoutConstraint = {
        let constraint = contentsStack.heightAnchor.constraint(equalToConstant: 0.0)
        constraint.priority = .defaultLow
        return constraint
    }()

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

    private lazy var rootControlAlignmentConstraint: NSLayoutConstraint = {
        label.firstBaselineAnchor.constraint(equalTo: rootControl.centerYAnchor)
    }()

    private func apply(contentPlacement: ContentPlacement) {
        contentContainer.removeFromSuperview()
        rootControlContainer.removeFromSuperview()
        switch contentPlacement {
        case .trailing:
            contentsStack.addArrangedSubview(rootControlContainer)
            contentsStack.addArrangedSubview(contentContainer)

        case .leading:
            contentsStack.addArrangedSubview(contentContainer)
            contentsStack.addArrangedSubview(rootControlContainer)
        }

        // Reactivate vertical alignment (it deactivates when we remove content/root control from stack view).
        rootControlAlignmentConstraint.isActive = true
    }

    private func updateLabelTextColor() {
        // If the label contains styled text we leave it untouched, otherwise we use the defined thumbprint colors.
        var containsStyledTextColor = false
        if let attributedText = label.attributedText {
            // If label.attributedText sets a foregroundColor for any of its segments, then don't override with InputState.markableControlTextColor.
            let textColor = label.textColor
            attributedText.enumerateAttribute(
                .foregroundColor,
                in: NSRange(location: 0, length: attributedText.length),
                options: .longestEffectiveRangeNotRequired
            ) { foregroundColorValue, _, stop in
                if foregroundColorValue != nil, (foregroundColorValue as? UIColor) != textColor {
                    containsStyledTextColor = true
                    stop.pointee = true
                }
            }
        }

        switch (containsStyledTextColor, isEnabled) {
        case (true, _):
            // There's styled text color. leave untouched.
            break

        case (false, true):
            // Use enabled label text color.
            label.textColor = InputState.default.markableControlTextColor

        case (false, false):
            // Use disabled label text color.
            label.textColor = InputState.disabled.markableControlTextColor
        }
    }

    private func updateHighlight(_ tracking: Bool, touch: UITouch, event: UIEvent?) {
        // Highlight root control.
        rootControl.isHighlighted = tracking && point(inside: touch.location(in: self), with: event)
    }

    // MARK: - UIContentSizeCategoryAdjusting Implementation

    public var adjustsFontForContentSizeCategory: Bool {
        didSet {
            guard adjustsFontForContentSizeCategory != oldValue else { return }

            content.adjustsFontForContentSizeCategory = adjustsFontForContentSizeCategory

            setNeedsUpdateConstraints()
        }
    }

    // MARK: - Control Overrides

    public override var isEnabled: Bool {
        didSet {
            rootControl.isEnabled = isEnabled
            updateLabelTextColor()
        }
    }

    public override var isHighlighted: Bool {
        didSet {
            rootControl.isHighlighted = isHighlighted
        }
    }

    public override var isSelected: Bool {
        didSet {
            rootControl.isSelected = isSelected
        }
    }

    public override var forFirstBaselineLayout: UIView {
        content.forFirstBaselineLayout
    }

    public override var forLastBaselineLayout: UIView {
        content.forLastBaselineLayout
    }

    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if traitCollection.preferredContentSizeCategory != previousTraitCollection?.preferredContentSizeCategory {
            setNeedsUpdateConstraints()
        }
    }

    public override func updateConstraints() {
        super.updateConstraints()

        let constant: CGFloat = label.font.capHeight * 0.5
        guard constant != rootControlAlignmentConstraint.constant else {
            return
        }

        rootControlAlignmentConstraint.constant = constant

        // We keep it high but low enough that it won't intefere with default content compression resistance
        // priority and can still be played with.
        heightShrinkerConstraint.priority = .defaultHigh - 50.0
    }

    public override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let result = super.beginTracking(touch, with: event)

        updateHighlight(result, touch: touch, event: event)

        return result
    }

    public override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let result = super.continueTracking(touch, with: event)

        updateHighlight(result, touch: touch, event: event)

        return result
    }

    public override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        super.endTracking(touch, with: event)

        rootControl.isHighlighted = false

        performAction()
    }

    /// Override takes over subviews to make the whole of self the touch area.
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

// MARK: - SimpleControl Implementation

extension LabeledControl: SimpleControl {
    public func performAction() {
        // We are the keepers of the target/action!
        sendActions(for: .touchUpInside)

        // rootControl won't actually do anything since it doesn't have target/action set but it'll know to update
        // its state.
        // This can hopefully become redundant once `Thumbprint.Action` manages the action state.
        rootControl.performAction()
    }

    public func set(target: Any?, action: Selector) {
        // We do the action sending ourselves as to be easily identified as the control performing it (important
        // when groups of controls need identification).
        addTarget(target, action: action, for: .touchUpInside)
    }
}
