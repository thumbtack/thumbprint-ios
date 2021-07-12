@testable import Thumbprint
import XCTest

class RadioStackTest: SnapshotTestCase {
    func testOneLiner() {
        verify(
            viewFactory: {
                RadioStack(titles: ["Death", "Fate Worse than Death", "Drowned in a Tide of Madness"], adjustsFontForContentSizeCategory: true)
            },
            sizes: .allWithIntrinsicHeight
        )
    }

    func testMultiline() {
        verify(
            viewFactory: {
                let radioStack = RadioStack(titles: ["Death", "Fate Worse than Death", "Drowned in a Tide of Madness", "Digested during 1000 years by the Sarlacc while suffering the company of major doofus Bobba Fett"], adjustsFontForContentSizeCategory: true)
                radioStack.numberOfLines = 0
                return radioStack
            },
            sizes: .allWithIntrinsicHeight
        )
    }
}
