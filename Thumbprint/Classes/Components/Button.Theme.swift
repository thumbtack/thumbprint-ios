import UIKit

public extension Button {
    /**
     * Button theme
     */
    struct Theme: Equatable {
        public let titleColor: UIColor
        public let activeTitleColor: UIColor
        public let disabledTitleColor: UIColor

        public let backgroundColor: UIColor?
        public let activeBackgroundColor: UIColor?
        public let disabledBackgroundColor: UIColor?

        public let borderColor: UIColor?
        public let activeBorderColor: UIColor?
        public let disabledBorderColor: UIColor?

        public let loaderTheme: LoaderDots.Theme?
        public let supportsHapticFeedback: Bool

        public init(titleColor: UIColor,
                    activeTitleColor: UIColor,
                    disabledTitleColor: UIColor,
                    backgroundColor: UIColor?,
                    activeBackgroundColor: UIColor?,
                    disabledBackgroundColor: UIColor?,
                    borderColor: UIColor?,
                    activeBorderColor: UIColor?,
                    disabledBorderColor: UIColor?,
                    loaderTheme: LoaderDots.Theme?,
                    supportsHapticFeedback: Bool) {
            self.titleColor = titleColor
            self.activeTitleColor = activeTitleColor
            self.disabledTitleColor = disabledTitleColor
            self.backgroundColor = backgroundColor
            self.activeBackgroundColor = activeBackgroundColor
            self.disabledBackgroundColor = disabledBackgroundColor
            self.borderColor = borderColor
            self.activeBorderColor = activeBorderColor
            self.disabledBorderColor = disabledBorderColor
            self.loaderTheme = loaderTheme
            self.supportsHapticFeedback = supportsHapticFeedback
        }

        /// Primary button theme.
        public static let primary = Button.Theme(
            titleColor: Color.white,
            activeTitleColor: Color.white,
            disabledTitleColor: Color.white,
            backgroundColor: Color.blue,
            activeBackgroundColor: Color.blue500,
            disabledBackgroundColor: Color.blue300,
            borderColor: nil,
            activeBorderColor: nil,
            disabledBorderColor: nil,
            loaderTheme: .inverse,
            supportsHapticFeedback: true
        )

        /// Secondary button theme.
        public static let secondary = Button.Theme(
            titleColor: Color.blue,
            activeTitleColor: Color.blue,
            disabledTitleColor: Color.blue300,
            backgroundColor: Color.white,
            activeBackgroundColor: Color.white,
            disabledBackgroundColor: Color.white,
            borderColor: Color.gray,
            activeBorderColor: Color.blue,
            disabledBorderColor: Color.gray300,
            loaderTheme: .brand,
            supportsHapticFeedback: true
        )

        /// Tertiary button theme.
        public static let tertiary = Button.Theme(
            titleColor: Color.black300,
            activeTitleColor: Color.black300,
            disabledTitleColor: Color.gray,
            backgroundColor: Color.white,
            activeBackgroundColor: Color.white,
            disabledBackgroundColor: Color.white,
            borderColor: Color.gray,
            activeBorderColor: Color.black300,
            disabledBorderColor: Color.gray300,
            loaderTheme: .muted,
            supportsHapticFeedback: false
        )

        /// Cautionary button theme.
        public static let caution = Button.Theme(
            titleColor: Color.red,
            activeTitleColor: Color.red,
            disabledTitleColor: Color.red300,
            backgroundColor: Color.white,
            activeBackgroundColor: Color.white,
            disabledBackgroundColor: Color.white,
            borderColor: Color.gray,
            activeBorderColor: Color.red,
            disabledBorderColor: Color.gray300,
            loaderTheme: .muted,
            supportsHapticFeedback: false
        )

        /// Solid white button theme. Only use on top of photos or "base colors" such as blue or indigo.
        public static let solid = Button.Theme(
            titleColor: Color.black,
            activeTitleColor: Color.black,
            disabledTitleColor: Color.gray,
            backgroundColor: Color.white,
            activeBackgroundColor: Color.white,
            disabledBackgroundColor: Color.white,
            borderColor: nil,
            activeBorderColor: Color.black,
            disabledBorderColor: nil,
            loaderTheme: nil,
            supportsHapticFeedback: false
        )

        /// Text-only button theme.
        public static let text = Button.Theme(
            titleColor: Color.black,
            activeTitleColor: Color.black300,
            disabledTitleColor: Color.gray,
            backgroundColor: nil,
            activeBackgroundColor: nil,
            disabledBackgroundColor: nil,
            borderColor: nil,
            activeBorderColor: nil,
            disabledBorderColor: nil,
            loaderTheme: nil,
            supportsHapticFeedback: false
        )

        /// Text-only button theme that appears as a link.
        public static let link = Button.Theme(
            titleColor: Color.blue,
            activeTitleColor: Color.blue300,
            disabledTitleColor: Color.gray,
            backgroundColor: nil,
            activeBackgroundColor: nil,
            disabledBackgroundColor: nil,
            borderColor: nil,
            activeBorderColor: nil,
            disabledBorderColor: nil,
            loaderTheme: nil,
            supportsHapticFeedback: false
        )
    }

    /**
     * Button size/layout configuration
     */
    struct Size: Equatable {
        /// Text style for the button label.
        public let textStyle: Font.TextStyle

        /**
         Content padding. Contents are always centered, this specifies the desired horizontal and vertical padding
         around the content on each side.

         Horizontal padding will usually end up larger for full width buttons, and might end up smaller than desired
         in tight layouts especially if large fonts are involved.

         Vertical padding should always be respected on penalty of autolayout exceptions and general layout issues.
         */
        public let contentPadding: CGSize

        /// Space between the icon and the label when there is an icon present.
        public let iconTextSpacing: CGFloat

        /// Default size should almost always be used.
        public static let `default` = Button.Size(
            textStyle: .title6,
            contentPadding: CGSize(width: 24.0, height: 13.75)
        )

        /// Small button size.
        public static let small = Button.Size(
            textStyle: .title7,
            contentPadding: CGSize(width: 12.0, height: 7.0)
        )

        /// Size that should be used with the .text/.link button themes.
        public static let text = Size.makeForText(textStyle: .title6)

        // Note, there is intentionally no corresponding Size entry for the `.link` Theme, since
        // links will usually be sized manually, and to match the text that they're alongside.

        public init(textStyle: Font.TextStyle,
                    contentPadding: CGSize = .zero,
                    iconTextSpacing: CGFloat = Space.two) {
            self.textStyle = textStyle
            self.contentPadding = contentPadding
            self.iconTextSpacing = iconTextSpacing
        }

        public static func makeForText(textStyle: Font.TextStyle, contentPadding: CGSize = .zero) -> Self {
            self.init(textStyle: textStyle, contentPadding: contentPadding, iconTextSpacing: Space.one)
        }

        public static func height(for size: Size) -> CGFloat {
            size.textStyle.dynamicFont.lineHeight + size.contentPadding.height * 2.0
        }
    }
}
