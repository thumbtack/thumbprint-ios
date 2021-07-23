import RxCocoa
import RxSwift
import Thumbprint
import UIKit

class ButtionActionInspectableProperty: InspectableProperty {
    var title: String?
    var controlView: UIView {
        button
    }

    private var button: Button
    private let disposeBag = DisposeBag()

    init(buttonTitle: String, buttonAction: @escaping () -> Void) {
        let buttonSize = Button.Size(textStyle: .title6, contentPadding: .init(width: 12.0, height: 8.0))
        button = Button(theme: .primary, size: buttonSize)
        button.title = buttonTitle

        button.rx.controlEvent([.touchUpInside]).asDriver().drive(onNext: {
            buttonAction()
        }).disposed(by: disposeBag)
    }
}
