import Thumbprint
import UIKit

extension LoaderDots: InspectableView {
    var inspectableProperties: [InspectableProperty] {
        let playAction = ButtionActionInspectableProperty(buttonTitle: "Play") {
            self.play()
        }

        let stopAction = ButtionActionInspectableProperty(buttonTitle: "Stop") {
            self.stop()
        }

        let hidesWhenPausedProperty = BoolInspectableProperty(inspectedView: self)
        hidesWhenPausedProperty.title = "Hide when paused?"
        hidesWhenPausedProperty.property = \LoaderDots.hidesOnStop

        let hideBorderProperty = BoolInspectableProperty(inspectedView: inspectableBorderView)
        hideBorderProperty.title = "Hide playground border?"
        hideBorderProperty.property = \InspectableBorderView.isHidden

        return [playAction, stopAction, hidesWhenPausedProperty, hideBorderProperty]
    }

    static func makeInspectable() -> UIView & InspectableView {
        let allThemes: [LoaderDots.Theme] = [.brand, .inverse, .muted]
        let allSizes: [LoaderDots.Size] = [.medium, .small]

        return LoaderDots(theme: allThemes.randomElement()!, size: allSizes.randomElement()!) // swiftlint:disable:this force_unwrapping
    }
}
