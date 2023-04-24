import UIKit

open class CarouselLayout: UICollectionViewFlowLayout {
    public override init() {
        super.init()

        // Hardcoding scrollDirection's getter to return .horizontal does not
        // seem to be sufficient. Calling the setter once explicitly ensures
        // that the scroll direction does get set properly.
        scrollDirection = .horizontal

        minimumLineSpacing = Space.two
    }

    @available(*, unavailable)
    public required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Making this a left aligned, 1 row layout
    public override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let superAttributes = super.layoutAttributesForElements(in: rect),
              let attributes = NSArray(array: superAttributes, copyItems: true) as? [UICollectionViewLayoutAttributes]
        else { return nil }

        return attributes.map {
            if $0.representedElementKind == nil, let itemAttributes = layoutAttributesForItem(at: $0.indexPath) {
                return itemAttributes
            } else {
                return $0
            }
        }
    }

    public override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let superAttributes = super.layoutAttributesForItem(at: indexPath),
              let attributes = superAttributes.copy() as? UICollectionViewLayoutAttributes else {
            return nil
        }

        attributes.frame.origin.y = sectionInset.top // Force top-alignment
        return attributes
    }
}
