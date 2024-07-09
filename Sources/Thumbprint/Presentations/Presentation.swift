import UIKit

@MainActor
public enum Presentation {
    public static let partialSheet: UIViewControllerTransitioningDelegate = PartialSheetPresentation()
}
