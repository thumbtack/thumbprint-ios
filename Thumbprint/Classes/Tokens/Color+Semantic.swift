import UIKit

/**
 Semantic color definitions. Located provisionally here until ThumbprintTokens processes them on its own.
 */
public extension Color {
    private static func themedColor(light: UIColor, dark: UIColor) -> UIColor {
        if #available(iOS 13.0, *) {
            return UIColor { traitCollection -> UIColor in
                switch traitCollection.userInterfaceStyle {
                case .dark:
                    return dark

                default:
                    return light
                }
            }
        } else {
            return light
        }
    }

    static let primaryBackground: UIColor = {
        themedColor(light: Color.white, dark: .black)
    }()

    static let primaryText: UIColor = {
        themedColor(light: Color.black, dark: Color.white)
    }()

    static let secondaryText: UIColor = {
        themedColor(light: Color.black300, dark: Color.gray)
    }()

    static let secondaryControlBorder: UIColor = {
        themedColor(light: Color.gray, dark: Color.black300)
    }()

    static let primaryControlText: UIColor = {
        themedColor(light: Color.white, dark: Color.gray200)
    }()

    static let secondaryControlText: UIColor = {
        themedColor(light: Color.blue, dark: UIColor(red: 0.87, green: 0.89, blue: 0.90, alpha: 1.0))
    }()

    static let defaultNavigationBarTint: UIColor = {
        themedColor(light: Color.white, dark: Color.black)
    }()

    static let defaultNavigationControlTint: UIColor = {
        themedColor(light: Color.black, dark: Color.white)
    }()

    static let signupButtonContent: UIColor = {
        themedColor(light: .black, dark: .white)
    }()
}
