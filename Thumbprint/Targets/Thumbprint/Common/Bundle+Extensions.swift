import Foundation

private class ThumbprintResourcesClass {}

public extension Bundle {
    static let thumbprint: Bundle = {
        let resourcesPath = Bundle(for: ThumbprintResourcesClass.self).path(forResource: "ThumbprintResources", ofType: "bundle")! // swiftlint:disable:this force_unwrapping
        return Bundle(path: resourcesPath)! // swiftlint:disable:this force_unwrapping
    }()
}
