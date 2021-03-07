import UIKit

public extension UIViewController {
    var partialSheetPresentationController: PartialSheetPresentationController? {
        presentationController as? PartialSheetPresentationController
    }
}
