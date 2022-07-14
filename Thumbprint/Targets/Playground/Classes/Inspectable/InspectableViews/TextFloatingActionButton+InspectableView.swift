import Thumbprint
import UIKit

extension TextFloatingActionButton: InspectableView {
    var inspectableProperties: [InspectableProperty] {
        let themeProperty = DropdownInspectableProperty(
            inspectedView: self, property: \TextFloatingActionButton.theme,
            values: [
                (TextFloatingActionButton.Theme.primary, "Primary"),
                (TextFloatingActionButton.Theme.secondary, "Secondary"),
            ]
        )
        themeProperty.title = "Theme"

        return [themeProperty]
    }

    static func makeInspectable() -> UIView & InspectableView {
        let textFloatingActionButton = TextFloatingActionButton(
            text: "Floating action button",
            accessibilityLabel: "Floating action button"
        )
        let imageView = UIImageView(image: Icon.contentActionsAddMedium.image)
        textFloatingActionButton.setLeftView(imageView, largeContentImage: imageView.image)
        return textFloatingActionButton
    }
}
