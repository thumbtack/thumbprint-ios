import Thumbprint
import UIKit

extension ToggleChip: InspectableView {
    var inspectableProperties: [InspectableProperty] {
        let textProperty = StringInspectableProperty(inspectedView: self)
        textProperty.title = "Text"
        textProperty.property = \ToggleChip.text

        let isSelectedProperty = BoolInspectableProperty(inspectedView: self)
        isSelectedProperty.title = "isSelected"
        isSelectedProperty.property = \ToggleChip.isSelected

        return [
            textProperty,
            isSelectedProperty,
        ]
    }

    static func makeInspectable() -> UIView & InspectableView {
        let toggleChip = ToggleChip()
        toggleChip.text = "ToggleChip"

        return toggleChip
    }
}
