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
            return mode == .light ? originalColor : Color.gray
        case Color.gray:
            return mode == .light ? originalColor : Color.black300
        case Color.white:
            return mode == .light ? originalColor : Color.gray200
        case Color.blue:
            return mode == .light ? originalColor : UIColor(red: 0.87, green: 0.89, blue: 0.90, alpha: 1.0)
        default:
            return originalColor
        }
    }
}
