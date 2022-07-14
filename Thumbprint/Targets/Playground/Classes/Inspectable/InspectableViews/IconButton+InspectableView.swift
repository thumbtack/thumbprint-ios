import Thumbprint
import UIKit

extension IconButton: InspectableView {
    var inspectableProperties: [InspectableProperty] {
        let isEnabledProperty = BoolInspectableProperty(inspectedView: self)
        isEnabledProperty.title = "Is enabled?"
        isEnabledProperty.property = \IconButton.isEnabled

        let hideBorderProperty = BoolInspectableProperty(inspectedView: inspectableBorderView)
        hideBorderProperty.title = "Hide playground border?"
        hideBorderProperty.property = \InspectableBorderView.isHidden

        return [
            isEnabledProperty,
            hideBorderProperty,
        ]
    }

    static func makeInspectable() -> UIView & InspectableView {
        let button = IconButton(icon: Icon.contentActionsFilterMedium.image, accessibilityLabel: "Demo icon button")
        return button
    }
}
