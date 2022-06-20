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

    private let property: WritableKeyPath<ViewType, PropertyType>
    private let values: [(PropertyType, String)]
    private let dropdown: Dropdown

    init(inspectedView: ViewType,
         property: WritableKeyPath<ViewType, PropertyType>,
         values: [(PropertyType, String)]) {
        self.inspectedView = inspectedView
        self.property = property
        self.values = values
        self.dropdown = Dropdown(optionTitles: values.map({ $0.1 }))
        dropdown.addTarget(self, action: #selector(valueChanged(sender:)), for: .valueChanged)

        dropdown.selectedIndex = values.map({ $0.0 }).firstIndex(of: inspectedView[keyPath: property])
    }

    @objc private func valueChanged(sender: AnyObject) {
        guard let selectedIndex = dropdown.selectedIndex else { return }
        inspectedView[keyPath: property] = values[selectedIndex].0
    }
}
