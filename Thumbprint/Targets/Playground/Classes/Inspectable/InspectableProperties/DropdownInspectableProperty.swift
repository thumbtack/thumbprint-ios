import RxCocoa
import RxSwift
import Thumbprint
import UIKit

/// Setup information for configuring an arbitrary PropertyType property
/// in the Playground Inspector by selecting from a list of values.
class DropdownInspectableProperty<ViewType, PropertyType: Equatable>: InspectableProperty {
    private(set) var inspectedView: ViewType

    var title: String?

    var controlView: UIView {
        dropdown
    }

    private let dropdown: Dropdown
    private let disposeBag = DisposeBag()

    init(inspectedView: ViewType,
         property: WritableKeyPath<ViewType, PropertyType>,
         values: [(PropertyType, String)]) {
        self.inspectedView = inspectedView
        self.dropdown = Dropdown(optionTitles: values.map({ $0.1 }))

        dropdown.rx.controlEvent(.valueChanged)
            .subscribe(onNext: { [weak self] in
                guard let self = self,
                      let selectedIndex = self.dropdown.selectedIndex
                else { return }

                self.inspectedView[keyPath: property] = values[selectedIndex].0
            })
            .disposed(by: disposeBag)

        dropdown.selectedIndex = values.map({ $0.0 }).firstIndex(of: inspectedView[keyPath: property])
    }
}
