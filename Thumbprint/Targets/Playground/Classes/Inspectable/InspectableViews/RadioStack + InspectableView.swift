import RxSwift
import Thumbprint

extension RadioStack: InspectableView {
    var inspectableProperties: [InspectableProperty] {
        let hideBorderProperty = BoolInspectableProperty(inspectedView: inspectableBorderView)
        hideBorderProperty.title = "Hide playground border?"
        hideBorderProperty.property = \InspectableBorderView.isHidden

        return [hideBorderProperty]
    }

    static func makeInspectable() -> UIView & InspectableView {
        let stack = RadioStack(
            titles: [
                "A) Foster peace on earth",
                "B) Destroy, all humans",
                "C) Nah, too much work",
                "D) All of the above",
            ]
        )
        stack.snp.makeConstraints { make in
            make.width.equalTo(375 - Space.three * 2)
        }
        return stack
    }
}
