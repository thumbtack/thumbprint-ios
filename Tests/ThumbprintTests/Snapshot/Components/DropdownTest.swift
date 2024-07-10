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

    @MainActor func testDefaultPlaceholder() {
        verify()
    }

    @MainActor func testCustomPlaceholder() {
        dropdown.placeholder = "Make a selection..."
        verify()
    }

    @MainActor func testHighlighted() {
        dropdown.isHighlighted = true
        verify()
    }

    @MainActor func testErroroneous() {
        dropdown.hasError = true
        verify()
    }

    @MainActor func testDisabled() {
        dropdown.isEnabled = false
        verify()
    }

    @MainActor func testSelect() {
        dropdown.selectedIndex = 0
        verify()
    }

    @MainActor private func verify() {
        let container = UIView()
        container.addSubview(dropdown)

        dropdown.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview().inset(Space.three)
        }

        verify(view: container, sizes: .all, contentSizeCategories: .all)
    }
}
