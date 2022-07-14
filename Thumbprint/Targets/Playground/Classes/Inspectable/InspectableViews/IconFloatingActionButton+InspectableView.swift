import Thumbprint
import UIKit

extension IconFloatingActionButton: InspectableView {
    var inspectableProperties: [InspectableProperty] {
        let themeProperty = DropdownInspectableProperty(
            inspectedView: self, property: \IconFloatingActionButton.theme,
            values: [
                (IconFloatingActionButton.Theme.primary, "Primary"),
                (IconFloatingActionButton.Theme.secondary, "Secondary"),
            ]
        )
        themeProperty.title = "Theme"

        return [themeProperty]
    }

    static func makeInspectable() -> UIView & InspectableView {
        IconFloatingActionButton(
            icon: Icon.contentActionsAddMedium.image,
            accessibilityLabel: "Add new items"
        )
    }
}
