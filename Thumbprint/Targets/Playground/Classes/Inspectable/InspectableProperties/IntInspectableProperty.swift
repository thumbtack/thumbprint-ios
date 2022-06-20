import Combine
import Thumbprint
import UIKit

class IntInspectableProperty<T>: InspectableProperty {
    var inspectedView: T
    var title: String?

    var property: WritableKeyPath<T, Int>? {
        didSet {
            guard let property = property else { return }
            intInspector.textField.text = String(inspectedView[keyPath: property])
        }
    }

    var controlView: UIView { intInspector }
    private let intInspector: IntInspector
    private var subscriptions: Set<AnyCancellable> = Set()

    init(inspectedView: T) {
        self.inspectedView = inspectedView
        self.intInspector = IntInspector()
        intInspector.valueSubject
            .eraseToAnyPublisher()
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] value in
                guard let self = self, let property = self.property else { return }
                self.inspectedView[keyPath: property] = value
            })
            .store(in: &subscriptions)
    }
}

private class IntInspector: UIView, UITextFieldDelegate {
    public let textField = UITextField()
    public var valueSubject = CurrentValueSubject<Int, Never>(0)

    init() {
        super.init(frame: .null)

        textField.delegate = self
        textField.keyboardType = .numberPad
        textField.layer.borderWidth = 1
        textField.layer.borderColor = Color.gray.cgColor
        textField.text = String("\(0)")
        textField.addTarget(self, action: #selector(valueChanged(sender:)), for: .editingChanged)

        addSubview(textField)
        textField.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard !string.isEmpty else {
            return true
        }

        return CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: string))
    }

    @objc private func valueChanged(sender: AnyObject) {
        if let text = textField.text, let i = Int(text) {
            valueSubject.value = i
        }
    }
}
