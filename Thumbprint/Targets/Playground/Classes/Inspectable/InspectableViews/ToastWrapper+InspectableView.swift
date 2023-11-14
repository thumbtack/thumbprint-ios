import Thumbprint
import UIKit

extension Toast: InspectableView {
    var inspectableProperties: [InspectableProperty] {
        let messageProperty = StringInspectableProperty(inspectedView: self)
        messageProperty.title = "Message"
        messageProperty.property = \Toast.optionalMessage

        let actionNameProperty = StringInspectableProperty(inspectedView: self)
        actionNameProperty.title = "Action"
        actionNameProperty.property = \Toast.actionName

        let themeProperty = DropdownInspectableProperty(inspectedView: self, property: \Toast.theme, values: [
            (Toast.Theme.default(), "default"),
            (Toast.Theme.alert(), "alert"),
            (Toast.Theme.caution(), "caution"),
            (Toast.Theme.info(), "info"),
            (Toast.Theme.success(nil), "success (no icon)"), // The icon is simply not bundled with the playground app. It does have an icon by default
        ])
        themeProperty.title = "Theme"

        let showProperty = ButtionActionInspectableProperty(buttonTitle: "Show Toast") { [weak self] in
            self?.showToast()
        }

        let hideProperty = ButtionActionInspectableProperty(buttonTitle: "Hide Toast") { [weak self] in
            self?.hideToast()
        }

        return [messageProperty, actionNameProperty, themeProperty, showProperty, hideProperty]
    }

    static func makeInspectable() -> UIView & InspectableView {
        let toastWrapper = Toast(message: "Cheers!", theme: Toast.Theme.default(), action: Toast.Action(text: "Clink", handler: {}), presentationDuration: 2)
        toastWrapper.snp.makeConstraints { make in
            make.width.equalTo(UIScreen.main.bounds.width)
        }
        toastWrapper.showToast(animated: false)
        return toastWrapper
    }
}

extension Toast {
    var optionalMessage: String? {
        get {
            return message
        }
        set {
            message = newValue ?? ""
        }
    }

    var actionName: String? {
        get {
            return action?.text
        }
        set {
            action = Toast.Action(text: newValue ?? "", handler: {})
        }
    }
}
