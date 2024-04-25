import Thumbprint
import UIKit

/// A view to be displayed in the Playground Inspector for
/// configuring a single property.
class InspectablePropertyView: UIView {
    var property: InspectableProperty? {
        didSet {
            controlView = property?.controlView
            titleLabel.text = property?.title
        }
    }

    private let titleLabel: Label
    private var controlView: UIView? {
        didSet {
            oldValue?.removeFromSuperview()

            if let controlView {
                addSubview(controlView)
                controlView.snp.makeConstraints { make in
                    make.top.equalTo(titleLabel.snp.bottom).offset(Space.one)
                    make.leading.trailing.bottom.equalToSuperview()
                }
            }
        }
    }

    init() {
        self.titleLabel = Label(textStyle: .title4)

        super.init(frame: .null)

        titleLabel.adjustsFontSizeToFitWidth = true
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().priority(.low)
        }
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
