import Thumbprint
import UIKit

class FilterChipTest: SnapshotTestCase {
    private var filterChip: FilterChip!

    override func setUp() {
        super.setUp()
        filterChip = FilterChip()
        filterChip.text = "FilterChip"
    }

    override func tearDown() {
        filterChip = nil
        super.tearDown()
    }

    private func verifyChip(selected: Bool, highlighted: Bool) {
        filterChip.isSelected = selected
        filterChip.isHighlighted = highlighted

        verify(view: filterChip)
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

        filterChip.text = "Chip"
        stackView.addArrangedSubview(filterChip)

        let selectedChip = FilterChip()
        selectedChip.text = "Chip"
        selectedChip.isSelected = true
        stackView.addArrangedSubview(selectedChip)

        verify(view: stackView, contentSizeCategories: [.unspecified])
    }
}
