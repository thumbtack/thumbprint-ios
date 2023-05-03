import Foundation

private class TestingBundleClass {}

public extension Bundle {
    static let testing = Bundle(for: TestingBundleClass.self)
}
