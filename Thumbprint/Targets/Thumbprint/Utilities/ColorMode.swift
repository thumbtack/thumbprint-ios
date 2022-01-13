import ThumbprintTokens

public enum ColorMode {
    case light
    case dark
}

public extension Color {
    static func applyColorMode(toColor originalColor: UIColor, mode: ColorMode) -> UIColor {
        switch originalColor {
        case Color.white:
            return mode == .light ? originalColor : Color.black
        case Color.black:
            return mode == .light ? originalColor : Color.white
        case Color.black300:
            return mode == .light ? originalColor : Color.gray200
        default:
            return originalColor
        }
    }
}

public extension Button {
    static func applyColorMode(toTheme originalTheme: Button.Theme, mode: ColorMode) -> Button.Theme {
        if originalTheme == .primary {
            return mode == .light ? originalTheme : .primaryDark
        } else if originalTheme == .secondary {
            return mode == .light ? originalTheme : .secondaryDark
        } else if originalTheme == .tertiary {
            return mode == .light ? originalTheme : .tertiaryDark
        } else if originalTheme == .caution {
            return mode == .light ? originalTheme : .cautionDark
        } else if originalTheme == .solid {
            return mode == .light ? originalTheme : .solidDark
        } else if originalTheme == .text {
            return mode == .light ? originalTheme : .textDark
        } else if originalTheme == .linkDark {
            return mode == .light ? originalTheme : .linkDark
        } else {
            return originalTheme
        }
    }
}
