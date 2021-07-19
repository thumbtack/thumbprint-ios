@testable import Thumbprint
import UIKit

class DropdownTest: SnapshotTestCase {
    var dropdown: Dropdown!

    override func setUp() {
        super.setUp()

        dropdown = Dropdown(optionTitles: [
            "Thing 1",
            "Thing 2",
            "The Cat in the Hat Knows a Lot About That!",
        ])
    }

    override func tearDown() {
        dropdown = nil
        super.tearDown()
    }

    func testDefaultPlaceholder() {
        verify()
    }

    func testCustomPlaceholder() {
        dropdown.placeholder = "Make a selection..."
        verify()
    }

    func testHighlighted() {
        dropdown.isHighlighted = true
        verify()
    }

    func testErroroneous() {
        dropdown.hasError = true
        verify()
    }

    func testDisabled() {
        dropdown.isEnabled = false
        verify()
    }

    func testSelect() {
        dropdown.selectedIndex = 0
        verify()
    }

    private func verify() {
        let container = UIView()
        container.addManagedSubview(dropdown)
        dropdown.snapToSuperviewEdges([.top, .leading, .trailing], inset: Space.three)

        verify(view: container, sizes: .all, contentSizeCategories: .all)
    }
}
