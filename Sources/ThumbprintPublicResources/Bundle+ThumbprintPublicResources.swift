import Foundation

private class ThumbprintPublicResourcesBundleClass {}

public extension Bundle {
    static let thumbprintPublic = Bundle(for: ThumbprintPublicResourcesBundleClass.self)
}
