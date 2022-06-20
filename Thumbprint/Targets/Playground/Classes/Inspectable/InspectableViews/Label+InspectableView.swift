import Thumbprint
import UIKit

extension Label: InspectableView {
    var inspectableProperties: [InspectableProperty] {
        let textProperty = StringInspectableProperty(inspectedView: self)
        textProperty.title = "Text"
        textProperty.property = \Label.text

        let textStyleProperty = DropdownInspectableProperty(
            inspectedView: self,
            property: \Label.textStyle,
            values: [
                (.title1, "Title 1"),
                (.title2, "Title 2"),
                (.title3, "Title 3"),
                (.title4, "Title 4"),
                (.title5, "Title 5"),
                (.title6, "Title 6"),
                (.title7, "Title 7"),
                (.title8, "Title 8"),
                (.text1, "Text 1"),
                (.text2, "Text 2"),
                (.text3, "Text 3"),
            ]
        )
        textStyleProperty.title = "Text style"

        let hideBorderProperty = BoolInspectableProperty(inspectedView: inspectableBorderView)
        hideBorderProperty.title = "Hide playground border?"
        hideBorderProperty.property = \InspectableBorderView.isHidden

        return [
            textProperty,
            textStyleProperty,
            hideBorderProperty,
        ]
    }

    static func makeInspectable() -> UIView & InspectableView {
        let allTextStyles: [Font.TextStyle] = [
            .title1,
            .title2,
            .title3,
            .title4,
            .title5,
            .title6,
            .text1,
            .title7,
            .text2,
            .title8,
            .text3,
        ]

        let label = Label(textStyle: allTextStyles.randomElement()!) // swiftlint:disable:this force_unwrapping
        label.text = "This is a label"
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.isUserInteractionEnabled = true

        return label
    }
}
