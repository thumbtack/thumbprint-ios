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
    private static let defaultInputStateBackgroundImage = UIImage(named: "defaultInputStateBackground", in: Bundle.module, compatibleWith: nil)!
    private static let highlightedInputStateBackground = UIImage(named: "highlightedInputStateBackground", in: Bundle.module, compatibleWith: nil)!
    private static let errorInputStateBackground = UIImage(named: "errorInputStateBackground", in: Bundle.module, compatibleWith: nil)!
    private static let disabledInputStateBackground = UIImage(named: "disabledInputStateBackground", in: Bundle.module, compatibleWith: nil)!
    // swiftlint:enable force_unwrapping

    public var backgroundImage: UIImage {
        switch self {
        case .default:
            InputState.defaultInputStateBackgroundImage
        case .highlighted:
            InputState.highlightedInputStateBackground
        case .disabled:
            InputState.disabledInputStateBackground
        case .error:
            InputState.errorInputStateBackground
        }
    }

    public var borderColor: UIColor {
        switch self {
        case .default:
            Color.gray
        case .highlighted:
            Color.blue
        case .disabled:
            Color.gray300
        case .error:
            Color.red
        }
    }

    public var backgroundColor: UIColor {
        switch self {
        case .disabled:
            Color.gray200
        default:
            Color.white
        }
    }

    public var textColor: UIColor {
        switch self {
        case .disabled:
            Color.gray
        case .error:
            Color.red
        default:
            Color.black
        }
    }

    public var placeholderTextColor: UIColor {
        switch self {
        case .error:
            Color.red300
        case .disabled:
            Color.gray
        default:
            Color.black300
        }
    }
}

// Input state extensions for "markable" controls (e.g. radio and checkbox)
public extension InputState {
    var markableControlTextColor: UIColor {
        switch self {
        case .disabled:
            Color.gray
        case .error:
            Color.red
        default:
            Color.black
        }
    }
}

public extension UIControl {
    // UIControl doesn't have an error state by default, though many of our component subclasses do
    func inputState(hasError: Bool = false) -> InputState {
        if isEnabled == false {
            .disabled
        } else if hasError {
            .error
        } else if isSelected || isHighlighted || isFirstResponder {
            .highlighted
        } else {
            .default
        }
    }
}
