import UIKit
import Thumbprint

extension TextArea: InspectableView {
    var inspectableProperties: [InspectableProperty] {
        let titleProperty = StringInspectableProperty(inspectedView: self)
        titleProperty.title = "Text"
        titleProperty.property = \TextArea.text

        let placeholderProperty = StringInspectableProperty(inspectedView: self)
        placeholderProperty.title = "Placeholder"
        placeholderProperty.property = \TextArea.placeholder

        let enabledProperty = BoolInspectableProperty(inspectedView: self)
        enabledProperty.title = "isEnabled"
        enabledProperty.property = \TextArea.isEnabled

        let hasErrorProperty = BoolInspectableProperty(inspectedView: self)
        hasErrorProperty.title = "hasError"
        hasErrorProperty.property = \TextArea.hasError

        let hideBorderProperty = BoolInspectableProperty(inspectedView: inspectableBorderView)
        hideBorderProperty.title = "Hide playground border?"
        hideBorderProperty.property = \InspectableBorderView.isHidden

        return [
            titleProperty,
            placeholderProperty,
            enabledProperty,
            hasErrorProperty,
            hideBorderProperty,
        ]
    }

    static func makeInspectable() -> UIView & InspectableView {
        let textArea = TextArea()
        textArea.placeholder = "Type something..."
        textArea.snp.makeConstraints { make in
            make.width.equalTo(375 - Space.three * 2)
        }

        return textArea
    }
}
