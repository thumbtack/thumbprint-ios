import UIKit

/**
 Thumbprint controls should always have a minimum tappable target size for ease of user interaction. All Thumbprint controls thus inherit from
 `Thumbprint.Control` which enforces a reasonably large tappable area no matter the actual control layout.
 */
open class Control: UIControl {
    public var minTapTargetSize: CGSize? = CGSize(width: 48, height: 48)

    public override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        guard let minTapTargetSize = minTapTargetSize else {
            return super.point(inside: point, with: event)
        }

        let tapTargetBounds = CGRect(
            x: min(0, (bounds.width - minTapTargetSize.width) / 2),
            y: min(0, (bounds.height - minTapTargetSize.height) / 2),
            width: max(bounds.width, minTapTargetSize.width),
            height: max(bounds.height, minTapTargetSize.height)
        )
        return tapTargetBounds.contains(point)
    }
}

/**
 A protocol for simple controls that just execute a single action upon user interaction (usually tapping).
 */
public protocol SimpleControl: Control {
    /// Performs the control's action. Call to programmatically cause the control's action to be run.
    func performAction()

    /**
     Sets control's action, we only really care about one even if UIKit allows us to configure several.

     This is a temporary property until we get `Thumbprint.Action` up and running. UIKit makes it too annoying to
     have a getter for a singular action but these controls semantics are that they only have one action they may
     perform.
     - Todo: (Oscar) Replace with `Thumbprint.Action`
     */
    func set(target: Any?, action: Selector)
}
