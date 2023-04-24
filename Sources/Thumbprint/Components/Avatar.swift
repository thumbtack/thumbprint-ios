import Foundation
import UIKit

/**
 * Shared internal Avatar view
 */

public final class Avatar: UIView {
    public struct Size: Equatable {
        public let dimension: CGFloat
        public let textFont: UIFont
        public let badgeSize: CGFloat
        /// Top and trailing offsets for the badge (dx: trailing offset, dy: top offset)
        public let badgeOffsets: CGVector

        public static let xSmall = Size(
            dimension: 32.0,
            textFont: Font.TextStyle(
                weight: .bold,
                size: 10,
                uiFontTextStyle: .body
            ).uiFont,
            badgeSize: 12,
            badgeOffsets: CGVector(dx: 2.0, dy: 0.0)
        )
        public static let small = Size(
            dimension: 48.0,
            textFont: Font.TextStyle(
                weight: .bold,
                size: 16,
                uiFontTextStyle: .body
            ).uiFont,
            badgeSize: 12,
            badgeOffsets: CGVector(dx: 2.0, dy: 1.0)
        )
        public static let medium = Size(
            dimension: 72.0,
            textFont: Font.TextStyle(
                weight: .bold,
                size: 20,
                uiFontTextStyle: .body
            ).uiFont,
            badgeSize: 14,
            badgeOffsets: CGVector(dx: -2.0, dy: 2.0)
        )
        public static let large = Size(
            dimension: 100.0,
            textFont: Font.TextStyle(
                weight: .bold,
                size: 24,
                uiFontTextStyle: .body
            ).uiFont,
            badgeSize: 18,
            badgeOffsets: CGVector(dx: -5.0, dy: 4.0)
        )
        public static let xLarge = Size(
            dimension: 140.0,
            textFont: Font.TextStyle(
                weight: .bold,
                size: 32,
                uiFontTextStyle: .body
            ).uiFont,
            badgeSize: 24,
            badgeOffsets: CGVector(dx: -14.0, dy: 0.0)
        )

        public init(dimension: CGFloat,
                    textFont: UIFont,
                    badgeSize: CGFloat,
                    badgeOffsets: CGVector) {
            self.dimension = dimension
            self.textFont = textFont
            self.badgeSize = badgeSize
            self.badgeOffsets = badgeOffsets
        }
    }

    // Internal

    internal struct EmptyTheme {
        let textColor: UIColor
        let backgroundColor: UIColor
    }

    internal static let styles = [
        EmptyTheme(textColor: Color.indigo600, backgroundColor: Color.indigo100),
        EmptyTheme(textColor: Color.green600, backgroundColor: Color.green100),
        EmptyTheme(textColor: Color.yellow600, backgroundColor: Color.yellow100),
        EmptyTheme(textColor: Color.red600, backgroundColor: Color.red100),
        EmptyTheme(textColor: Color.purple600, backgroundColor: Color.purple100),
        EmptyTheme(textColor: Color.blue600, backgroundColor: Color.blue100),
    ]

    internal static func backgroundColor(initials: String?) -> EmptyTheme {
        guard let initialCharacter = initials?.first,
              let charValue = initialCharacter.asciiValue else {
            return EmptyTheme(textColor: Color.black, backgroundColor: Color.gray200)
        }
        return Avatar.styles[Int(charValue) % styles.count]
    }

    internal var size: Avatar.Size {
        didSet {
            updateSize()
        }
    }

    internal var emptyTheme: Avatar.EmptyTheme {
        didSet {
            updateStyle()
        }
    }

    internal var image: UIImage? {
        get {
            imageView.image
        }
        set {
            imageView.image = newValue
            updateStyle()
        }
    }

    internal init(size: Size) {
        self.size = size
        self.emptyTheme = Avatar.backgroundColor(initials: "")

        super.init(frame: .zero)

        setupViews()
        updateStyle()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // Avatar - private
    internal let label = UILabel()
    private let imageView = UIImageView()

    private func setupViews() {
        label.textAlignment = .center
        label.isAccessibilityElement = false
        addSubview(label)
        label.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }

        imageView.contentMode = .scaleAspectFill
        addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    private func updateSize() {
        label.font = size.textFont
    }

    private func updateStyle() {
        backgroundColor = imageView.image == nil ? emptyTheme.backgroundColor : nil

        label.isHidden = imageView.image != nil
        label.textColor = emptyTheme.textColor
        imageView.isHidden = imageView.image == nil
    }
}

internal class OnlineBadgeView: UIView {
    let fillView = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupView()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        layer.cornerRadius = frame.size.width / 2
        fillView.layer.cornerRadius = fillView.frame.size.width / 2
    }

    // MARK: - Private
    private func setupView() {
        fillView.backgroundColor = Color.green
        backgroundColor = Color.white

        addSubview(fillView)
        fillView.snp.makeConstraints { make in
            let borderWidth = 2
            make.center.equalToSuperview()
            make.width.height.equalToSuperview().offset(-(borderWidth * 2))
        }
    }
}
