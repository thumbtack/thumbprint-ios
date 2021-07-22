import Thumbprint
import UIKit

extension ShadowCard: InspectableView {
    var inspectableProperties: [InspectableProperty] {
        []
    }

    static func makeInspectable() -> UIView & InspectableView {
        let shadowCard = ShadowCard()
        shadowCard.snp.makeConstraints { make in
            make.width.equalTo(200)
            make.height.equalTo(100)
        }

        let titleLabel = Label(textStyle: .title1, adjustsFontForContentSizeCategory: false)
        titleLabel.text = "Hello there!"
        shadowCard.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

        return shadowCard
    }
}
