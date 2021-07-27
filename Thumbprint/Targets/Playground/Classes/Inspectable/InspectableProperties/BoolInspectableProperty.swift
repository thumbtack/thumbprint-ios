import RxSwift
import Thumbprint
import UIKit

/// Setup information for configuring a Bool property in the Playground Inspector.
class BoolInspectableProperty<T>: InspectableProperty {
    var inspectedView: T
    var property: WritableKeyPath<T, Bool>? {
        didSet {
            guard let property = property else { return }
            self.switch.isOn = inspectedView[keyPath: property]
        }
    }

    var title: String?

    var controlView: UIView {
        self.switch
    }

    private let `switch`: UISwitch
    private let disposeBag = DisposeBag()

    init(inspectedView: T) {
        self.inspectedView = inspectedView
        self.switch = UISwitch()

        self.switch.rx.value
            .subscribe(onNext: { [weak self] in
                guard let self = self, let property = self.property else { return }

                self.inspectedView[keyPath: property] = $0
            })
            .disposed(by: disposeBag)
    }
}
