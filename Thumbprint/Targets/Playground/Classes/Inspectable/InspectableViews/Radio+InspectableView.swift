import RxSwift
import Thumbprint

extension LabeledRadio: InspectableView {
    static var buttonIndex: Int = 0

    var inspectableProperties: [InspectableProperty] {
        let enabledProperty = BoolInspectableProperty(inspectedView: self)
        enabledProperty.title = "isEnabled"
        enabledProperty.property = \LabeledRadio.isEnabled

        let isSelectedProperty = BoolInspectableProperty(inspectedView: self)
        isSelectedProperty.title = "isSelected"
        isSelectedProperty.property = \LabeledRadio.isSelected

        let isHighlightedProperty = BoolInspectableProperty(inspectedView: self)
        isHighlightedProperty.title = "isHighlighted"
        isHighlightedProperty.property = \LabeledRadio.isHighlighted

        let hideBorderProperty = BoolInspectableProperty(inspectedView: inspectableBorderView)
        hideBorderProperty.title = "Hide playground border?"
        hideBorderProperty.property = \InspectableBorderView.isHidden

        let contentPlacementInspectableProperty = DropdownInspectableProperty(
            inspectedView: self,
            property: \LabeledRadio.contentPlacement,
            values: LabeledRadio.ContentPlacement.allCases.map({ ($0, String(describing: $0)) })
        )
        contentPlacementInspectableProperty.title = "Content placement"

        return [enabledProperty, isSelectedProperty, isHighlightedProperty, hideBorderProperty, contentPlacementInspectableProperty]
    }

    static func makeInspectable() -> UIView & InspectableView {
        buttonIndex += 1
        let radioView = LabeledRadio(text: "Radio Button #\(LabeledRadio.buttonIndex)")

        let contentPlacement = Bool.random()
        if contentPlacement {
            radioView.contentPlacement = .trailing
        } else {
            radioView.contentPlacement = .leading
        }

        return radioView
    }
}

// UILabel has an extension to suport InputStateConfigurable, but it's in TTCoreUI, so I'm faking it here
private class StateInspectableLabel: Label, InputStateConfigurable {
    public func inputStateDidChange(to inputState: InputState) {
        textColor = inputState.markableControlTextColor
    }
}
