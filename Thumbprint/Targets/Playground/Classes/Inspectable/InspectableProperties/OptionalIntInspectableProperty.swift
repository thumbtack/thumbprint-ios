import RxSwift
import Thumbprint
import UIKit

class OptionalIntInspectableProperty<T>: InspectableProperty {
    var inspectedView: T
    var title: String?

    var property: WritableKeyPath<T, Int?>? {
        didSet {
            guard let property = property else { return }
            if let i = inspectedView[keyPath: property] {
                intInspector.textField.text = String(i)
            }
        }
    }

    var controlView: UIView { intInspector }
    private let intInspector: IntInspector
    private let disposeBag = DisposeBag()

    init(inspectedView: T) {
        self.inspectedView = inspectedView
        self.intInspector = IntInspector()

        intInspector.valueSubject.subscribe(onNext: { [weak self] value in
            guard let self = self, let property = self.property else { return }

            self.inspectedView[keyPath: property] = value
        }).disposed(by: disposeBag)
    }
}

private class IntInspector: UIView, UITextFieldDelegate {
    public let textField = UITextField()
    public var valueSubject = BehaviorSubject<Int?>(value: 0)
    private let disposeBag = DisposeBag()

    init() {
        super.init(frame: .null)

        textField.delegate = self
        textField.keyboardType = .numberPad
        textField.layer.borderWidth = 1
        textField.layer.borderColor = Color.gray.cgColor
        textField.rx.controlEvent([.editingChanged])
            .asObservable()
            .subscribe { [weak self] _ in
                guard let text = self?.textField.text, let i = Int(text) else {
                    self?.valueSubject.onNext(nil)
                    return
                }
                self?.valueSubject.onNext(i)
            }.disposed(by: disposeBag)

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
}
