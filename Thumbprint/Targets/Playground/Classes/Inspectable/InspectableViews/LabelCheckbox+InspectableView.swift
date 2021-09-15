import RxSwift
import Thumbprint

extension LabelCheckbox: InspectableView {
    static let marks: [Checkbox.Mark] = [.empty, .checked, .intermediate]
    static let contentPlacements: [LabelCheckbox.ContentPlacement] = [.left, .right]

    static var buttonIndex: Int = 0

    var inspectableProperties: [InspectableProperty] {
        let enabledProperty = BoolInspectableProperty(inspectedView: self)
        enabledProperty.title = "isEnabled"
        enabledProperty.property = \LabelCheckbox.isEnabled

        let hasErrorProperty = BoolInspectableProperty(inspectedView: self)
        hasErrorProperty.title = "hasError"
        hasErrorProperty.property = \LabelCheckbox.hasError

        let isHighlightedProperty = BoolInspectableProperty(inspectedView: self)
        isHighlightedProperty.title = "isHighlighted"
        isHighlightedProperty.property = \LabelCheckbox.isHighlighted

        let markInspectableProperty = DropdownInspectableProperty(
            inspectedView: self,
            property: \LabelCheckbox.mark,
            values: LabelCheckbox.marks.map({ ($0, $0.rawValue) })
        )
        markInspectableProperty.title = "Mark"

        let hideBorderProperty = BoolInspectableProperty(inspectedView: inspectableBorderView)
        hideBorderProperty.title = "Hide playground border?"
        hideBorderProperty.property = \InspectableBorderView.isHidden

        let contentPlacementInspectableProperty = DropdownInspectableProperty(
            inspectedView: self,
            property: \LabelCheckbox.contentPlacement,
            values: LabelCheckbox.contentPlacements.map({ ($0, $0.rawValue) })
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

    static func makeTextCheckbox() -> LabelCheckbox {
        let text = "Checkbox #\(LabelCheckbox.buttonIndex)"
        LabelCheckbox.buttonIndex += 1

        return LabelCheckbox(text: text)
    }
}
