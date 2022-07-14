import Thumbprint
import UIKit

extension ButtonRow: InspectableView {
    var inspectableProperties: [InspectableProperty] {
        let distributionProperty = DropdownInspectableProperty(
            inspectedView: self,
            property: \ButtonRow.distribution,
            values: [
                (.equal, "Equal"),
                (.emphasis, "Emphasis"),
                (.minimal, "Minimal"),
            ]
        )
        distributionProperty.title = "Distribution"

        let leftButtonTitleProperty = StringInspectableProperty(inspectedView: leftButton)
        leftButtonTitleProperty.title = "Left button title"
        leftButtonTitleProperty.property = \Button.title

        let leftButtonThemeProperty = DropdownInspectableProperty(
            inspectedView: leftButton,
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
        leftButtonThemeProperty.title = "Left button theme"

        let leftButtonShowIconProperty: DropdownInspectableProperty<Button, Button.Icon?> = .init(
            inspectedView: leftButton,
            property: \Button.icon,
            values: [
                (nil, "No icon"),
                (Button.Icon(.leading, image: Thumbprint.Icon.contentActionsFilterSmall.image), "Filter icon"),
                (Button.Icon(.leading, image: Thumbprint.Icon.contentActionsAddSmall.image), "Add icon"),
            ]
        )
        leftButtonShowIconProperty.title = "Left button icon"

        let leftButtonIsLoadingProperty = BoolInspectableProperty(inspectedView: leftButton)
        leftButtonIsLoadingProperty.title = "Left button is loading?"
        leftButtonIsLoadingProperty.property = \Button.isLoading

        let leftButtonIsEnabledProperty = BoolInspectableProperty(inspectedView: leftButton)
        leftButtonIsEnabledProperty.title = "Left button is enabled?"
        leftButtonIsEnabledProperty.property = \Button.isEnabled

        let leftButtonHapticProperty = BoolInspectableProperty(inspectedView: leftButton)
        leftButtonHapticProperty.title = "Left button haptic?"
        leftButtonHapticProperty.property = \Button.isHapticFeedbackEnabled

        let rightButtonTitleProperty = StringInspectableProperty(inspectedView: rightButton)
        rightButtonTitleProperty.title = "Right button title"
        rightButtonTitleProperty.property = \Button.title

        let rightButtonThemeProperty = DropdownInspectableProperty(
            inspectedView: leftButton,
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
        rightButtonThemeProperty.title = "Right button theme"

        let rightButtonShowIconProperty = DropdownInspectableProperty(
            inspectedView: rightButton,
            property: \Button.icon,
            values: [
                (nil, "No icon"),
                (Button.Icon(.leading, image: Thumbprint.Icon.contentActionsFilterSmall.image), "Filter icon"),
                (Button.Icon(.leading, image: Thumbprint.Icon.contentActionsAddSmall.image), "Add icon"),
            ]
        )
        rightButtonShowIconProperty.title = "Right button icon"

        let rightButtonIsLoadingProperty = BoolInspectableProperty(inspectedView: rightButton)
        rightButtonIsLoadingProperty.title = "Right button is loading?"
        rightButtonIsLoadingProperty.property = \Button.isLoading

        let rightButtonIsEnabledProperty = BoolInspectableProperty(inspectedView: rightButton)
        rightButtonIsEnabledProperty.title = "Right button is enabled?"
        rightButtonIsEnabledProperty.property = \Button.isEnabled

        let rightButtonHapticProperty = BoolInspectableProperty(inspectedView: rightButton)
        rightButtonHapticProperty.title = "Right button haptic?"
        rightButtonHapticProperty.property = \Button.isHapticFeedbackEnabled

        let hideBorderProperty = BoolInspectableProperty(inspectedView: inspectableBorderView)
        hideBorderProperty.title = "Hide playground border?"
        hideBorderProperty.property = \InspectableBorderView.isHidden

        return [
            distributionProperty,
            leftButtonTitleProperty,
            leftButtonThemeProperty,
            leftButtonShowIconProperty,
            leftButtonIsLoadingProperty,
            leftButtonIsEnabledProperty,
            leftButtonHapticProperty,
            rightButtonTitleProperty,
            rightButtonThemeProperty,
            rightButtonShowIconProperty,
            rightButtonIsLoadingProperty,
            rightButtonIsEnabledProperty,
            rightButtonHapticProperty,
            hideBorderProperty,
        ]
    }

    static func makeInspectable() -> UIView & InspectableView {
        let leftButton = Button(theme: .secondary, size: .default)
        let rightButton = Button(theme: .primary, size: .default)

        let buttonRow = ButtonRow(leftButton: leftButton, rightButton: rightButton)
        buttonRow.leftButton.title = "Secondary"
        buttonRow.rightButton.title = "Primary"

        buttonRow.snp.makeConstraints { make in
            make.width.equalTo(375 - Space.three * 2)
        }

        return buttonRow
    }
}
