import Thumbprint
import UIKit

/// Setup information for configuring a Bool property in the Playground Inspector.
class BoolInspectableProperty<T>: InspectableProperty {
    var inspectedView: T
    var property: WritableKeyPath<T, Bool>? {
        didSet {
            guard let property else { return }
            self.switch.isOn = inspectedView[keyPath: property]
        }
    }

    var title: String?

    var controlView: UIView {
        self.switch
    }

    private let `switch`: UISwitch

    init(inspectedView: T) {
        self.inspectedView = inspectedView
        self.switch = UISwitch()
        self.switch.addTarget(self, action: #selector(switchValueChanged(sender:)), for: .valueChanged)
    }

    @objc private func switchValueChanged(sender: AnyObject) {
        guard let property else { return }
        inspectedView[keyPath: property] = self.switch.isOn
    }
}
