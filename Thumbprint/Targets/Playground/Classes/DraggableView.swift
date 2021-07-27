// import RxGesture
// import RxSwift
import UIKit

/// Helper extension to make UIViews draggable.
extension InspectableView where Self: UIView {
    func makeDraggable(in container: UIView) {
        rx.panGesture(configuration: { recognizer, _ in
            recognizer.cancelsTouchesInView = false
        })
            .when(.began, .changed, .ended)
            .subscribe(onNext: { [weak self] recognizer in
                guard let self = self else { return }

                let translation = recognizer.translation(in: container)

                self.snp.updateConstraints { make in
                    make.centerX.equalTo(self.center.x + translation.x)
                    make.centerY.equalTo(self.center.y + translation.y)
                }

                recognizer.setTranslation(.zero, in: container)
            })
            .disposed(by: disposeBag)

        rx.touchDownGesture(configuration: { recognizer, _ in
            recognizer.cancelsTouchesInView = false
        })
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }

                container.bringSubviewToFront(self)
            })
            .disposed(by: disposeBag)
    }
}
