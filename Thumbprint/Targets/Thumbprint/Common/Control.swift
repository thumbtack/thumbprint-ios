import UIKit

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
