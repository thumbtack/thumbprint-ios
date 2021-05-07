import Combine
import UIKit

/**
 An object that manages a group of radio buttons and its selection. The class is generic meaning it can be instantiated with any type of key as long as it
 can be easily uniqued and compared. Updates of the selected radio in the group can be subscribed to using the `selection` publisher property.
 */
public final class RadioGroup<Key> where Key: Hashable {
    /// Need to declare it to make it public.
    public init() {}

    /// Relates `Radio` objects to their corresponding key for user selection management.
    private var radioToKey = [Radio: Key]()

    /// Relates a key to their radios.
    private var keyToRadio = [Key: Radio]()

    /// Internal storage for the selected value and internal implementation for publisher behavior.
    private var selectionSubject = CurrentValueSubject<Key?, Never>(nil)

    /**
     Some times you want to access the `Radio` objects themselves i.e. for dynamic UI adjustments.

     If the language ever allows, we should return `some Collection where Element = Radio`
     */
    public var registeredRadios: AnyCollection<Radio> {
        AnyCollection(radioToKey.keys)
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
     Registers a `Radio` view for the given key.

     The function will assert when attempting to register the same radio more than once or registering an already registered key.
     - Parameter radio: The `Radio` view associated in the UI with the given key.
     - Parameter key: The key to be associated with the given radio.
     */
    public func registerRadio(_ radio: Radio, forKey key: Key) {
        assert(
            !radioToKey.keys.contains(radio),
            "Attempted to register radio object \(radio) with key \(key) already registered for key \(String(describing: radioToKey[radio]))"
        )

        guard !keyToRadio.keys.contains(key) else {
            assertionFailure("Attempted to register key \(key) for radio \(radio) already registered for radio \(String(describing: keyToRadio[key]))")
            return
        }

        radio.addTarget(self, action: #selector(selectRadio(_:)), for: .valueChanged)
        radioToKey[radio] = key
        keyToRadio[key] = radio
    }

    @objc private func selectRadio(_ sender: Radio) {
        guard let selectedKey = radioToKey[sender] else {
            assertionFailure("Attempted to select radio \(sender) not registered in radio group \(self)")
            return
        }

        guard sender.isSelected else {
            return
        }

        setSelection(selectedKey)
    }
}
