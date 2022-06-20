import UIKit
import Thumbprint

extension TextInput: InspectableView {
    var inspectableProperties: [InspectableProperty] {
        let titleProperty = StringInspectableProperty(inspectedView: self)
        titleProperty.title = "Text"
        titleProperty.property = \TextInput.text

        let placeholderProperty = StringInspectableProperty(inspectedView: self)
        placeholderProperty.title = "Placeholder"
        placeholderProperty.property = \TextInput.placeholder

        let clearableProperty = DropdownInspectableProperty(
            inspectedView: self,
            property: \TextInput.clearButtonMode,
            values: [
                (.never, "Never"),
                (.whileEditing, "While editing"),
                (.unlessEditing, "Unless editing"),
                (.always, "Always"),
            ]
        )
        clearableProperty.title = "clearButtonMode"

        let enabledProperty = BoolInspectableProperty(inspectedView: self)
        enabledProperty.title = "isEnabled"
        enabledProperty.property = \TextInput.isEnabled

        let hasErrorProperty = BoolInspectableProperty(inspectedView: self)
        hasErrorProperty.title = "hasError"
        hasErrorProperty.property = \TextInput.hasError

        let leftViewModeProperty = DropdownInspectableProperty(
            inspectedView: self,
            property: \TextInput.leftViewMode,
            values: [
                (.never, "Never"),
                (.whileEditing, "While editing"),
                (.unlessEditing, "Unless editing"),
                (.always, "Always"),
            ]
        )
        leftViewModeProperty.title = "leftViewMode"

        let innerLeftIcon = UIImageView(image: Icon.contentActionsAddSmall.withRenderingMode(.alwaysOriginal))
        innerLeftIcon.contentMode = .center
        let innerLeftLabel = Label(textStyle: .title8, adjustsFontForContentSizeCategory: false)
        innerLeftLabel.text = "Label"
        let innerLeftButton = Button(theme: .link, size: .text)
        innerLeftButton.title = "Button"
        let innerLeftViewProperty = DropdownInspectableProperty(
            inspectedView: self,
            property: \TextInput.leftView,
            values: [
                (nil, "None"),
                (innerLeftIcon, "Icon"),
                (innerLeftLabel, "Label"),
                (innerLeftButton, "Button"),
            ]
        )
        innerLeftViewProperty.title = "leftView"

        let rightViewModeProperty = DropdownInspectableProperty(
            inspectedView: self,
            property: \TextInput.rightViewMode,
            values: [
                (.never, "Never"),
                (.whileEditing, "While editing"),
                (.unlessEditing, "Unless editing"),
                (.always, "Always"),
            ]
        )
        rightViewModeProperty.title = "rightViewMode"

        let innerRightIcon = UIImageView(image: Icon.contentActionsAddSmall.withRenderingMode(.alwaysOriginal))
        innerRightIcon.contentMode = .center
        let innerRightLabel = Label(textStyle: .title8, adjustsFontForContentSizeCategory: false)
        innerRightLabel.text = "Label"
        let innerRightButton = Button(theme: .link, size: .text)
        innerRightButton.title = "Button"
        let innerRightViewProperty = DropdownInspectableProperty(
            inspectedView: self,
            property: \TextInput.rightView,
            values: [
                (nil, "None"),
                (innerRightIcon, "Icon"),
                (innerRightLabel, "Label"),
                (innerRightButton, "Button"),
            ]
        )
        innerRightViewProperty.title = "rightView"

        let hideBorderProperty = BoolInspectableProperty(inspectedView: inspectableBorderView)
        hideBorderProperty.title = "Hide playground border?"
        hideBorderProperty.property = \InspectableBorderView.isHidden

        return [
            titleProperty,
            placeholderProperty,
            clearableProperty,
            enabledProperty,
            hasErrorProperty,
            leftViewModeProperty,
            innerLeftViewProperty,
            rightViewModeProperty,
            innerRightViewProperty,
            hideBorderProperty,
        ]
    }

    static func makeInspectable() -> UIView & InspectableView {
        let textInput = TextInput()
        textInput.placeholder = "Type something..."
        textInput.snp.makeConstraints { make in
            make.width.equalTo(375 - Space.three * 2)
        }

        return textInput
    }
}
