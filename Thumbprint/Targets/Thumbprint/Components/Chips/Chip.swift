import UIKit

/**
 * Base Chip class for implementing ToggleChip and FilterChip
 *
 * See the Thumbprint documentation at https://thumbprint.design/components/chip/ios/
 */

public class Chip: Control {
    // MARK: - Public Properties
    public override var isHighlighted: Bool {
        didSet {
            guard isHighlighted != oldValue else {
                return
            }

            updateBorder()
        }
    }

    public override var isSelected: Bool {
        didSet {
            guard isSelected != oldValue else {
                return
            }

            updatePillTheme()
        }
    }

    public var text: String? {
        get {
            return pill.text
        }

        set {
            guard text != newValue else {
                return
            }

            //  The pill already cares to update itself.
            pill.text = newValue
            invalidateIntrinsicContentSize() //  Not transitive so the pill's invalidation won't affect us.
        }
    }

    public var isHapticFeedbackEnabled: Bool {
        didSet {
            guard isHapticFeedbackEnabled != oldValue else { return }
            setupFeedbackGenerator()
        }
    }

    func buildAccessibilityLabel() -> String {
        fatalError("Should override this")
    }

    static var unselectedTheme: Pill.Theme {
        return .init(backgroundColor: Color.white, contentColor: Color.blue)
    }

    class var selectedTheme: Pill.Theme {
        fatalError("Should override this")
    }

    // MARK: - Private Properties

    private let pill: ChipPill
    private var feedbackGenerator: UISelectionFeedbackGenerator?

    // MARK: - Public API
    public convenience init(adjustsFontForContentSizeCategory: Bool = true) {
        let pill = ChipPill(adjustsFontForContentSizeCategory: adjustsFontForContentSizeCategory)
        self.init(pill: pill)
    }

    public init(pill: ChipPill) {
        self.pill = pill
        self.isHapticFeedbackEnabled = true

        super.init(frame: .null)

        self.isAccessibilityElement = true
        self.accessibilityTraits = .button

        setupView()
        setupFeedbackGenerator()

        //  Default to high hugging/compression resistance since this is meant to strongly size with its contents.
        setContentHuggingPriority(.defaultHigh, for: .vertical)
        setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        setContentHuggingPriority(.defaultHigh, for: .horizontal)
        setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
    }

    @available(*, unavailable)
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func sizeThatFits(_ size: CGSize) -> CGSize {
        //  Redirect to the pill.
        return pill.sizeThatFits(size)
    }

    public override var intrinsicContentSize: CGSize {
        //  Redirect to the pill.
        return pill.intrinsicContentSize
    }

    public override func layoutSubviews() {
        super.layoutSubviews()

        updatePillTheme()
        accessibilityLabel = buildAccessibilityLabel()
    }

    // MARK: - Private Methods
    private func updateBorder() {
        pill.borderColor = isHighlighted ? Color.blue : Color.gray
        pill.drawsBorder = isHighlighted || !isSelected
    }

    private func updatePillTheme() {
        pill.theme = isSelected ? Self.selectedTheme : Self.unselectedTheme
        updateBorder()
    }

    private func setupView() {
        let pill = self.pill
        pill.translatesAutoresizingMaskIntoConstraints = false
        addSubview(pill)

        NSLayoutConstraint.activate([
            pill.leadingAnchor.constraint(equalTo: leadingAnchor),
            pill.topAnchor.constraint(equalTo: topAnchor),
            trailingAnchor.constraint(equalTo: pill.trailingAnchor),
            bottomAnchor.constraint(equalTo: pill.bottomAnchor),
        ])

        //  Set pill's sizing priorities to negligible values to avoid autolayout engine confusion.
        pill.setContentHuggingPriority(.fittingSizeLevel - 1.0, for: .horizontal)
        pill.setContentCompressionResistancePriority(.fittingSizeLevel - 1.0, for: .horizontal)
        pill.setContentHuggingPriority(.fittingSizeLevel - 1.0, for: .vertical)
        pill.setContentCompressionResistancePriority(.fittingSizeLevel - 1.0, for: .vertical)

        setNeedsLayout()
    }

    private func setupFeedbackGenerator() {
        if isHapticFeedbackEnabled {
            feedbackGenerator = UISelectionFeedbackGenerator()
            addTarget(self, action: #selector(prepareFeedbackGenerator), for: .touchDown)
            addTarget(self, action: #selector(invokeFeedbackGeneratorSelectionChanged), for: .touchUpInside)
        } else {
            removeTarget(self, action: #selector(prepareFeedbackGenerator), for: .touchDown)
            removeTarget(self, action: #selector(invokeFeedbackGeneratorSelectionChanged), for: .touchUpInside)
            feedbackGenerator = nil
        }
    }

    @objc private func prepareFeedbackGenerator() {
        feedbackGenerator?.prepare()
    }

    @objc private func invokeFeedbackGeneratorSelectionChanged() {
        feedbackGenerator?.selectionChanged()
    }
}

extension Chip: UIContentSizeCategoryAdjusting {
    public var adjustsFontForContentSizeCategory: Bool {
        get {
            //  Redirect to pill.
            return pill.adjustsFontForContentSizeCategory
        }

        set {
            guard newValue != adjustsFontForContentSizeCategory else {
                return
            }

            //  Redirect to pill. Intrinsic content size needs to be invalidated at our level as well.
            pill.adjustsFontForContentSizeCategory = newValue
            invalidateIntrinsicContentSize()
        }
    }

    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        //  We need to mimic pill's behavior as invalidateIntrinsicContentSize is not transitive nor can be observed.
        super.traitCollectionDidChange(previousTraitCollection)

        if adjustsFontForContentSizeCategory, previousTraitCollection?.preferredContentSizeCategory != traitCollection.preferredContentSizeCategory {
            invalidateIntrinsicContentSize()
            setNeedsLayout()
        }
    }
}

/**
 Basically a pill with facilities to add a border.
 */
open class ChipPill: Pill {
    // MARK: - Class configuration
    private static let defaultHeight: CGFloat = 32.0
    private static let defaultPadding: CGFloat = 16.0
    private static let baseBorderWidth: CGFloat = 1.0

    // MARK: - Border management.

    private var borderWidth: CGFloat {
        if !drawsBorder {
            return 0.0
        } else if adjustsFontForContentSizeCategory {
            return Font.scaledValue(ChipPill.baseBorderWidth, for: label.textStyle)
        } else {
            return ChipPill.baseBorderWidth
        }
    }

    var drawsBorder: Bool = true {
        didSet {
            guard drawsBorder != oldValue else {
                return
            }

            setNeedsLayout()
        }
    }

    var borderColor: UIColor = Color.gray {
        didSet {
            guard borderColor != oldValue else {
                return
            }

            setNeedsLayout()
        }
    }

    public override init(adjustsFontForContentSizeCategory: Bool = true) {
        super.init(adjustsFontForContentSizeCategory: adjustsFontForContentSizeCategory)
        config = Config(height: Self.defaultHeight, padding: Self.defaultPadding, textStyle: .title8)
    }

    open override func layoutSubviews() {
        super.layoutSubviews()

        //  Configure the border as set up.
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.cgColor
    }
}
