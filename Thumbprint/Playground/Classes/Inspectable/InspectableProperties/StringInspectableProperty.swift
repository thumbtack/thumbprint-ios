import RxSwift
import Thumbprint
import UIKit

/// Setup information for configuring an Optional<String> property in the Playground Inspector.
class StringInspectableProperty<T>: InspectableProperty {
    var inspectedView: T
    var property: WritableKeyPath<T, String?>? {
        didSet {
            guard let property = property else { return }
            textField.text = inspectedView[keyPath: property]
        }
    }

    var title: String?

    var controlView: UIView {
        textField
    }

    private let textField: TextInput
    private let disposeBag = DisposeBag()

    init(inspectedView: T) {
        self.inspectedView = inspectedView
        self.textField = TextInput()

        textField.rx.text
            .subscribe(onNext: { [weak self] in
                guard let self = self, let property = self.property else { return }

                self.inspectedView[keyPath: property] = $0
            })
            .disposed(by: disposeBag)
    }
}
