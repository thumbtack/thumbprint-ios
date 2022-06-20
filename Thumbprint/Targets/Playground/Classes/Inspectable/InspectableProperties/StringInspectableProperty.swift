import Thumbprint
import UIKit

/// Setup information for configuring an Optional<String> property in the Playground Inspector.
class StringInspectableProperty<T>: InspectableProperty {
    var inspectedView: T
    var property: WritableKeyPath<T, String?>? {
        didSet {
            guard let property = property else { return }
            textField.text = inspectedView[keyPath: property]
        }
    }

    var title: String?

    var controlView: UIView {
        textField
    }

    private let textField: TextInput

    init(inspectedView: T) {
        self.inspectedView = inspectedView
        self.textField = TextInput()
        textField.addTarget(self, action: #selector(textChanged(sender:)), for: .editingChanged)
    }

    @objc private func textChanged(sender: AnyObject) {
        guard let property = property else { return }
        inspectedView[keyPath: property] = textField.text
    }
}
