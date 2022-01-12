import ThumbprintTokens

public enum ColorMode {
    case Light
    case Dark
}

public extension Color {
    private static func applyColorMode(toColor originalColor: UIColor, mode: ColorMode) -> UIColor {
        switch originalColor {
        case Color.white:
            return mode == .Light ? originalColor : Color.black
        case Color.black:
            return mode == .Light ? originalColor : Color.white
        case Color.black300:
            return mode == .Light ? originalColor : Color.gray
        case Color.gray:
            return mode == .Light ? originalColor : Color.black300
        case Color.white:
            return mode == .Light ? originalColor : Color.gray200
        case Color.blue:
            return mode == .Light ? originalColor : UIColor(red: 0.87, green: 0.89, blue: 0.90, alpha: 1.0)
        default:
            return originalColor
        }
    }
}
