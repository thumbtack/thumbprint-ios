import ThumbprintTokens
import UIKit

/**
 * Defined fonts for use in UI
 *
 * See:
 *
 * [Thumbprint Documentation](https://thumbprint.design/guide/product/foundations/typography/ )
 *
 * [Thumbprint Native Figma](https://www.figma.com/file/Z7xbBfwFUb2DGMd2Nptt0KoD/Thumbprint-Native?node-id=212%3A0 )
 */
public enum Font {
    // MARK: - Static fonts

    /// Static font with title 1 style.
    public static let title1: UIFont = TextStyle.title1.uiFont

    /// Static font with title 2 style.
    public static let title2: UIFont = TextStyle.title2.uiFont

    /// Static font with title 3 style.
    public static let title3: UIFont = TextStyle.title3.uiFont

    /// Static font with title 4 style.
    public static let title4: UIFont = TextStyle.title4.uiFont

    /// Static font with title 5 style.
    public static let title5: UIFont = TextStyle.title5.uiFont

    /// Static font with title 6 style.
    public static let title6: UIFont = TextStyle.title6.uiFont

    /// Static font with title 7 style.
    public static let title7: UIFont = TextStyle.title7.uiFont

    /// Static font with title 8 style.
    public static let title8: UIFont = TextStyle.title8.uiFont

    /// Static font with text 1 style.
    public static let text1: UIFont = TextStyle.text1.uiFont

    /// Static font with text 2 style.
    public static let text2: UIFont = TextStyle.text2.uiFont

    /// Static font with text 3 style.
    public static let text3: UIFont = TextStyle.text3.uiFont

    // MARK: - Fonts that support scaling for accessibility.

    /// Font with title 1 style that supports scaling for accessibility.
    public static var dynamicTitle1: UIFont { TextStyle.title1.dynamicFont }

    /// Font with title 2 style that supports scaling for accessibility.
    public static var dynamicTitle2: UIFont { TextStyle.title2.dynamicFont }

    /// Font with title 3 style that supports scaling for accessibility.
    public static var dynamicTitle3: UIFont { TextStyle.title3.dynamicFont }

    /// Font with title 4 style that supports scaling for accessibility.
    public static var dynamicTitle4: UIFont { TextStyle.title4.dynamicFont }

    /// Font with title 5 style that supports scaling for accessibility.
    public static var dynamicTitle5: UIFont { TextStyle.title5.dynamicFont }

    /// Font with title 6 style that supports scaling for accessibility.
    public static var dynamicTitle6: UIFont { TextStyle.title6.dynamicFont }

    /// Font with title 7 style that supports scaling for accessibility.
    public static var dynamicTitle7: UIFont { TextStyle.title7.dynamicFont }

    /// Font with title 8 style that supports scaling for accessibility.
    public static var dynamicTitle8: UIFont { TextStyle.title8.dynamicFont }

    /// Font with text 1 style that supports scaling for accessibility.
    public static var dynamicText1: UIFont { TextStyle.text1.dynamicFont }

    /// Font with text 2 style that supports scaling for accesssibility.
    public static var dynamicText2: UIFont { TextStyle.text2.dynamicFont }

    /// Font with text 3 style that supports scaling for accessibility.
    public static var dynamicText3: UIFont { TextStyle.text3.dynamicFont }

    // MARK: - Testing

    /// Used by snapshot tests to forcefully apply the given trait collection. Do not use in application code.
    public static var traitCollectionOverrideForTesting: UITraitCollection?
}

// MARK: - Public Functions
public extension Font {
    /// Prepare fonts for use.
    ///
    /// - Parameter bundle: Bundle in which font assets are located
    static func register(bundle: Bundle) {
        registerFont(bundle: bundle, fileName: "MarkForThumbtack.otf")
        registerFont(bundle: bundle, fileName: "MarkForThumbtack-Bold.otf")
        registerFont(bundle: bundle, fileName: "MarkForThumbtack-Heavy.otf")
    }

    static func scaledValue(_ value: CGFloat, for style: TextStyle, compatibleWith traitCollection: UITraitCollection? = nil) -> CGFloat {
        return UIFontMetrics(forTextStyle: style.uiFontTextStyle).scaledValue(for: value, compatibleWith: resolvedTraits(for: traitCollection))
    }
}

// MARK: - Public Member Types
public extension Font {
    struct TextStyle: Equatable, Hashable {
        /// Static font for this text style.
        public let uiFont: UIFont
        public let weight: ThumbprintTokens.FontWeight
        public let size: CGFloat
        /// This text style determines how the font will scale for different
        /// content size categories. For instance, with the .extraLarge content
        /// size category a font with UIFont.TextStyle.headline might scale by
        /// 20% whereas a font with UIFont.TextStyle.body might scale by 30%
        /// (not real values, just for illustrative purposes). Therefore the
        /// UIFont.TextStyle should roughly mimic the semantic meaning of
        /// Thumbprint text styles, but it is not critical that they have a
        /// perfect 1:1 mapping.
        public let uiFontTextStyle: UIFont.TextStyle

        public init(weight: ThumbprintTokens.FontWeight,
                    size: CGFloat,
                    uiFontTextStyle: UIFont.TextStyle,
                    font: UIFont? = nil) {
            self.weight = weight
            self.size = size
            self.uiFontTextStyle = uiFontTextStyle

            if let font = font {
                self.uiFont = font
            } else if UIFont.familyNames.contains("MarkForThumbtack") {
                let fontName: String
                switch (weight, UIAccessibility.isBoldTextEnabled) {
                case (.normal, false):
                    fontName = "MarkForThumbtack-Regular"
                case (.normal, true), (.bold, false):
                    fontName = "MarkForThumbtack-Bold"
                case (.bold, true):
                    fontName = "MarkForThumbtack-Heavy"
                }

                self.uiFont = UIFont(name: fontName, size: size)!
            } else {
                // Fall back on system font if Mark is unavailable.
                let uiFontWeight: UIFont.Weight
                switch (weight, UIAccessibility.isBoldTextEnabled) {
                case (.normal, false):
                    uiFontWeight = .regular
                case (.normal, true), (.bold, false):
                    uiFontWeight = .bold
                case (.bold, true):
                    uiFontWeight = .heavy
                }

                self.uiFont = UIFont.systemFont(ofSize: size, weight: uiFontWeight)
            }
        }

        /// Font with this text style that supports scaling for accessibility.
        public var dynamicFont: UIFont {
            Font.scaledFont(for: self)
        }

        /// Font with this text style that supports scaling for accessibility
        /// and is configured with a specific trait collection.
        ///
        /// When using attributed strings, UIContentSizeCategoryAdusting.adjustsFontForContentSizeCategory
        /// does not work, and therefore fonts must be configured with a specific trait collection
        /// and updated any time the preferred content size category on the relevant view changes.
        public func scaledFont(compatibleWith traitCollection: UITraitCollection) -> UIFont {
            Font.scaledFont(for: self, compatibleWith: traitCollection)
        }

        // MARK: Standard text styles
        public static var title1: TextStyle {
            TextStyle(
                weight: ThumbprintTokens.Font.title1Weight,
                size: ThumbprintTokens.Font.title1Size,
                uiFontTextStyle: ThumbprintTokens.Font.title1UIFontTextStyle
            )
        }

        public static var title2: TextStyle {
            TextStyle(
                weight: ThumbprintTokens.Font.title2Weight,
                size: ThumbprintTokens.Font.title2Size,
                uiFontTextStyle: ThumbprintTokens.Font.title2UIFontTextStyle
            )
        }

        public static var title3: TextStyle {
            TextStyle(
                weight: ThumbprintTokens.Font.title3Weight,
                size: ThumbprintTokens.Font.title3Size,
                uiFontTextStyle: ThumbprintTokens.Font.title3UIFontTextStyle
            )
        }

        public static var title4: TextStyle {
            TextStyle(
                weight: ThumbprintTokens.Font.title4Weight,
                size: ThumbprintTokens.Font.title4Size,
                uiFontTextStyle: ThumbprintTokens.Font.title4UIFontTextStyle
            )
        }

        public static var title5: TextStyle {
            TextStyle(
                weight: ThumbprintTokens.Font.title5Weight,
                size: ThumbprintTokens.Font.title5Size,
                uiFontTextStyle: ThumbprintTokens.Font.title5UIFontTextStyle
            )
        }

        public static var title6: TextStyle {
            TextStyle(
                weight: ThumbprintTokens.Font.title6Weight,
                size: ThumbprintTokens.Font.title6Size,
                uiFontTextStyle: ThumbprintTokens.Font.title6UIFontTextStyle
            )
        }

        public static var title7: TextStyle {
            TextStyle(
                weight: ThumbprintTokens.Font.title7Weight,
                size: ThumbprintTokens.Font.title7Size,
                uiFontTextStyle: ThumbprintTokens.Font.title7UIFontTextStyle
            )
        }

        public static var title8: TextStyle {
            TextStyle(
                weight: ThumbprintTokens.Font.title8Weight,
                size: ThumbprintTokens.Font.title8Size,
                uiFontTextStyle: ThumbprintTokens.Font.title8UIFontTextStyle
            )
        }

        public static var text1: TextStyle {
            TextStyle(
                weight: ThumbprintTokens.Font.text1Weight,
                size: ThumbprintTokens.Font.text1Size,
                uiFontTextStyle: ThumbprintTokens.Font.text1UIFontTextStyle
            )
        }

        public static var text2: TextStyle {
            TextStyle(
                weight: ThumbprintTokens.Font.text2Weight,
                size: ThumbprintTokens.Font.text2Size,
                uiFontTextStyle: ThumbprintTokens.Font.text2UIFontTextStyle
            )
        }

        public static var text3: TextStyle {
            TextStyle(
                weight: ThumbprintTokens.Font.text3Weight,
                size: ThumbprintTokens.Font.text3Size,
                uiFontTextStyle: ThumbprintTokens.Font.text3UIFontTextStyle
            )
        }
    }
}

// MARK: - UIContentSizeCategoryAdjusting Extension
public extension UIContentSizeCategoryAdjusting {
    func font(for textStyle: Font.TextStyle) -> UIFont {
        return adjustsFontForContentSizeCategory ? textStyle.dynamicFont : textStyle.uiFont
    }
}

// MARK: - Private
private extension Font {
    private static func resolvedTraits(for traitCollection: UITraitCollection?) -> UITraitCollection? {
        switch (traitCollection, traitCollectionOverrideForTesting) {
        case (.none, .none):
            return nil

        case let (.some(traits), .none):
            return traits

        case let (.none, .some(testing)):
            return testing

        case let (.some(traits), .some(testing)):
            return UITraitCollection(traitsFrom: [traits, testing])
        }
    }

    static func scaledFont(for style: TextStyle, compatibleWith traitCollection: UITraitCollection? = nil) -> UIFont {
        let fontMetrics = UIFontMetrics(forTextStyle: style.uiFontTextStyle)
        let scaledFont = fontMetrics.scaledFont(for: style.uiFont, compatibleWith: resolvedTraits(for: traitCollection))
        switch (traitCollection, traitCollectionOverrideForTesting) {
        case (.none, .some):
            return style.uiFont.withSize(scaledFont.pointSize)
        case (.none, .none), (.some, .none), (.some, .some):
            return scaledFont
        }
    }

    static func registerFont(bundle: Bundle, fileName: String) {
        guard let pathForResourceString = bundle.path(forResource: fileName, ofType: nil) else {
            print("Failed to register font: path for resource not found.")
            return
        }
        guard let fontData = NSData(contentsOfFile: pathForResourceString) else {
            print("Failed to register font: font data could not be loaded.")
            return
        }
        guard let dataProvider = CGDataProvider(data: fontData) else {
            print("Failed to register font: data provider could not be loaded.")
            return
        }

        // This fixes a deadlock issue with the CGFont initializer that follows
        // https://stackoverflow.com/questions/40242370/app-hangs-in-simulator
        _ = UIFont()

        guard let fontRef = CGFont(dataProvider) else {
            print("Failed to register font: font could not be loaded.")
            return
        }

        var errorRef: Unmanaged<CFError>?
        if !CTFontManagerRegisterGraphicsFont(fontRef, &errorRef) {
            print("Failed to register font: register graphics font failed.")
        }
    }
}
