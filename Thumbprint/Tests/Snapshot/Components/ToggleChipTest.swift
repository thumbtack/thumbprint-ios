import Thumbprint
import UIKit

class ToggleChipTest: SnapshotTestCase {
    private var toggleChip: ToggleChip!

    override func setUp() {
        super.setUp()
        toggleChip = ToggleChip()
        toggleChip.text = "ToggleChip"
    }

    override func tearDown() {
        toggleChip = nil
        super.tearDown()
    }

    private func verifyChip(selected: Bool, highlighted: Bool) {
        toggleChip.isSelected = selected
        toggleChip.isHighlighted = highlighted

        verify(view: toggleChip)
    }

    func testDefault() {
        verifyChip(selected: false, highlighted: false)
    }

    func testDefaultHighlighted() {
        verifyChip(selected: false, highlighted: true)
    }

    func testSelected() {
        verifyChip(selected: true, highlighted: false)
    }

    func testSelectedHighlighted() {
        verifyChip(selected: true, highlighted: true)
    }

    /**
     Use this to produce the image to show in the Thumprint iOS Chip documentation
     */
    func testDocumentation() {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = Space.two
        stackView.alignment = .leading

        toggleChip.text = "Chip"
        stackView.addArrangedSubview(toggleChip)

        let selectedChip = ToggleChip()
        selectedChip.text = "Chip"
        selectedChip.isSelected = true
        stackView.addArrangedSubview(selectedChip)

        verify(view: stackView, contentSizeCategories: [.unspecified])
    }
}
