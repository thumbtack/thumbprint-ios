import Combine
import UIKit

// MARK: - Radio Stack
/// A convenience class for displaying a group of text only radio views with consistent styling and spacing.
public final class RadioStack: UIView, UIContentSizeCategoryAdjusting {
    /// The radios belonging to this stack
    private let radioViews: [LabeledRadio]

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

    /// A radio group that manages the radios and vends the selected index.
    public let radioGroup: RadioGroup<Int>

    /// Initializes a new RadioStack with the given radio titles
    ///
    /// - Parameters:
    ///   - titles: An array of titles with which to create the radio buttons
    ///   - adjustsFontForContentSizeCategory: Boolean indicating whether the radios in this stack should support Dynamic Type.
    public init(titles: [String], adjustsFontForContentSizeCategory: Bool = true) {
        self.radioGroup = RadioGroup()
        self.radioViews = titles.map({ LabeledRadio(text: $0, adjustsFontForContentSizeCategory: adjustsFontForContentSizeCategory) })
        self.adjustsFontForContentSizeCategory = adjustsFontForContentSizeCategory

        self.stack = UIStackView(arrangedSubviews: radioViews)
        stack.axis = .vertical
        stack.alignment = .leading
        stack.spacing = Space.three

        super.init(frame: .null)

        radioViews.enumerated().forEach { index, radio in
            radioGroup.register(radio, forKey: index)
        }

        addManagedSubview(stack)
        stack.snapToSuperviewEdges(.all)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
