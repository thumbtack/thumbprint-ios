import Thumbprint
import UIKit

extension Pill: InspectableView {
    var inspectableProperties: [InspectableProperty] {
        let titleProperty = StringInspectableProperty(inspectedView: self)
        titleProperty.title = "Title"
        titleProperty.property = \Pill.text

        let themeProperty = DropdownInspectableProperty(
            inspectedView: self,
            property: \Pill.theme,
            values: [
                (.gray, "Gray"),
                (.blue, "Blue"),
                (.purple, "Purple"),
                (.indigo, "Indigo"),
                (.red, "Red"),
                (.yellow, "Yellow"),
            ]
        )
        themeProperty.title = "Theme"

        let showIconProperty = DropdownInspectableProperty(
            inspectedView: self,
            property: \Pill.image,
            values: [
                (nil, "No icon"),
                (Icon.inputsThumbsUpTiny.image, "Thumbs Up icon"),
                (Icon.contentModifierLightningTiny.image, "Lightning icon"),
            ]
        )
        showIconProperty.title = "Image"

        return [themeProperty, titleProperty, showIconProperty]
    }

    static func makeInspectable() -> UIView & InspectableView {
        let pill = Pill()
        pill.text = "Pill"
        return pill
    }
}
