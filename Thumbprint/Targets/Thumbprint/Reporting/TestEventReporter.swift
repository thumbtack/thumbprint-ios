import Foundation

/**
 App event reporting should be covered by automated testing. Use this class to keep a record of app event reporting
 during a test and verify that the expected app events have been reported at various stages.

 Usage should be per test. Create an instance before the test runs (i.e. during `XCTestCase.setUp()`), add it to the set of app event
 reporters using `AppEvent.register(_:)` and store it for the test duration so its contents can be verified. At the
 end of the test (i.e. during `XCTestCase.tearDown()`) use `AppEvent.unregister(_:)` to remove the object and
 then dispose of it.
 - Note: TODO (Oscar) tackle multithreading considerations.
 */
public final class TestEventReporter {
    // Stores events reported during the object's lifetime. Public access for test verification purposes.
    public private(set) var events: [AppEvent] = []
}

extension TestEventReporter: AppEventReporter {
    public func report(_ event: AppEvent) {
        events.append(event)
    }
}
