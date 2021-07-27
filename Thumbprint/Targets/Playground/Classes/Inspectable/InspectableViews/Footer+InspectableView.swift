import RxSwift
import Thumbprint

extension Footer: InspectableView {
    var inspectableProperties: [InspectableProperty] {
        let hideBorderProperty = BoolInspectableProperty(inspectedView: inspectableBorderView)
        hideBorderProperty.title = "Hide playground border?"
        hideBorderProperty.property = \InspectableBorderView.isHidden

        return [
            hideBorderProperty,
        ]
    }

    static func makeInspectable() -> UIView & InspectableView {
        let footer = Footer(showShadowByDefault: true)

        let leftButton = Button()
        leftButton.title = "Left"
        let rightButton = Button()
        rightButton.title = "Right"
        let buttonRow = ButtonRow(leftButton: leftButton, rightButton: rightButton, distribution: .equal)
        footer.contentView.addSubview(buttonRow)
        buttonRow.snapToSuperview(edges: .all)

        return footer
    }
}
