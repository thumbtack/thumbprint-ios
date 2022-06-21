import Thumbprint
import UIKit

extension LabeledCheckbox: InspectableView {
    static let marks: [Checkbox.Mark] = [.empty, .checked, .intermediate]
    static let contentPlacements: [LabeledCheckbox.ContentPlacement] = [.left, .right]

    static var buttonIndex: Int = 0

    var inspectableProperties: [InspectableProperty] {
        let enabledProperty = BoolInspectableProperty(inspectedView: self)
        enabledProperty.title = "isEnabled"
        enabledProperty.property = \LabeledCheckbox.isEnabled

        let hasErrorProperty = BoolInspectableProperty(inspectedView: self)
        hasErrorProperty.title = "hasError"
        hasErrorProperty.property = \LabeledCheckbox.hasError

        let isHighlightedProperty = BoolInspectableProperty(inspectedView: self)
        isHighlightedProperty.title = "isHighlighted"
        isHighlightedProperty.property = \LabeledCheckbox.isHighlighted

        let markInspectableProperty = DropdownInspectableProperty(
            inspectedView: self,
            property: \LabeledCheckbox.mark,
            values: LabeledCheckbox.marks.map({ ($0, $0.rawValue) })
        )
        markInspectableProperty.title = "Mark"

        let hideBorderProperty = BoolInspectableProperty(inspectedView: inspectableBorderView)
        hideBorderProperty.title = "Hide playground border?"
        hideBorderProperty.property = \InspectableBorderView.isHidden

        let contentPlacementInspectableProperty = DropdownInspectableProperty(
            inspectedView: self,
            property: \LabeledCheckbox.contentPlacement,
            values: LabeledCheckbox.contentPlacements.map({ ($0, $0.rawValue) })
        )
        contentPlacementInspectableProperty.title = "Content placement"

        return [
            enabledProperty,
            hasErrorProperty,
            isHighlightedProperty,
            markInspectableProperty,
            hideBorderProperty,
            contentPlacementInspectableProperty,
        ]
    }

    static func makeInspectable() -> UIView & InspectableView {
        let checkBox = makeTextCheckbox()

        let mark = Int.random(in: 0 ... 2)
        if mark == 0 {
            checkBox.mark = .empty
        } else if mark == 1 {
            checkBox.mark = .intermediate
        } else {
            checkBox.mark = .checked
        }

        let contentPlacement = Bool.random()
        if contentPlacement {
            checkBox.contentPlacement = .right
        } else {
            checkBox.contentPlacement = .left
        }

        return checkBox
    }

    static func makeTextCheckbox() -> LabeledCheckbox {
        let text = "Checkbox #\(LabeledCheckbox.buttonIndex)"
        LabeledCheckbox.buttonIndex += 1

        return LabeledCheckbox(text: text)
    }
}
