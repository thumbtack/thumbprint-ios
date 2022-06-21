import SnapKit
import UIKit

/// Helper extension to make UIViews draggable.
extension InspectableView where Self: UIView {
    func makeDraggable(in container: UIView) {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(recognizer:)))
        panGesture.cancelsTouchesInView = false
        addGestureRecognizer(panGesture)
    }
}

private extension UIView {
    @objc func handlePanGesture(recognizer: UIPanGestureRecognizer) {
        // Bring view to front
        if recognizer.state == .recognized {
            superview?.bringSubviewToFront(self)
        }

        // Drag view in superview
        guard let container = superview,
              recognizer.state == .began || recognizer.state == .changed || recognizer.state == .ended else {
            return
        }

        let translation = recognizer.translation(in: container)

        snp.updateConstraints { make in
            make.centerX.equalTo(self.center.x + translation.x)
            make.centerY.equalTo(self.center.y + translation.y)
        }

        recognizer.setTranslation(.zero, in: container)
    }
}
