import RxSwift
import Thumbprint

extension Radio: InspectableView {
    static var buttonIndex: Int = 0

    var inspectableProperties: [InspectableProperty] {
        let enabledProperty = BoolInspectableProperty(inspectedView: self)
        enabledProperty.title = "isEnabled"
        enabledProperty.property = \Radio.isEnabled

        let isSelectedProperty = BoolInspectableProperty(inspectedView: self)
        isSelectedProperty.title = "isSelected"
        isSelectedProperty.property = \Radio.isSelected

        let isHighlightedProperty = BoolInspectableProperty(inspectedView: self)
        isHighlightedProperty.title = "isHighlighted"
        isHighlightedProperty.property = \Radio.isHighlighted

        let hasErrorProperty = BoolInspectableProperty(inspectedView: self)
        hasErrorProperty.title = "hasError"
        hasErrorProperty.property = \Radio.hasError

        let hideBorderProperty = BoolInspectableProperty(inspectedView: inspectableBorderView)
        hideBorderProperty.title = "Hide playground border?"
        hideBorderProperty.property = \InspectableBorderView.isHidden

        return [enabledProperty, isSelectedProperty, isHighlightedProperty, hasErrorProperty, hideBorderProperty]
    }

    static func makeInspectable() -> UIView & InspectableView {
        switch Int.random(in: 0 ... 2) {
        case 0:
            return makeColorRadio()
        case 1:
            return makeTextRadio()
        default:
            return makeEmptyRadio()
        }
    }

    static func makeTextRadio() -> Radio {
        let text = "Radio Button #\(Radio.buttonIndex)"
        buttonIndex += 1

        let label = StateInspectableLabel(textStyle: Font.TextStyle.text1)
        label.text = text

        let radioView = Radio(contentView: label)
        return radioView
    }

    static func makeColorRadio() -> Radio {
        let red = CGFloat(Float.random(in: 0 ..< 1))
        let green = CGFloat(Float.random(in: 0 ..< 1))
        let blue = CGFloat(Float.random(in: 0 ..< 1))

        let colorView = UIView()
        colorView.backgroundColor = UIColor(red: red, green: green, blue: blue, alpha: 1)
        colorView.snp.makeConstraints { make in
            make.height.equalTo(24)
            make.width.equalTo(24)
        }

        let radioView = Radio(contentView: colorView)
        return radioView
    }

    static func makeEmptyRadio() -> Radio {
        let radio = Radio()
        return radio
    }
}

// UILabel has an extension to suport InputStateConfigurable, but it's in TTCoreUI, so I'm faking it here
private class StateInspectableLabel: Label, InputStateConfigurable {
    public func inputStateDidChange(to inputState: InputState) {
        textColor = inputState.markableControlTextColor
    }
}
