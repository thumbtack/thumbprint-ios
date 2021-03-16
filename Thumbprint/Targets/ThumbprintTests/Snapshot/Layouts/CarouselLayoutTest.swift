@testable import Thumbprint
import UIKit

class CarouselLayoutTest: SnapshotTestCase {
    func testLayout() {
        let carouselLayout = CarouselLayout()
        carouselLayout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 0, right: 0)
        carouselLayout.itemSize = CGSize(width: 100, height: 150)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: carouselLayout)
        collectionView.register(CarouselTestCell.self, forCellWithReuseIdentifier: "CarouselTest")
        collectionView.dataSource = self

        verify(
            view: collectionView,
            sizes: [.size(width: .defaultWidth, height: 200)],
            contentSizeCategories: [.unspecified]
        )
    }
}

private class CarouselTestCell: UICollectionViewCell {}

extension CarouselLayoutTest: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        4
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CarouselTest", for: indexPath)
        switch indexPath.item {
        case 0:
            cell.contentView.backgroundColor = Color.blue
        case 1:
            cell.contentView.backgroundColor = Color.red
        case 2:
            cell.contentView.backgroundColor = Color.green
        default:
            cell.contentView.backgroundColor = Color.gray
        }
        return cell
    }
}
