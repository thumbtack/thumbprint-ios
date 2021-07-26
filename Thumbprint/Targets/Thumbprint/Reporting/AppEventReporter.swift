import Foundation

/**
 Wrapper for app event reporting objects.

 Thumbprint doesn't establish any dependency on any app event reporting API, but since integrating app event
 reporting into its components can make the process far more consistent and reliable we allow for easy integration
 with existing APIs.

 Implementers must be objects as the app event reporter registry stores them by object identity.

 The steps to follow for integration are the following:
 - Create a class that wraps a given app event reporting API by implementing this protocol.
 - Add an instance of it to the set of app event reporters by using `AppEvent.add(<instance>)`
 - There is no step three.
 */
public protocol AppEventReporter: AnyObject {
    /**
     Reports an event with the given parameters and environment.
     - Important: Implementations should have no side effects, and should know to disable themselves in the right
     runtime environment if warranted (i.e. debug, testing etc.).
     - Parameter event: The app event.
     */
    func report(_ event: AppEvent)
}

/**
 Management of global event reporting.
 - Note: TODO (Oscar) tackle multithreading considerations.
 */
public extension AppEvent {
    /**
     Reports the given event using the global event reporter.
     - Parameter event: The event we want reported.
     */
    static func report(_ event: AppEvent) {
        GroupedAppEventReporter.singleton.report(event)
    }

    /**
     Reports the given event. Convenience method to avoid having to build an AppEvent on the fly.
     */
    static func report(_ identifier: AppEvent.Identifier, environment: [AppEvent.EnvironmentElement], parameters: [AppEvent.ParameterKey: AppEvent.ParameterValue]) {
        report(.init(identifier, environment: environment, parameters: parameters))
    }

    /**
     Pushes an event reporter on top of the stack. After this call further event reporting will also be reported
     on `eventReported`. If the same event reporter is accidentally registered more than once subsequent attempts
     will just do nothing.
     - Parameter eventReporter: An event reporter that we want to add to the set of event reporters that get
     sent events when globally reported.

         There's no guarantee `eventReporter` will be called before or after any other registered event
     reporters,
     */
    static func add(_ eventReporter: AppEventReporter) {
        GroupedAppEventReporter.singleton.add(eventReporter)
    }

    /**
     Removes the given event reporter from the global set. If the given event reporter has not been previously
     registered nothing happens.
     - Parameter eventReporter: An event reporter that we don't want receiving global app reported events any longer.

     */
    static func remove(_ eventReporter: AppEventReporter) {
        GroupedAppEventReporter.singleton.remove(eventReporter)
    }
}

/**
 A private implementation of AppEventReporter for use to implement app global event reporting by keeping track of
 registered event reporters and broadcasting event reports to them.

 A singleton instance of it is used for most standard event reporting.
 */
private final class GroupedAppEventReporter {
    init() {
        #if DEBUG
            add(DebugEventReporter())
        #endif
    }

    static let singleton = GroupedAppEventReporter()

    private var registeredEventReporters: [ObjectIdentifier: AppEventReporter] = [:]

    func add(_ eventReporter: AppEventReporter) {
        registeredEventReporters[.init(eventReporter)] = eventReporter
    }

    func remove(_ eventReporter: AppEventReporter) {
        registeredEventReporters.removeValue(forKey: .init(eventReporter))
    }
}

extension GroupedAppEventReporter: AppEventReporter {
    func report(_ event: AppEvent) {
        for eventReporter in registeredEventReporters.values {
            eventReporter.report(event)
        }
    }
}

/**
 Standard debug event reporter. Always registered in Debug builds, ensuring that event reporting is logged
 where the developer can see it.
 */
private final class DebugEventReporter: AppEventReporter {
    func report(_ event: AppEvent) {
        print("*** Reported Event with identifier “\(event.identifier)”")
        print("- Environment: \(event.environment)")
        print("- Parameters: \(event.parameters)")
    }
}
