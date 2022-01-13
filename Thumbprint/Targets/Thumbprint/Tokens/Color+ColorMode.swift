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
