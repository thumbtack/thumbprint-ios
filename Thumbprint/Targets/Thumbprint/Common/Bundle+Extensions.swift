import Foundation

public extension Bundle {
    static let thumbprint: Bundle = {
        let resourcesPath = Bundle.main.path(forResource: "ThumbprintResources", ofType: "bundle")! // swiftlint:disable:this force_unwrapping
        return Bundle(path: resourcesPath)! // swiftlint:disable:this force_unwrapping
    }()
}
