import Foundation

/**
 Encapsulates information about an event that happens during the app lifetime, usually for purposes of analytics event tracking.
 */
public struct AppEvent {
    /**
     Basic initializer.
     - Parameter identifier: The event identifier.
     - Parameter parameters: The event's parameters. Defaults to no parameters.
     */
    public init(_ identifier: Identifier, parameters: Parameters = [:]) {
        self.identifier = identifier
        self.parameters = parameters
    }

    // MARK: - Types

    /**
     Identifier for an app event.

     Identifiers should be declared as static instances of the type wherever appropriate.
     */
    public struct Identifier: RawRepresentable, Hashable {
        public init(rawValue: String) {
            self.rawValue = rawValue
        }

        public var rawValue: String
    }

    /**
     A key for an event's parameters dictionary. These should be as limited a set as possible so the same parameters
     always are stored in the same keys.

     Identifiers should be declared as static instances of the type wherever appropriate.
     */
    public struct ParameterKey: RawRepresentable, Hashable {
        public init(rawValue: String) {
            self.rawValue = rawValue
        }

        public var rawValue: String
    }

    /**
     Allowed value types for app event reporting parameters. They track JSON data types, with the addition of `Date` and `Bool` since
     they tend to get different custom treatments depending on internal API contracts.
     */
    public enum ParameterValue: Hashable {
        case boolean(Bool)
        case integer(Int)
        case floatingPoint(Double)
        case string(String)
        case date(Date)
        case array([ParameterValue])
        case dictionary([String: ParameterValue])
        case null
    }

    /**
     The type used for event parameter storage.
     */
    public typealias Parameters = [ParameterKey: ParameterValue]

    // MARK: - Properties

    /**
     The event identifier.
     */
    var identifier: Identifier

    /**
     Additional parameters for the event. What these are depends on the event and on the reporting requirements.
     */
    var parameters: Parameters
}

public extension AppEvent.Parameters {
    /**
     Alternate dictionary subscript to make it simpler to add parameter values to an event's parameter dictionary.
     - Warning: The getter will assert if there's a parameter value for the given key but it is not convertible to the expected type.
     As such it is not generally recommended to use this subscript getter without further validation.
     - Note: TODO (Oscar) investigate using a throwing property for the getter once Swift 6 is standard.
     */
    subscript<T>(_ key: Key) -> T? where T: ConvertibleToAppEventParameterValue {
        get {
            guard let value = self[key] else {
                // No actual value in the dictionary, ok to just return nil.
                return nil
            }

            guard let result = T(appEventParameterValue: value) else {
                // TODO: (Oscar) assert.
                return nil
            }

            return result
        }

        set {
            self[key] = newValue?.appEventParameterValue
        }
    }
}

/**
 A protocol for types to implement so they can easily be converted into app event parameter values and back.
 */
public protocol ConvertibleToAppEventParameterValue {
    /**
     Failable initializer to quickly convert from a `AppEvent.ParameterValue` enum to the convertible type.

     Implementations should only convert to directly related types, return nil otherwise. For example don't convert from
     `Integer` to a custom floating point type.
     - Parameter appEventParameterValue: The parameter value we'd like to try converting.
     - Note: TODO (Oscar) investigate using throwing initializers once Swift 6 is standard.
     */
    init?(appEventParameterValue: AppEvent.ParameterValue)

    /**
     Returns the calling value wrapped in a `AppEvent.ParameterValue` enum.
     */
    var appEventParameterValue: AppEvent.ParameterValue { get }
}

// MARK: - Common implementations of `ConvertibleToAppEventParameterValue`

extension Bool: ConvertibleToAppEventParameterValue {
    public init?(appEventParameterValue: AppEvent.ParameterValue) {
        if case let .boolean(boolean) = appEventParameterValue {
            self = boolean
        } else {
            return nil
        }
    }

    public var appEventParameterValue: AppEvent.ParameterValue {
        .boolean(self)
    }
}

extension Int: ConvertibleToAppEventParameterValue {
    public init?(appEventParameterValue: AppEvent.ParameterValue) {
        if case let .integer(integer) = appEventParameterValue {
            self = integer
        } else {
            return nil
        }
    }

    public var appEventParameterValue: AppEvent.ParameterValue {
        .integer(self)
    }
}

extension Double: ConvertibleToAppEventParameterValue {
    public init?(appEventParameterValue: AppEvent.ParameterValue) {
        if case let .floatingPoint(floatingPoint) = appEventParameterValue {
            self = floatingPoint
        } else {
            return nil
        }
    }

    public var appEventParameterValue: AppEvent.ParameterValue {
        .floatingPoint(self)
    }
}

extension Float: ConvertibleToAppEventParameterValue {
    public init?(appEventParameterValue: AppEvent.ParameterValue) {
        if case let .floatingPoint(floatingPoint) = appEventParameterValue {
            self = Float(floatingPoint)
        } else {
            return nil
        }
    }

    public var appEventParameterValue: AppEvent.ParameterValue {
        .floatingPoint(Double(self))
    }
}

extension String: ConvertibleToAppEventParameterValue {
    public init?(appEventParameterValue: AppEvent.ParameterValue) {
        if case let .string(string) = appEventParameterValue {
            self = string
        } else {
            return nil
        }
    }

    public var appEventParameterValue: AppEvent.ParameterValue {
        .string(self)
    }
}

extension Date: ConvertibleToAppEventParameterValue {
    public init?(appEventParameterValue: AppEvent.ParameterValue) {
        if case let .date(date) = appEventParameterValue {
            self = date
        } else {
            return nil
        }
    }

    public var appEventParameterValue: AppEvent.ParameterValue {
        .date(self)
    }
}

extension Array: ConvertibleToAppEventParameterValue where Element: ConvertibleToAppEventParameterValue {
    /**
     Note that the array initializer will silently drop elements if they are not of the expected type even if `appEventParameterValue` is
     indeed storing an array.
     */
    public init?(appEventParameterValue: AppEvent.ParameterValue) {
        if case let .array(array) = appEventParameterValue {
            self = array.compactMap { $0 as? Element }
        } else {
            return nil
        }
    }

    public var appEventParameterValue: AppEvent.ParameterValue {
        .array(map { element in
            element.appEventParameterValue
        })
    }
}

extension Dictionary: ConvertibleToAppEventParameterValue where Key == String, Value: ConvertibleToAppEventParameterValue {
    /**
     Note that the dictionary initializer will silently drop values if they are not of the expected type even if `appEventParameterValue` is
     indeed storing a dictionary.
     */
    public init?(appEventParameterValue: AppEvent.ParameterValue) {
        if case let .dictionary(dictionary) = appEventParameterValue {
            self = .init(uniqueKeysWithValues: dictionary.compactMap({ key, value in
                (value as? Value).map { value in
                    (key, value)
                }
            }))
        } else {
            return nil
        }
    }

    public var appEventParameterValue: AppEvent.ParameterValue {
        .dictionary(.init(uniqueKeysWithValues: map({ key, value in
            (key, value.appEventParameterValue)
        })))
    }
}
