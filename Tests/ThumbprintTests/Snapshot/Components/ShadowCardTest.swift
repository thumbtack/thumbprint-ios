@testable import Thumbprint
import UIKit

class ShadowCardTest: SnapshotTestCase {
    func testWhiteBox() {
        let shadowCard = ShadowCard()
        verify(
            view: shadowCard,
            sizes: [.size(width: .defaultWidth, height: 300)],
            contentSizeCategories: [.unspecified]
        )
    }

    func testHighlighted() {
        let shadowCard = ShadowCard()
        shadowCard.isHighlighted = true
        verify(
            view: shadowCard,
            sizes: [.size(width: .defaultWidth, height: 300)],
            contentSizeCategories: [.unspecified]
        )
    }
}
