import Foundation

public extension Bundle {
    static let thumbprint: Bundle = {
        let resourcesPath = Bundle.main.path(forResource: "ThumbprintResources", ofType: "bundle")!
        return Bundle(path: resourcesPath)!
    }()
}
