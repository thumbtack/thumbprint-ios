import UIKit

open class CarouselLayout: UICollectionViewFlowLayout {
    override open var minimumLineSpacing: CGFloat {
        get {
            Space.two
        }
        set {
            assertionFailure("minimumLineSpacing setter is a no-op")
        }
    }

    public override init() {
        super.init()

        // Hardcoding scrollDirection's getter to return .horizontal does not
        // seem to be sufficient. Calling the setter once explicitly ensures
        // that the scroll direction does get set properly.
        super.scrollDirection = .horizontal
    }

    @available(*, unavailable)
    public required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Making this a left aligned, 1 row layout
    public override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        super.layoutAttributesForElements(in: rect)?.map {
            if $0.representedElementKind == nil, let itemAttributes = layoutAttributesForItem(at: $0.indexPath) {
                return itemAttributes
            } else {
                return $0
            }
        }
    }

    public override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let currentItemAttributes = super.layoutAttributesForItem(at: indexPath) else {
            return nil
        }

        // Force top-alignment
        currentItemAttributes.frame.origin.y = sectionInset.top
        return currentItemAttributes
    }
}
