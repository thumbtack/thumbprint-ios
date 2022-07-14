import Thumbprint
import UIKit

extension Button: InspectableView {
    var inspectableProperties: [InspectableProperty] {
        let titleProperty = StringInspectableProperty(inspectedView: self)
        titleProperty.title = "Title"
        titleProperty.property = \Button.title

        let themeProperty = DropdownInspectableProperty(
            inspectedView: self,
            property: \Button.theme,
            values: [
                (.primary, "Primary"),
                (.secondary, "Secondary"),
                (.tertiary, "Tertiary"),
                (.caution, "Caution"),
                (.solid, "Solid"),
                (.text, "Text"),
                (.link, "Link"),
            ]
        )
        themeProperty.title = "Theme"

        let sizeProperty = DropdownInspectableProperty(
            inspectedView: self,
            property: \Button.size,
            values: [
                (.default, "Default"),
                (.small, "Small"),
                (.text, "Text-only"),
            ]
        )
        sizeProperty.title = "Size"

        let showIconProperty = DropdownInspectableProperty(
            inspectedView: self,
            property: \Button.icon,
            values: [
                (nil, "No icon"),
                (Button.Icon(.leading, image: Thumbprint.Icon.contentActionsFilterSmall.image), "Leading filter icon"),
                (Button.Icon(.leading, image: Thumbprint.Icon.contentActionsAddSmall.image), "Leading add icon"),
                (Button.Icon(.trailing, image: Thumbprint.Icon.navigationCaretRightSmall.image), "Trailing caret icon"),
                (Button.Icon(.trailing, image: Thumbprint.Icon.contentActionsAddSmall.image), "Trailing add icon"),
            ]
        )
        showIconProperty.title = "Icon"

        let showIconRightProperty = DropdownInspectableProperty(
            inspectedView: self,
            property: \Button.icon,
            values: [
                (nil, "No icon"),
            ]
        )
        showIconRightProperty.title = "Right icon"

        let isLoadingProperty = BoolInspectableProperty(inspectedView: self)
        isLoadingProperty.title = "Is loading?"
        isLoadingProperty.property = \Button.isLoading

        let isEnabledProperty = BoolInspectableProperty(inspectedView: self)
        isEnabledProperty.title = "Is enabled?"
        isEnabledProperty.property = \Button.isEnabled

        let hapticProperty = BoolInspectableProperty(inspectedView: self)
        hapticProperty.title = "Haptic?"
        hapticProperty.property = \Button.isHapticFeedbackEnabled

        let hideBorderProperty = BoolInspectableProperty(inspectedView: inspectableBorderView)
        hideBorderProperty.title = "Hide playground border?"
        hideBorderProperty.property = \InspectableBorderView.isHidden

        return [
            titleProperty,
            themeProperty,
            sizeProperty,
            showIconProperty,
            isLoadingProperty,
            isEnabledProperty,
            hapticProperty,
            hideBorderProperty,
        ]
    }

    static func makeInspectable() -> UIView & InspectableView {
        let allButtonThemes: [Button.Theme] = [
            .primary,
            .secondary,
            .tertiary,
            .caution,
            .solid,
            .text,
        ]

        let initialButtonTheme = allButtonThemes.randomElement()! // swiftlint:disable:this force_unwrapping
        let initialButtonSize: Button.Size = initialButtonTheme == .text ? .text : .default

        let button = Button(theme: initialButtonTheme, size: initialButtonSize)

        button.title = "Button"

        button.setContentCompressionResistancePriority(.required, for: .horizontal)
        button.setContentHuggingPriority(.required, for: .horizontal)

        return button
    }
}
