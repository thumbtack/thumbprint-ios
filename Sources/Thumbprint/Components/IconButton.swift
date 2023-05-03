import SnapKit
import UIKit

/// An icon-only button
public final class IconButton: Control {
    // MARK: - Public Interface
    /// Icon button theme
    public struct Theme: Equatable {
        let tintColor: UIColor
        let activeTintColor: UIColor
        let disabledTintColor: UIColor

        /// Default theme for use on a light background.
        public static let `default` = IconButton.Theme(
            tintColor: Color.black,
            activeTintColor: Color.black300,
            disabledTintColor: Color.gray
        )

        public static let dark = IconButton.Theme(
            tintColor: Color.white,
            activeTintColor: Color.gray,
            disabledTintColor: Color.gray300
        )

        public init(tintColor: UIColor,
                    activeTintColor: UIColor,
                    disabledTintColor: UIColor) {
            self.tintColor = tintColor
            self.activeTintColor = activeTintColor
            self.disabledTintColor = disabledTintColor
        }
    }

    /// An icon to be displayed.
    public private(set) var icon: UIImage

    /// Icon button theme
    public private(set) var theme: Theme

    public var contentEdgeInsets: UIEdgeInsets = .zero {
        didSet {
            updateIconImageViewConstraints()
            invalidateIntrinsicContentSize()
        }
    }

    public func setIcon(_ icon: UIImage, accessibilityLabel: String, theme: IconButton.Theme = .default) {
        assert(!accessibilityLabel.isEmpty, "Please provide a non-empty accessibility label when setting an icon image.")
        self.icon = icon
        iconImageView.image = icon
        self.accessibilityLabel = accessibilityLabel
        self.theme = theme

        if #available(iOS 13.0, *) {
            largeContentImage = icon
            largeContentTitle = accessibilityLabel
        }
        updateIconImageViewConstraints()
        invalidateIntrinsicContentSize()
        updateTintColor()
        setNeedsLayout()
    }

    public override var isSelected: Bool {
        didSet {
            updateTintColor()
            updateAccessibilityTraits()
        }
    }

    public override var isEnabled: Bool {
        didSet {
            updateTintColor()
            updateAccessibilityTraits()
        }
    }

    public override var isHighlighted: Bool {
        didSet {
            updateTintColor()
        }
    }

    public override var intrinsicContentSize: CGSize {
        let width = contentEdgeInsets.left + icon.size.width + contentEdgeInsets.right
        let height = contentEdgeInsets.top + icon.size.height + contentEdgeInsets.bottom
        return CGSize(width: width, height: height)
    }

    public init(icon: UIImage, accessibilityLabel: String, theme: IconButton.Theme = .default) {
        assert(!accessibilityLabel.isEmpty, "Please provide a non-empty accessibility label when initializing an icon button.")

        self.icon = icon
        self.theme = theme

        self.iconImageView = UIImageView(image: icon)

        super.init(frame: .null)

        setContentCompressionResistancePriority(.required, for: .vertical)
        setContentCompressionResistancePriority(.required, for: .horizontal)
        setContentHuggingPriority(.required, for: .horizontal)
        setContentHuggingPriority(.required, for: .vertical)

        isAccessibilityElement = true
        self.accessibilityLabel = accessibilityLabel

        if #available(iOS 13.0, *) {
            showsLargeContentViewer = true
            addInteraction(UILargeContentViewerInteraction())
            largeContentImage = icon
            largeContentTitle = accessibilityLabel
        }

        addSubview(iconImageView)

        updateIconImageViewConstraints()
        updateTintColor()
        updateAccessibilityTraits()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private
    private let iconImageView: UIImageView

    private func updateTintColor() {
        if !isEnabled {
            iconImageView.tintColor = theme.disabledTintColor
        } else if isHighlighted || isSelected {
            iconImageView.tintColor = theme.activeTintColor
        } else {
            iconImageView.tintColor = theme.tintColor
        }
    }

    private func updateAccessibilityTraits() {
        var traits: UIAccessibilityTraits = .button

        if isSelected {
            traits.insert(.selected)
        }

        if !isEnabled {
            traits.insert(.notEnabled)
        }

        accessibilityTraits = traits
    }

    private func updateIconImageViewConstraints() {
        iconImageView.snp.remakeConstraints { make in
            make.top.equalToSuperview().inset(contentEdgeInsets.top)
            make.bottom.equalToSuperview().inset(contentEdgeInsets.bottom)
            make.left.greaterThanOrEqualToSuperview().inset(contentEdgeInsets.left)
            make.right.lessThanOrEqualToSuperview().inset(contentEdgeInsets.right)
            make.height.equalTo(icon.size.height)
            make.width.equalTo(icon.size.width)
        }
    }
}
