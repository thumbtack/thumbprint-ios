import UIKit

/// A standard, single line, text input control
open class TextInput: UITextField {
    // MARK: - Public Interface

    /// Adds visual indication that the text input is in an erroneous state
    public var hasError: Bool = false { didSet { setNeedsLayout() } }

    /// Adds persistent visual highlight to the textField, as if it was the first responder, even if it's not
    open override var isHighlighted: Bool { didSet { setNeedsLayout() } }

    open override var intrinsicContentSize: CGSize {
        var result: CGSize = super.intrinsicContentSize

        let lineHeight: CGFloat = font?.lineHeight ?? 0
        result.height = lineHeight + 24

        return result
    }

    open override var placeholder: String? {
        didSet {
            guard let placeholder = placeholder, placeholder != oldValue else {
                return
            }

            let attributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: placeholderTextColor,
            ]

            attributedPlaceholder = NSAttributedString(string: placeholder, attributes: attributes)
        }
    }

    /// Suppresses the cursor display.
    open var hidesCaret: Bool = false

    open override var adjustsFontForContentSizeCategory: Bool {
        didSet {
            guard adjustsFontForContentSizeCategory != oldValue else { return }

            font = font(for: .text1)
            invalidateIntrinsicContentSize()
        }
    }

    // MARK: - Private properties
    private var placeholderTextColor: UIColor = InputState.default.placeholderTextColor

    // MARK: - Initialization

    /// Creates and returns a new text input.
    ///
    /// - Parameters:
    ///   - frame: The frame rectangle for the view, measured in points. The origin of
    ///            the frame is relative to the superview in which you plan to add it.
    ///            This method uses the frame rectangle to set the center and bounds
    ///            properties accordingly.
    ///   - adjustsFontForContentSizeCategory: Boolean indicating whether this text input
    ///                                        should support Dynamic Type.
    public init(frame: CGRect = .null, adjustsFontForContentSizeCategory: Bool = true) {
        super.init(frame: frame)

        self.adjustsFontForContentSizeCategory = adjustsFontForContentSizeCategory
        font = font(for: .text1)
        disabledBackground = InputState.disabled.backgroundImage
        tintColor = Color.blue
    }

    @available(*, unavailable)
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        intrinsicContentSize
    }

    open override func layoutSubviews() {
        let inputState = self.inputState(hasError: hasError)
        let inputStateBackground: UIImage = inputState.backgroundImage
        if background !== inputStateBackground {
            background = inputStateBackground
        }

        textColor = inputState.textColor

        if placeholderTextColor != inputState.placeholderTextColor {
            placeholderTextColor = inputState.placeholderTextColor

            if let placeholder = placeholder {
                let attributes: [NSAttributedString.Key: Any] = [
                    .foregroundColor: placeholderTextColor,
                ]
                attributedPlaceholder = NSAttributedString(string: placeholder, attributes: attributes)
            }
        }

        super.layoutSubviews()
    }

    open override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        guard let leftView = leftView else {
            return .zero
        }

        let fittingSize = leftView.sizeThatFits(bounds.size)
        let width: CGFloat = fittingSize.width
        let height: CGFloat = fittingSize.height

        let result = CGRect(x: Space.three, y: bounds.midY - (height / 2), width: width, height: height)
        return leftView.frame(forAlignmentRect: result)
    }

    open override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        guard let rightView = rightView else {
            return .zero
        }

        let fittingSize = rightView.sizeThatFits(bounds.size)
        let width: CGFloat = fittingSize.width
        let height: CGFloat = fittingSize.height

        let minX: CGFloat = bounds.maxX - Space.three - width
        let result = CGRect(x: minX, y: bounds.midY - (height / 2), width: width, height: height)
        return rightView.frame(forAlignmentRect: result)
    }

    private var isShowingLeftView: Bool {
        if leftView == nil {
            return false
        }

        switch leftViewMode {
        case .always:
            return true
        case .never:
            return false
        case .whileEditing:
            return isFirstResponder
        case .unlessEditing:
            return !isFirstResponder
        @unknown default:
            return false
        }
    }

    open override func textRect(forBounds bounds: CGRect) -> CGRect {
        var result = super.textRect(forBounds: bounds)

        if isShowingLeftView {
            result.origin.x += Space.two
            result.size.width -= Space.two
        } else {
            result.origin.x += Space.three
            result.size.width -= Space.three
        }

        result.size.width -= Space.three

        return result
    }

    open override func editingRect(forBounds bounds: CGRect) -> CGRect {
        var result = super.editingRect(forBounds: bounds)

        if isShowingLeftView {
            result.origin.x += Space.two
            result.size.width -= Space.two
        } else {
            result.origin.x += Space.three
            result.size.width -= Space.three
        }

        result.size.width -= Space.three

        return result
    }

    open override func clearButtonRect(forBounds bounds: CGRect) -> CGRect {
        var result = super.clearButtonRect(forBounds: bounds)
        result.origin.x = bounds.maxX - Space.three - result.size.width
        return result
    }

    open override func caretRect(for position: UITextPosition) -> CGRect {
        if hidesCaret {
            return .zero
        }
        return super.caretRect(for: position)
    }
}
