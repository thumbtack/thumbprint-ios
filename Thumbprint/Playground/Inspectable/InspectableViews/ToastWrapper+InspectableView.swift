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

        let showProperty = ButtionActionInspectableProperty(buttonTitle: "Show Toast") { [weak self] in
            self?.showToast()
        }

        let hideProperty = ButtionActionInspectableProperty(buttonTitle: "Hide Toast") { [weak self] in
            self?.hideToast()
        }

        return [messageProperty, actionNameProperty, showProperty, hideProperty]
    }

    static func makeInspectable() -> UIView & InspectableView {
        let toastWrapper = Toast(message: "Cheers!", action: Toast.Action(text: "Clink", handler: {}), presentationDuration: 2)
        toastWrapper.snp.makeConstraints { make in
            make.width.equalTo(UIScreen.main.bounds.width)
        }
        toastWrapper.showToast(animated: false)
        return toastWrapper
    }
}

internal extension Toast {
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
