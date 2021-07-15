import Combine
import UIKit

/**
 An object that manages a group of controls —usually radio buttons although any control that supports a proper selected state could work— where only one of
 them may be selected at a time.

 The class is generic meaning it can be instantiated with any type of key as long as it can be easily uniqued and compared, making translation of the selection
 to/from underlying model easier.

 Updates of the selected radio in the group can be subscribed to using the `selection` publisher property.
 */
public final class RadioGroup<Key> where Key: Hashable {
    /// Need to declare it to make it public.
    public init() {}

    /// Relates `Radio` objects to their corresponding key for user selection management.
    private var radioToKey = [Control: Key]()

    /// Relates a key to their radios.
    private var keyToRadio = [Key: Control]()

    /// Internal storage for the selected value and internal implementation for publisher behavior.
    private var selectionSubject = CurrentValueSubject<Key?, Never>(nil)

    /**
     Some times you want to access the `Radio` objects themselves i.e. for dynamic UI adjustments.

     If the language ever allows, we should return `some Collection where Element = Radio`
     */
    public var registeredRadios: [LabeledRadio] {
        radioToKey.keys.compactMap {
            $0 as? LabeledRadio
        }
    }

    /**
     The selection state is vended as a publisher. Subscribing to it will give you a first update with the value at the time of subscription, followed by update
     callbacks for any further changes.
     */
    public var selection: AnyPublisher<Key?, Never> {
        selectionSubject.eraseToAnyPublisher()
    }

    /**
     Sets the selection to the given key. Can be used to programmatically set the radio group's selection.
     - Parameter value: The new selected key. Pass in `nil` to empty the selection.
     */
    public func setSelection(_ value: Key?) {
        let outgoingSelection = selectionSubject.value
        guard value != outgoingSelection else {
            return
        }

        // Deselect prior selected radio.
        if let outgoingSelection = outgoingSelection {
            keyToRadio[outgoingSelection]?.isSelected = false
        }

        selectionSubject.value = value

        // Select newly selected radio.
        if let incomingSelection = value {
            guard let selectedRadio = keyToRadio[incomingSelection] else {
                assertionFailure("Cannot select a key that has not been registered with this group")
                return
            }
            selectedRadio.isSelected = true
        }
    }

    /**
     Registers a control (usually a `LabeledRadio`) for the given key.
     - Parameter control: The control that is to become part of the radio group. It must be the same one that sends an action when selected by the
     user (for example for a labeled control subtype send the `LabeledControl` instance instead of its `rootControl`). A control may only be associated
     with a single `RadioGroup` at a time and only once with a single key.
     - Parameter key: The key to associate with the control. When the control is tapped the given key will be selected, when the key is programmatically
     selected the control will be set to its selected state and all others in the radio group will be unselected. Must be unique for the group.
     */
    public func register(_ control: Control & SimpleControl, forKey key: Key) {
        assert(
            !radioToKey.keys.contains(control),
            "Attempted to register radio object \(control) with key \(key) already registered for key \(String(describing: radioToKey[control]))"
        )

        guard !keyToRadio.keys.contains(key) else {
            assertionFailure("Attempted to register key \(key) for radio \(control) already registered for radio \(String(describing: keyToRadio[key]))")
            return
        }

        control.set(target: self, action: #selector(selectRadio(_:)))
        radioToKey[control] = key
        keyToRadio[key] = control
    }

    @objc private func selectRadio(_ sender: Control) {
        guard let selectedKey = radioToKey[sender] else {
            assertionFailure("Attempted to select radio \(sender) not registered in radio group \(self)")
            return
        }

        setSelection(selectedKey)
    }
}
