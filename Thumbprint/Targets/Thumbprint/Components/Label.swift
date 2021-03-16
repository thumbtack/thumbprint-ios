import UIKit

/**
 * Label using Thumbprint text styles
 */
open class Label: UILabel {
    public var textStyle: Font.TextStyle {
        didSet {
            guard textStyle != oldValue else { return }
            updateFont()
            updateAccessibilityTraits()
            invalidateIntrinsicContentSize()
        }
    }

    open override var adjustsFontForContentSizeCategory: Bool {
        didSet {
            guard adjustsFontForContentSizeCategory != oldValue else { return }
            updateFont()
        }
    }

    /// Creates and returns a new label with the specified text style.
    ///
    /// - Parameters:
    ///   - textStyle: Thumbprint text style to use with this label. Note that
    ///                if you're planning to use attributed strings with this label,
    ///                the text style you pass in here might not matter.
    ///   - adjustsFontForContentSizeCategory: Boolean indicating whether this label
    ///                                        should support Dynamic Type. If set to true,
    ///                                        numberOfLines should typically also be set
    ///                                        to 0.
    public init(textStyle: Font.TextStyle, adjustsFontForContentSizeCategory: Bool = true) {
        self.textStyle = textStyle

        super.init(frame: .null)

        self.adjustsFontForContentSizeCategory = adjustsFontForContentSizeCategory

        textColor = Color.black

        updateFont()
        updateAccessibilityTraits()
    }

    @available(*, unavailable)
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override var debugDescription: String {
        var debugDescription: String = "<Label: \(Unmanaged.passUnretained(self).toOpaque())"
        debugDescription += "; frame: \(frame)"
        debugDescription += "; textStyle: \(textStyle)"
        debugDescription += "; adjustsFontForContentSizeCategory: \(adjustsFontForContentSizeCategory)"
        if let text = text {
            debugDescription += "; text: '\(text)'"
        } else {
            debugDescription += "; text: nil"
        }
        debugDescription += "; userInteractionEnabled: \(isUserInteractionEnabled)"
        return "\(debugDescription)>"
    }

    private func updateFont() {
        font = font(for: textStyle)
    }

    private func updateAccessibilityTraits() {
        var traits: UIAccessibilityTraits = .staticText

        if Self.headerTextStyles.contains(textStyle) {
            traits.insert(.header)
        }

        accessibilityTraits = traits
    }

    private static let headerTextStyles: Set<Font.TextStyle> = [
        .title1,
        .title2,
        .title3,
        .title4,
        .title5,
        .title6,
        .title7,
        .title8,
    ]
}
