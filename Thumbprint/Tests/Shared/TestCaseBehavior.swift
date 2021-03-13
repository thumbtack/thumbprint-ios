import Foundation
@testable import Thumbprint
import XCTest

private class ThumbprintResourcesBundleClass {}

public extension Bundle {
    static let thumbprint = Bundle(for: ThumbprintResourcesBundleClass.self)
}

class TestCaseBehavior {
    static func setUp() {
        NSTimeZone.default = TimeZone(abbreviation: "UTC")!
    }

    func tearDown(testCase: XCTestCase, ensureCleanProperties: Bool) {
        if ensureCleanProperties {
            ensureCleanTearDown(testCase)
        }
    }

    // MARK: - Private

    private func ensureCleanTearDown(_ testCase: XCTestCase) {
        // Instances of XCTestCase are not deallocated after the tests have completed, the instance
        // remains in memory for the duration of the test suite. Therefore we must manually nil out
        // references to objects that are no longer needed.
        let mirror = Mirror(reflecting: testCase)
        if let superclassMirror = mirror.superclassMirror {
            ensureClean(superclassMirror, testCase)
        }
        ensureClean(mirror, testCase) // The current test case
    }

    private func ensureClean(_ mirror: Mirror, _ testCase: XCTestCase) {
        for child in mirror.children {
            let valueMirror = Mirror(reflecting: child.value)
            let subjectType = String(describing: valueMirror.subjectType)
            let isOptional = subjectType.hasPrefix("ImplicitlyUnwrappedOptional") || subjectType.hasPrefix("Optional")

            if isOptional, !valueMirror.children.isEmpty {
                let childName = child.label ?? "Unknown"
                let msg = "\(testCase.name) did not nil out property '\(childName)' in tearDown()"
                XCTFail(msg)
            }
        }
    }
}
