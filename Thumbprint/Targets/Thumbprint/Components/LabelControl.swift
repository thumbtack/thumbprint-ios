import UIKit

/**
 Base class for controls built off a tappable control (aka "root control") and a wrappable label next to it. Currently used as a base class for
 checkbox and radio button labeled controls but could be expanded into other use cases.

 The facilities this class provides are the following:
 - Proxies the root control to the whole surface including the label.
 - Allows for enabled/error state to reflect on the label as well.
 - Allows for configuration of the label to appear on either the leading or trailing side of the control
 - Allows configuring the label to wrap text if desired.
 - Aligns the graphical control's vertical center to the top line of the label
 - Exposes the label's content hugging and content compression resistance priorities so they can be adjusted if needed within a larger layout. The
 rest of the internal layout of the control is hardcoded.
 */
public class LabelControl<T>: Control, SimpleControl, UIContentSizeCategoryAdjusting where T: SimpleControl {
    // MARK: - Types

    /// Controls the placement of the label respective to the root control.
    public enum LabelPlacement: String {
        case leading
        case trailing
    }

    // MARK: - Initializers

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
        label.translatesAutoresizingMaskIntoConstraints = false
        labelContainer.addSubview(label)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: labelContainer.leadingAnchor),
            label.topAnchor.constraint(greaterThanOrEqualTo: labelContainer.topAnchor),
            labelContainer.trailingAnchor.constraint(equalTo: label.trailingAnchor),
            labelContainer.bottomAnchor.constraint(greaterThanOrEqualTo: label.bottomAnchor),
        ])

        rootControl.isUserInteractionEnabled = false
        rootControl.translatesAutoresizingMaskIntoConstraints = false
        rootControlContainer.addSubview(rootControl)
        NSLayoutConstraint.activate([
            rootControl.leadingAnchor.constraint(equalTo: rootControlContainer.leadingAnchor),
            rootControl.topAnchor.constraint(greaterThanOrEqualTo: rootControlContainer.topAnchor),
            rootControlContainer.trailingAnchor.constraint(equalTo: rootControl.trailingAnchor),
            rootControlContainer.bottomAnchor.constraint(greaterThanOrEqualTo: rootControl.bottomAnchor),
        ])

        // Will add to contentsStack the right way.
        apply(labelPlacement: labelPlacement)

        // Initialize root control/label alignment.
        setNeedsUpdateConstraints()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
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
        }
    }

    /// Access of placement of the label relative to the graphical control. Defaults to displaying the label on the trailing side of the control.
    public var labelPlacement: LabelPlacement = .trailing {
        didSet {
            guard labelPlacement != oldValue else {
                return
            }

            apply(labelPlacement: labelPlacement)
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

    /// Accesses the Thumbprint textStyle of the label.
    public var textStyle: Font.TextStyle {
        get {
            label.textStyle
        }
        set {
            guard newValue != label.textStyle else {
                return
            }

            label.textStyle = newValue
            setNeedsUpdateConstraints()
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

    /**
     Access to label's content hugging priority so it can be adjusted if the overall layout requires it. Both the root control and `contentInsets`
     are laid out on `.required` priority. If your layout gets to the point where those break you deserve some exceptions in the logs.

     The default value for these is the same as for UILabel (`.defaultLow`)
     - Parameter priority: The new layout priority for the label's content hugging internal constraint for the given axis.
     - Parameter axis: The axis to apply the new priority to.
     */
    public func setLabelContentHuggingPriority(_ priority: UILayoutPriority, for axis: NSLayoutConstraint.Axis) {
        label.setContentHuggingPriority(priority, for: axis)
    }

    /**
     Access to label's content compression resistance priority so it can be adjusted if the overall layout requires it. Both the root control and
     `contentInsets` are laid out on `.required` priority. If your layout gets to the point where those break you deserve some exceptions in the logs.

     The default value for these is the same as for UILabel (`.defaultHigh`)
     - Parameter priority: The new layout priority for the label's content hugging internal constraint for the given axis.
     - Parameter axis: The axis to apply the new priority to.
     */
    public func setLabelContentCompressionResistancePriority(_ priority: UILayoutPriority, for axis: NSLayoutConstraint.Axis) {
        label.setContentCompressionResistancePriority(priority, for: axis)
    }

    // MARK: - Private Implementation

    private let contentsStack: UIStackView = {
        let stack = UIStackView()
        stack.spacing = Space.two
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private let rootControl = T()

    private let rootControlContainer = UIView()

    private let label: Label

    private let labelContainer = UIView()

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

    private func apply(labelPlacement: LabelPlacement) {
        labelContainer.removeFromSuperview()
        rootControlContainer.removeFromSuperview()
        switch labelPlacement {
        case .trailing:
            contentsStack.addArrangedSubview(rootControlContainer)
            contentsStack.addArrangedSubview(labelContainer)

        case .leading:
            contentsStack.addArrangedSubview(labelContainer)
            contentsStack.addArrangedSubview(rootControlContainer)
        }

        // Reactivate vertical alignment (it deactivates when we remove label/root control from stack view).
        rootControlAlignmentConstraint.isActive = true
    }

    private func updateLabelTextColor() {
        if !isEnabled {
            label.textColor = InputState.disabled.markableControlTextColor
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
    }

    // MARK: - SimpleControl Implementation

    public func performAction() {
        // Just redirect to rootControl
        rootControl.performAction()
    }

    // MARK: - UIContentSizeCategoryAdjusting Implementation

    public var adjustsFontForContentSizeCategory: Bool {
        didSet {
            guard adjustsFontForContentSizeCategory != oldValue else { return }

            label.adjustsFontForContentSizeCategory = adjustsFontForContentSizeCategory

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
        label.forFirstBaselineLayout
    }

    public override var forLastBaselineLayout: UIView {
        label.forLastBaselineLayout
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
    }

    public override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        super.endTracking(touch, with: event)

        // Redirect to root control.
        rootControl.performAction()
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
