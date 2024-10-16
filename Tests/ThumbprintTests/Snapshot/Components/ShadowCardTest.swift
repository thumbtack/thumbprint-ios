@testable import Thumbprint
import UIKit

class ShadowCardTest: SnapshotTestCase {
    @MainActor func testWhiteBox() {
        let shadowCard = ShadowCard()
        verify(
            view: shadowCard,
            sizes: [.size(width: .defaultWidth, height: 300)],
            contentSizeCategories: [.unspecified]
        )
    }

    @MainActor func testHighlighted() {
        let shadowCard = ShadowCard()
        shadowCard.isHighlighted = true
        verify(
            view: shadowCard,
            sizes: [.size(width: .defaultWidth, height: 300)],
            contentSizeCategories: [.unspecified]
        )
    }
}
