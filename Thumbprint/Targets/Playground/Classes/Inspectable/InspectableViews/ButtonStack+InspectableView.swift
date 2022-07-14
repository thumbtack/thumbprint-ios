import Thumbprint
import UIKit

extension ButtonStack: InspectableView {
    var inspectableProperties: [InspectableProperty] {
        let button0TitleProperty = StringInspectableProperty(inspectedView: buttons[0])
        button0TitleProperty.title = "Button 0 title"
        button0TitleProperty.property = \Button.title

        let button0ThemeProperty = DropdownInspectableProperty(
            inspectedView: buttons[0],
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
        button0ThemeProperty.title = "Button 0 theme"

        let button0ShowIconProperty = DropdownInspectableProperty(
            inspectedView: buttons[0],
            property: \Button.icon,
            values: [
                (nil, "No icon"),
                (Button.Icon(.leading, image: Thumbprint.Icon.contentActionsFilterSmall.image), "Filter icon"),
                (Button.Icon(.leading, image: Thumbprint.Icon.contentActionsAddSmall.image), "Add icon"),
            ]
        )
        button0ShowIconProperty.title = "Button 0 icon"

        let button0IsLoadingProperty = BoolInspectableProperty(inspectedView: buttons[0])
        button0IsLoadingProperty.title = "Button 0 is loading?"
        button0IsLoadingProperty.property = \Button.isLoading

        let button0IsEnabledProperty = BoolInspectableProperty(inspectedView: buttons[0])
        button0IsEnabledProperty.title = "Button 0 is enabled?"
        button0IsEnabledProperty.property = \Button.isEnabled

        let button0HapticProperty = BoolInspectableProperty(inspectedView: buttons[0])
        button0HapticProperty.title = "Button 0 haptic?"
        button0HapticProperty.property = \Button.isHapticFeedbackEnabled

        let button1TitleProperty = StringInspectableProperty(inspectedView: buttons[1])
        button1TitleProperty.title = "Button 1 title"
        button1TitleProperty.property = \Button.title

        let button1ThemeProperty = DropdownInspectableProperty(
            inspectedView: buttons[1],
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
        button1ThemeProperty.title = "Button 1 theme"

        let button1ShowIconProperty = DropdownInspectableProperty(
            inspectedView: buttons[1],
            property: \Button.icon,
            values: [
                (nil, "No icon"),
                (Button.Icon(.leading, image: Thumbprint.Icon.contentActionsFilterSmall.image), "Filter icon"),
                (Button.Icon(.leading, image: Thumbprint.Icon.contentActionsAddSmall.image), "Add icon"),
            ]
        )
        button1ShowIconProperty.title = "Button 1 icon"

        let button1IsLoadingProperty = BoolInspectableProperty(inspectedView: buttons[1])
        button1IsLoadingProperty.title = "Button 1 is loading?"
        button1IsLoadingProperty.property = \Button.isLoading

        let button1IsEnabledProperty = BoolInspectableProperty(inspectedView: buttons[1])
        button1IsEnabledProperty.title = "Button 1 is enabled?"
        button1IsEnabledProperty.property = \Button.isEnabled

        let button1HapticProperty = BoolInspectableProperty(inspectedView: buttons[1])
        button1HapticProperty.title = "Button 1 haptic?"
        button1HapticProperty.property = \Button.isHapticFeedbackEnabled

        let button2TitleProperty = StringInspectableProperty(inspectedView: buttons[2])
        button2TitleProperty.title = "Button 2 title"
        button2TitleProperty.property = \Button.title

        let button2ThemeProperty = DropdownInspectableProperty(
            inspectedView: buttons[2],
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
        button2ThemeProperty.title = "Button 2 theme"

        let button2ShowIconProperty = DropdownInspectableProperty(
            inspectedView: buttons[2],
            property: \Button.icon,
            values: [
                (nil, "No icon"),
                (Button.Icon(.leading, image: Thumbprint.Icon.contentActionsFilterSmall.image), "Filter icon"),
                (Button.Icon(.leading, image: Thumbprint.Icon.contentActionsAddSmall.image), "Add icon"),
            ]
        )
        button2ShowIconProperty.title = "Button 2 icon"

        let button2IsLoadingProperty = BoolInspectableProperty(inspectedView: buttons[2])
        button2IsLoadingProperty.title = "Button 2 is loading?"
        button2IsLoadingProperty.property = \Button.isLoading

        let button2IsEnabledProperty = BoolInspectableProperty(inspectedView: buttons[2])
        button2IsEnabledProperty.title = "Button 2 is enabled?"
        button2IsEnabledProperty.property = \Button.isEnabled

        let button2HapticProperty = BoolInspectableProperty(inspectedView: buttons[2])
        button2HapticProperty.title = "Button 2 haptic?"
        button2HapticProperty.property = \Button.isHapticFeedbackEnabled

        let hideBorderProperty = BoolInspectableProperty(inspectedView: inspectableBorderView)
        hideBorderProperty.title = "Hide playground border?"
        hideBorderProperty.property = \InspectableBorderView.isHidden

        return [
            button0TitleProperty,
            button0ThemeProperty,
            button0ShowIconProperty,
            button0IsLoadingProperty,
            button0IsEnabledProperty,
            button0HapticProperty,
            button1TitleProperty,
            button1ThemeProperty,
            button1ShowIconProperty,
            button1IsLoadingProperty,
            button1IsEnabledProperty,
            button1HapticProperty,
            button2TitleProperty,
            button2ThemeProperty,
            button2ShowIconProperty,
            button2IsLoadingProperty,
            button2IsEnabledProperty,
            button2HapticProperty,
            hideBorderProperty,
        ]
    }

    static func makeInspectable() -> UIView & InspectableView {
        let button0 = Button(theme: .primary)
        button0.title = "Primary"

        let button1 = Button(theme: .secondary)
        button1.title = "Secondary"

        let button2 = Button(theme: .text)
        button2.title = "Text"

        return ButtonStack(buttons: [button0, button1, button2])
    }
}
