import Foundation

private class ThumbprintResourcesBundleClass {}

public extension Bundle {
    static let thumbprint = Bundle(for: ThumbprintResourcesBundleClass.self)
}
