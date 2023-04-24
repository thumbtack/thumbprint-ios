// import ThumbprintResources
import UIKit

/// Views that conform to InputStateChangeAware will receive InputState change notifications when their parent view's
/// input state changes.
public protocol InputStateConfigurable: AnyObject {
    func inputStateDidChange(to: InputState)
}

/// A common state manager for all text presenting controls
public enum InputState {
    case `default`
    case highlighted
    case disabled
    case error

    // swiftlint:disable force_unwrapping
    private static let defaultInputStateBackgroundImage = UIImage(named: "defaultInputStateBackground", in: Bundle.thumbprint, compatibleWith: nil)!
    private static let highlightedInputStateBackground = UIImage(named: "highlightedInputStateBackground", in: Bundle.thumbprint, compatibleWith: nil)!
    private static let errorInputStateBackground = UIImage(named: "errorInputStateBackground", in: Bundle.thumbprint, compatibleWith: nil)!
    private static let disabledInputStateBackground = UIImage(named: "disabledInputStateBackground", in: Bundle.thumbprint, compatibleWith: nil)!
    // swiftlint:enable force_unwrapping

    public var backgroundImage: UIImage {
        switch self {
        case .default:
            return InputState.defaultInputStateBackgroundImage
        case .highlighted:
            return InputState.highlightedInputStateBackground
        case .disabled:
            return InputState.disabledInputStateBackground
        case .error:
            return InputState.errorInputStateBackground
        }
    }

    public var borderColor: UIColor {
        switch self {
        case .default:
            return Color.gray
        case .highlighted:
            return Color.blue
        case .disabled:
            return Color.gray300
        case .error:
            return Color.red
        }
    }

    public var backgroundColor: UIColor {
        switch self {
        case .disabled:
            return Color.gray200
        default:
            return Color.white
        }
    }

    public var textColor: UIColor {
        switch self {
        case .disabled:
            return Color.gray
        case .error:
            return Color.red
        default:
            return Color.black
        }
    }

    public var placeholderTextColor: UIColor {
        switch self {
        case .error:
            return Color.red300
        case .disabled:
            return Color.gray
        default:
            return Color.black300
        }
    }
}

// Input state extensions for "markable" controls (e.g. radio and checkbox)
public extension InputState {
    var markableControlTextColor: UIColor {
        switch self {
        case .disabled:
            return Color.gray
        case .error:
            return Color.red
        default:
            return Color.black
        }
    }
}

public extension UIControl {
    // UIControl doesn't have an error state by default, though many of our component subclasses do
    func inputState(hasError: Bool = false) -> InputState {
        if isEnabled == false {
            return .disabled
        } else if hasError {
            return .error
        } else if isSelected || isHighlighted || isFirstResponder {
            return .highlighted
        } else {
            return .default
        }
    }
}
