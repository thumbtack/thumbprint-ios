import UIKit

public protocol DropdownDelegate: AnyObject {
    func dropdown(_: Dropdown, didSelectOptionAt index: Int?)
    func dropdown(_: Dropdown, didDismissWithOptionAt index: Int?)
}

public final class Dropdown: Control, UIContentSizeCategoryAdjusting {
    public static let defaultPlaceholder = "Choose one..."

    // MARK: - Public Interface
    /// Controls user interactability. Displays content in grey when set to false
    public override var isEnabled: Bool {
        didSet {
            updateState()
        }
    }

    /// Manually overrides highlighted state
    public override var isHighlighted: Bool {
        didSet {
            updateState()
        }
    }

    /// Adds a visual indication that the dropdown is in an erroneous state
    public var hasError: Bool = false { didSet { updateState() } }

    /// Delegate notifies handler when dropdown control has dismissed
    public weak var delegate: DropdownDelegate?

    /// The options displayed by the dropdown, not including the placeholder
    public var optionTitles: [String] {
        didSet {
            pickerView.reloadAllComponents()
        }
    }

    /// Text shown before the user has selected an option. Placeholder disappears after user taps dropdown, and cannot
    /// be reselected.
    public var placeholder: String? = Dropdown.defaultPlaceholder {
        didSet {
            if placeholder != nil, selectedIndex == nil {
                label.text = placeholder
            } else if placeholder == nil {
                label.text = optionTitles[selectedIndex ?? 0]
            }
        }
    }

    /// The index of of the option titles that should be displayed.
    /// Throws an exception if selectedIndex is greater than or equal to the number of optionTitles
    public var selectedIndex: Int? {
        didSet {
            if oldValue != selectedIndex { sendActions(for: .valueChanged) }
            guard let selectedIndex = selectedIndex else {
                label.text = placeholder
                return
            }

            label.text = optionTitles[selectedIndex]

            if pickerView.selectedRow(inComponent: 0) != selectedIndex {
                pickerView.selectRow(selectedIndex, inComponent: 0, animated: false)
            }
        }
    }

    // First Responder Overrides (for pickerview and visual highlighting)
    public override var canBecomeFirstResponder: Bool { true }

    @discardableResult
    public override func becomeFirstResponder() -> Bool {
        defer { updateState() }
        return super.becomeFirstResponder()
    }

    @discardableResult
    public override func resignFirstResponder() -> Bool {
        defer { updateState() }
        return super.resignFirstResponder()
    }

    // Input overrides
    public override var inputView: UIView? { pickerView }
    public override var inputAccessoryView: UIView? { toolbar }

    // UIContentSizeCategoryAdjusting
    public var adjustsFontForContentSizeCategory: Bool {
        didSet {
            guard adjustsFontForContentSizeCategory != oldValue else { return }

            label.adjustsFontForContentSizeCategory = adjustsFontForContentSizeCategory
        }
    }

    public init(optionTitles: [String], adjustsFontForContentSizeCategory: Bool = true) {
        self.optionTitles = optionTitles
        self.adjustsFontForContentSizeCategory = adjustsFontForContentSizeCategory
        self.label = Label(textStyle: .text1, adjustsFontForContentSizeCategory: adjustsFontForContentSizeCategory)

        super.init(frame: .null)

        label.text = Dropdown.defaultPlaceholder
        label.lineBreakMode = .byTruncatingTail

        backgroundColor = Color.white
        layer.cornerRadius = 4
        layer.borderWidth = 1

        pickerView.dataSource = self
        pickerView.delegate = self

        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissPicker))
        toolbar.setItems([
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            doneButton,
        ], animated: false)

        addSubview(label)
        addSubview(arrow)

        addSubviewConstraints()
        addTapToPresentPickerGesture()
        listenForPickerViewPresentation()

        defer { updateState() } // swiftlint:disable:this inert_defer
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private Implementation
    // Private Subviews
    private let pickerView = UIPickerView()
    private let toolbar: UIToolbar = {
        let toolbar = UIToolbar()
        toolbar.isTranslucent = true
        toolbar.isUserInteractionEnabled = true
        toolbar.sizeToFit()
        return toolbar
    }()

    private let label: Label

    private let arrow = UIImageView(image: Icon.navigationCaretDownMedium.image)

    private func addTapToPresentPickerGesture() {
        let tapGesture = UITapGestureRecognizer()
        addGestureRecognizer(tapGesture)
        tapGesture.addTarget(self, action: #selector(didTapToPresentPicker))
    }

    @objc private func didTapToPresentPicker() {
        becomeFirstResponder()
    }

    private func addSubviewConstraints() {
        label.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(Space.three)
            make.top.bottom.equalToSuperview().inset(12).priority(999)
        }

        arrow.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(Space.three)
            make.centerY.equalToSuperview()
            make.top.greaterThanOrEqualToSuperview()
            make.bottom.lessThanOrEqualToSuperview()
            make.left.equalTo(label.snp.right).offset(Space.two)
            make.size.equalTo(arrow.image?.size ?? .zero)
        }
    }

    private func listenForPickerViewPresentation() {
        NotificationCenter.default.addObserver(self, selector: #selector(pickerViewDidShow), name: UIResponder.keyboardDidShowNotification, object: nil)
    }

    @objc
    private func dismissPicker() {
        defer {
            delegate?.dropdown(self, didDismissWithOptionAt: selectedIndex)
        }

        resignFirstResponder()
    }

    @objc
    private func pickerViewDidShow(notification: Notification) {
        if isFirstResponder, selectedIndex == nil {
            selectedIndex = pickerView.selectedRow(inComponent: 0)
        }
    }

    private func updateState() {
        let inputState = self.inputState(hasError: hasError)

        backgroundColor = inputState.backgroundColor
        layer.borderColor = inputState.borderColor.cgColor
        arrow.tintColor = inputState.arrowColor
        label.textColor = inputState.textColor
    }
}

extension Dropdown: UIPickerViewDataSource {
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }

    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        optionTitles.count
    }
}

extension Dropdown: UIPickerViewDelegate {
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        optionTitles[row]
    }

    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedIndex = row
        delegate?.dropdown(self, didSelectOptionAt: selectedIndex)
    }
}

private extension InputState {
    var arrowColor: UIColor {
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
