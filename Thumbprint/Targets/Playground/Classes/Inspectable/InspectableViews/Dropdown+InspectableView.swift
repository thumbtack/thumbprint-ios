import RxSwift
import SnapKit
import Thumbprint

extension Dropdown: InspectableView {
    static var placeholderOptions: [String?] = [nil, "Select one..."]

    var inspectableProperties: [InspectableProperty] {
        let isEnabledProperty = BoolInspectableProperty(inspectedView: self)
        isEnabledProperty.title = "Is enabled?"
        isEnabledProperty.property = \Dropdown.isEnabled

        let hasErrorProperty = BoolInspectableProperty(inspectedView: self)
        hasErrorProperty.title = "Has error?"
        hasErrorProperty.property = \Dropdown.hasError

        let hideBorderProperty = BoolInspectableProperty(inspectedView: inspectableBorderView)
        hideBorderProperty.title = "Hide playground border?"
        hideBorderProperty.property = \InspectableBorderView.isHidden

        return [isEnabledProperty, hasErrorProperty, hideBorderProperty]
    }

    static func makeInspectable() -> UIView & InspectableView {
        let dropdown = Dropdown(
            optionTitles: [
                "Hello!",
                "Yes please",
                "No thank you",
                "Waaaaay toooo looooooooooooooooooooooooooong",
            ]
        )
        dropdown.snp.makeConstraints { make in
            make.width.equalTo(375 - Space.three * 2)
        }

        // Make some of the dropboxes have nil placeholders
        if let randomPlaceholder = Dropdown.placeholderOptions.randomElement() {
            dropdown.placeholder = randomPlaceholder
        }

        return dropdown
    }
}
