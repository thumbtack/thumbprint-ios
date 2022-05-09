import UIKit

/// A multiline, editable, text input control
public final class TextArea: Control, UIContentSizeCategoryAdjusting, UITextInputTraits {
    // MARK: - Public Interface
    /// Adds visual indication that the text area is in an erroneous state
    public var hasError: Bool = false { didSet { updateState() } }

    /// When false, adds visual indication that the text area is disabled, and disallows user interaction
    public override var isEnabled: Bool {
        didSet {
            updateState()
            textView.isEditable = isEnabled
        }
    }

    public override var isHighlighted: Bool {
        didSet { updateState() }
    }

    /// Sets the text area's placeholder text, which is displayed when the textArea's text is empty
    public var placeholder: String? {
        get { placeholderTextView.text }
        set { placeholderTextView.text = newValue }
    }

    /// Sets the text area's text.  If empty, the placeholder text will be shown instead
    public var text: String? {
        get { textView.text }
        set {
            textView.text = newValue
            textViewDidChange(textView)
        }
    }

    public var textStorage: NSTextStorage { textView.textStorage }

    // MARK: - First Responder Pass-through
    @discardableResult
    public override func becomeFirstResponder() -> Bool {
        defer { updateState() }
        return textView.becomeFirstResponder()
    }

    @discardableResult
    public override func resignFirstResponder() -> Bool {
        defer { updateState() }
        return textView.resignFirstResponder()
    }

    public override var isFirstResponder: Bool {
        textView.isFirstResponder
    }

    // MARK: - UIResponder input view properties
    // Note: a simple passthrough isn't possible, because the default text control
    // implementation for the input view properties is to ask the superview if not set,
    // which comes right back here until we run out of stack.

    private var inputViewValue: UIView?
    public override var inputView: UIView? {
        get {
            inputViewValue
        }
        set {
            inputViewValue = newValue
            textView.inputView = newValue
        }
    }

    private var inputAccessoryViewValue: UIView?
    public override var inputAccessoryView: UIView? {
        get {
            inputAccessoryViewValue
        }
        set {
            inputAccessoryViewValue = newValue
            textView.inputAccessoryView = newValue
        }
    }

    // MARK: - UIContentSizeCategoryAdjusting

    public var adjustsFontForContentSizeCategory: Bool {
        didSet {
            guard adjustsFontForContentSizeCategory != oldValue else { return }

            [placeholderTextView, textView].forEach {
                $0.font = font(for: .text1)
            }
        }
    }

    // MARK: - UITextInputTraits

    public var keyboardType: UIKeyboardType {
        get { textView.keyboardType }
        set { textView.keyboardType = newValue }
    }

    public var keyboardAppearance: UIKeyboardAppearance {
        get { textView.keyboardAppearance }
        set { textView.keyboardAppearance = newValue }
    }

    public var returnKeyType: UIReturnKeyType {
        get { textView.returnKeyType }
        set { textView.returnKeyType = newValue }
    }

    public var textContentType: UITextContentType! { // swiftlint:disable:this implicitly_unwrapped_optional
        get { textView.textContentType }
        set { textView.textContentType = newValue }
    }

    public var isSecureTextEntry: Bool {
        get { textView.isSecureTextEntry }
        set { textView.isSecureTextEntry = newValue }
    }

    public var enablesReturnKeyAutomatically: Bool {
        get { textView.enablesReturnKeyAutomatically }
        set { textView.enablesReturnKeyAutomatically = newValue }
    }

    public var autocapitalizationType: UITextAutocapitalizationType {
        get { textView.autocapitalizationType }
        set { textView.autocapitalizationType = newValue }
    }

    public var autocorrectionType: UITextAutocorrectionType {
        get { textView.autocorrectionType }
        set { textView.autocorrectionType = newValue }
    }

    public var spellCheckingType: UITextSpellCheckingType {
        get { textView.spellCheckingType }
        set { textView.spellCheckingType = newValue }
    }

    public var smartQuotesType: UITextSmartQuotesType {
        get { textView.smartQuotesType }
        set { textView.smartQuotesType = newValue }
    }

    public var smartDashesType: UITextSmartDashesType {
        get { textView.smartDashesType }
        set { textView.smartDashesType = newValue }
    }

    public var smartInsertDeleteType: UITextSmartInsertDeleteType {
        get { textView.smartInsertDeleteType }
        set { textView.smartInsertDeleteType = newValue }
    }

    // MARK: - Private Properties
    fileprivate let textView: UITextView
    private let placeholderTextView: UITextView
    private let borderedContainer: UIView

    // MARK: Initialization

    /// Creates and returns a new text area.
    ///
    /// - Parameters:
    ///   - adjustsFontForContentSizeCategory: Boolean indicating whether this text area
    ///                                        should support Dynamic Type.
    public init(adjustsFontForContentSizeCategory: Bool = true) {
        self.adjustsFontForContentSizeCategory = adjustsFontForContentSizeCategory

        self.textView = UITextView()
        self.placeholderTextView = UITextView()
        self.borderedContainer = UIView()

        super.init(frame: .null)

        tintColor = Color.blue

        placeholderTextView.isScrollEnabled = false
        placeholderTextView.isEditable = false
        placeholderTextView.backgroundColor = .clear
        placeholderTextView.textContainerInset = .zero
        placeholderTextView.textContainer.lineFragmentPadding = 0
        placeholderTextView.adjustsFontForContentSizeCategory = adjustsFontForContentSizeCategory
        placeholderTextView.font = font(for: .text1)

        textView.isScrollEnabled = true
        textView.showsHorizontalScrollIndicator = false
        textView.isEditable = true
        textView.backgroundColor = .clear
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = 0
        textView.adjustsFontForContentSizeCategory = adjustsFontForContentSizeCategory
        textView.font = font(for: .text1)
        textView.delegate = self

        borderedContainer.layer.cornerRadius = 4
        borderedContainer.layer.borderWidth = 1

        borderedContainer.addSubview(placeholderTextView)
        borderedContainer.addSubview(textView)
        addSubview(borderedContainer)

        addSubviewConstraints()

        defer { updateState() } // swiftlint:disable:this inert_defer
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private functions
private extension TextArea {
    func addSubviewConstraints() {
        borderedContainer.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(164)
        }

        textView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(Space.three)
        }

        placeholderTextView.snp.makeConstraints { make in
            make.edges.equalTo(textView)
        }
    }

    func updateState() {
        let inputState = self.inputState(hasError: hasError)

        borderedContainer.backgroundColor = inputState.backgroundColor
        borderedContainer.layer.borderColor = inputState.borderColor.cgColor
        textView.textColor = inputState.textColor
        placeholderTextView.textColor = inputState.placeholderTextColor
    }
}

// MARK: - UITextViewDelegate
extension TextArea: UITextViewDelegate {
    public func textViewDidBeginEditing(_ textView: UITextView) {
        updateState()
        sendActions(for: .editingDidBegin)
    }

    public func textViewDidChange(_ textView: UITextView) {
        placeholderTextView.isHidden = !textView.text.isEmpty
        updateState()
        sendActions(for: .editingChanged)
    }
}
