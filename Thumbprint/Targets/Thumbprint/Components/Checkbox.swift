// import ThumbprintResources
import UIKit

/**
 A checkbox button. Can be tapped to turn off and on, and may display a mixed state as well. Should usually not be used on its own but as the graphical
 part of a LabeledCheckbox.
 */
public final class Checkbox: Control {
    public enum Mark: CaseIterable {
        case empty
        case intermediate
        case checked
    }

    private static let dashImage = UIImage(named: "Checkbox-Dash", in: Bundle.thumbprint, compatibleWith: nil)
    private static let checkImage = UIImage(named: "Checkbox-Check", in: Bundle.thumbprint, compatibleWith: nil)
    private static let borderImage = UIImage(named: "Checkbox-Border", in: Bundle.thumbprint, compatibleWith: nil)
    private static let fillImage = UIImage(named: "Checkbox-BackgroundFill", in: Bundle.thumbprint, compatibleWith: nil)

    private let backgroundImageView: UIImageView = .init(image: Checkbox.fillImage)
    private let borderImageView: UIImageView = .init(image: Checkbox.borderImage)
    private let markImageView: UIImageView = .init()

    /// If false, prevents user from interacting with the view and displays checkbox and optional label in gray.
    public override var isEnabled: Bool {
        didSet {
            if isEnabled != oldValue {
                setNeedsLayout()
            }
        }
    }

    /// If true, overrides default input state to display checkbox in blue.
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

    // MARK: - UIView Overrides

    public override func layoutSubviews() {
        switch mark {
        case .checked:
            markImageView.image = Self.checkImage
        case .intermediate:
            markImageView.image = Self.dashImage
        case .empty:
            markImageView.image = nil
        }

        switch (mark, isEnabled) {
        case (_, false):
            backgroundImageView.tintColor = Color.gray200
            borderImageView.tintColor = Color.gray300
            markImageView.tintColor = Color.gray

        case (.empty, _):
            backgroundImageView.tintColor = Color.white
            borderImageView.tintColor = Color.gray
            markImageView.tintColor = Color.white

        default:
            backgroundImageView.tintColor = Color.blue
            borderImageView.tintColor = Color.blue
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
        performAction()

        super.endTracking(touch, with: event)
    }
}

// MARK: - SimpleControl Implementation

extension Checkbox: SimpleControl {
    public func performAction() {
        // Any non-checked state becomes checked, while checked becomes empty.
        switch mark {
        case .empty, .intermediate:
            mark = .checked
        case .checked:
            mark = .empty
        }

        sendActions(for: .valueChanged)
    }

    public func set(target: Any?, action: Selector) {
        addTarget(target, action: action, for: .valueChanged)
    }
}
