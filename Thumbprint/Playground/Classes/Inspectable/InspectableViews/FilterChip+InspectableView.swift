import Thumbprint
import UIKit

extension FilterChip: InspectableView {
    var inspectableProperties: [InspectableProperty] {
        let textProperty = StringInspectableProperty(inspectedView: self)
        textProperty.title = "Text"
        textProperty.property = \FilterChip.text

        let isFilterAppliedProperty = BoolInspectableProperty(inspectedView: self)
        isFilterAppliedProperty.title = "isSelected"
        isFilterAppliedProperty.property = \FilterChip.isSelected

        return [
            textProperty,
            isFilterAppliedProperty,
        ]
    }

    static func makeInspectable() -> UIView & InspectableView {
        let filterChip = FilterChip()
        filterChip.text = "FilterChip"

        return filterChip
    }
}
