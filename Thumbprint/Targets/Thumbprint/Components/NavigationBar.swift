import ThumbprintTokens
import UIKit

/// A set of utilities for configuring the appearance of navigation bars
/// to match Thumbprint guidelines.
public enum NavigationBar {
    /// A struct representing a Thumbprint navigation bar appearance.
    public struct Appearance {
        var isTranslucent: Bool
        var backgroundImage: UIImage?
        var barTintColor: UIColor?
        var showShadow: Bool
        var scrollEdgeShowShadow: Bool

        /// If set to nil, will default to the content style's foreground color.
        /// Set to .some(nil) to disable this default and actually set the
        /// navigation bar's tint color to nil.
        var tintColor: UIColor??

        /// If no foreground color is specified, will default to the content
        /// style's foreground color.
        var titleTextAttributes: [NSAttributedString.Key: Any]?

        /// If no foreground color is specified, will default to the content
        /// style's foreground color.
        var largeTitleTextAttributes: [NSAttributedString.Key: Any]?

        public init(isTranslucent: Bool,
                    backgroundImage: UIImage?,
                    barTintColor: UIColor?,
                    tintColor: UIColor??,
                    showShadow: Bool,
                    scrollEdgeShowShadow: Bool,
                    titleTextAttributes: [NSAttributedString.Key: Any]?,
                    largeTitleTextAttributes: [NSAttributedString.Key: Any]?) {
            self.isTranslucent = isTranslucent
            self.backgroundImage = backgroundImage
            self.barTintColor = barTintColor
            self.tintColor = tintColor
            self.showShadow = showShadow
            self.titleTextAttributes = titleTextAttributes
            self.largeTitleTextAttributes = largeTitleTextAttributes
            self.scrollEdgeShowShadow = scrollEdgeShowShadow
        }

        /// Default navigation bar appearance.
        public static let `default` = NavigationBar.Appearance(
            isTranslucent: false,
            backgroundImage: UIImage(),
            barTintColor: Color.white,
            tintColor: Color.black,
            showShadow: true,
            scrollEdgeShowShadow: true,
            titleTextAttributes: [
                .font: Self.titleFont,
                .foregroundColor: Color.black,
            ],
            largeTitleTextAttributes: [
                .font: Self.largeTitleFont,
                .foregroundColor: Color.black,
            ]
        )

        /// Navigation bar appearance that has a shadow, but the shadow does not appear
        /// when at the scroll edge of a scroll view, i.e. does not appear until scrolled up
        public static let scrollEdgeShadowless = NavigationBar.Appearance(
            isTranslucent: false,
            backgroundImage: UIImage(),
            barTintColor: Color.white,
            tintColor: Color.black,
            showShadow: true,
            scrollEdgeShowShadow: false,
            titleTextAttributes: [
                .font: Self.titleFont,
                .foregroundColor: Color.black,
            ],
            largeTitleTextAttributes: [
                .font: Self.largeTitleFont,
                .foregroundColor: Color.black,
            ]
        )

        /// Navigation bar appearance without a bottom shadow.
        public static let shadowless = NavigationBar.Appearance(
            isTranslucent: false,
            backgroundImage: UIImage(),
            barTintColor: Color.white,
            tintColor: Color.black,
            showShadow: false,
            scrollEdgeShowShadow: false,
            titleTextAttributes: [
                .font: Self.titleFont,
                .foregroundColor: Color.black,
            ],
            largeTitleTextAttributes: [
                .font: Self.largeTitleFont,
                .foregroundColor: Color.black,
            ]
        )

        /// Transparent navigation bar appearance.
        public static let transparent = NavigationBar.Appearance(
            isTranslucent: true,
            backgroundImage: UIImage(),
            barTintColor: .clear,
            tintColor: nil,
            showShadow: false,
            scrollEdgeShowShadow: false,
            titleTextAttributes: [
                .font: Self.titleFont,
            ],
            largeTitleTextAttributes: [
                .font: Self.largeTitleFont,
            ]
        )

        private static let titleFont = Font.TextStyle(
            weight: .bold,
            size: 16,
            uiFontTextStyle: .body
        ).uiFont
        private static let largeTitleFont = Font.TextStyle(
            weight: .bold,
            size: 34,
            uiFontTextStyle: .body
        ).uiFont
    }

    /// An enum defining the possible styles of content, which may be
    /// used to set some of the navigation bar's properties.
    ///
    /// Note that properties specified by the appearance take precendence
    /// over the content style. The content style is only used in cases
    /// where the appearance did not specify a value for a given property.
    public enum ContentStyle {
        /// Style for use on a light background.
        case `default`

        /// Style for use on a dark background.
        case light

        var foregroundColor: UIColor {
            switch self {
            case .default:
                return Color.black
            case .light:
                return Color.white
            }
        }
    }

    public static func configure(_ navigationBar: UINavigationBar,
                                 appearance: Appearance = .default,
                                 content: ContentStyle = .default) {
        var titleTextAttributes = appearance.titleTextAttributes ?? [:]
        titleTextAttributes[.foregroundColor] = titleTextAttributes[.foregroundColor] ?? content.foregroundColor

        var largeTitleTextAttributes = appearance.largeTitleTextAttributes ?? [:]
        largeTitleTextAttributes[.foregroundColor] = largeTitleTextAttributes[.foregroundColor] ?? content.foregroundColor

        navigationBar.tintColor = appearance.tintColor ?? content.foregroundColor
        // Still set in iOS 15 due to the behavior of moving content under "translucent" nav bars, even if overridden by the nav bar appearance
        navigationBar.isTranslucent = appearance.isTranslucent

        if #available(iOS 15, *) {
            let barAppearance = UINavigationBarAppearance()
            let scrollEdgeAppearance = UINavigationBarAppearance()
            if appearance.isTranslucent {
                scrollEdgeAppearance.configureWithTransparentBackground()
                barAppearance.configureWithTransparentBackground()
            } else {
                scrollEdgeAppearance.configureWithOpaqueBackground()
                barAppearance.configureWithOpaqueBackground()
            }

            barAppearance.titleTextAttributes = titleTextAttributes
            scrollEdgeAppearance.titleTextAttributes = titleTextAttributes

            barAppearance.largeTitleTextAttributes = largeTitleTextAttributes
            scrollEdgeAppearance.largeTitleTextAttributes = largeTitleTextAttributes

            barAppearance.backgroundImage = appearance.backgroundImage
            scrollEdgeAppearance.backgroundImage = appearance.backgroundImage

            if !appearance.showShadow {
                barAppearance.shadowImage = UIImage()
                barAppearance.shadowColor = .clear
            }

            if !appearance.scrollEdgeShowShadow {
                scrollEdgeAppearance.shadowImage = UIImage()
                scrollEdgeAppearance.shadowColor = .clear
            }

            barAppearance.backgroundColor = appearance.barTintColor
            scrollEdgeAppearance.backgroundColor = appearance.barTintColor

            navigationBar.standardAppearance = barAppearance
            navigationBar.compactAppearance = barAppearance
            navigationBar.scrollEdgeAppearance = scrollEdgeAppearance
            navigationBar.compactScrollEdgeAppearance = scrollEdgeAppearance
        } else {
            navigationBar.setBackgroundImage(appearance.backgroundImage, for: .default)
            navigationBar.barTintColor = appearance.barTintColor
            if !appearance.showShadow {
                navigationBar.shadowImage = UIImage()
            }

            navigationBar.titleTextAttributes = titleTextAttributes
            navigationBar.largeTitleTextAttributes = largeTitleTextAttributes
        }
    }
}
