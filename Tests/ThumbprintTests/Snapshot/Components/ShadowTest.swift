@testable import Thumbprint
import UIKit

class ShadowTest: SnapshotTestCase {
    @MainActor func testRegularShadows() {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 24

        let shadows: [UIImage] = [
            Shadow.shadow100,
            Shadow.shadow200,
            Shadow.shadow300,
            Shadow.shadow400,
        ]

        for shadow in shadows {
            let view = UIView()
            stackView.addArrangedSubview(view)

            let subview = UIView()
            subview.backgroundColor = .white

            let imageView = UIImageView(image: shadow)

            view.addSubview(imageView)
            view.addSubview(subview)

            imageView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }

            subview.snp.makeConstraints { make in
                make.edges.equalToSuperview()
                make.size.equalTo(100)
            }
        }

        verify(view: stackView, contentSizeCategories: [.unspecified])
    }

    @MainActor func testRoundedShadows() {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 24

        let shadows: [UIImage] = [
            Shadow.roundedShadow100,
            Shadow.roundedShadow200,
            Shadow.roundedShadow300,
            Shadow.roundedShadow400,
        ]

        for shadow in shadows {
            let view = UIView()
            stackView.addArrangedSubview(view)

            let subview = UIView()
            subview.backgroundColor = .white
            subview.layer.cornerRadius = CornerRadius.base

            let imageView = UIImageView(image: shadow)

            view.addSubview(imageView)
            view.addSubview(subview)

            imageView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }

            subview.snp.makeConstraints { make in
                make.edges.equalToSuperview()
                make.size.equalTo(100)
            }
        }

        verify(view: stackView, contentSizeCategories: [.unspecified])
    }
}
