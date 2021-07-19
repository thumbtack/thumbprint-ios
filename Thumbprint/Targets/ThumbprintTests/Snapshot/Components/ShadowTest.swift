@testable import Thumbprint
import UIKit

class ShadowTest: SnapshotTestCase {
    func testRegularShadows() {
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

            view.addManagedSubview(imageView)
            view.addManagedSubview(subview)

            imageView.snapToSuperviewEdges(.all)
            subview.snapToSuperviewEdges(.all)
            subview.heightAnchor.constraint(equalToConstant: 100.0).isActive = true
            subview.widthAnchor.constraint(equalToConstant: 100.0).isActive = true
        }

        verify(view: stackView, contentSizeCategories: [.unspecified])
    }

    func testRoundedShadows() {
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

            view.addManagedSubview(imageView)
            view.addManagedSubview(subview)

            imageView.snapToSuperviewEdges(.all)
            subview.snapToSuperviewEdges(.all)
            subview.heightAnchor.constraint(equalToConstant: 100.0).isActive = true
            subview.widthAnchor.constraint(equalToConstant: 100.0).isActive = true
        }

        verify(view: stackView, contentSizeCategories: [.unspecified])
    }
}
