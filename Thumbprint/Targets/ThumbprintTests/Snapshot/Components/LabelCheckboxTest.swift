@testable import Thumbprint
import XCTest

class LabelCheckboxTest: SnapshotTestCase {
    var labelCheckbox: LabelCheckbox!

    override func setUpWithError() throws {
        try super.setUpWithError()

        labelCheckbox = LabelCheckbox(text: "This is a label checkbox", adjustsFontForContentSizeCategory: true)
    }

    override func tearDownWithError() throws {
        labelCheckbox = nil

        try super.tearDownWithError()
    }


    func testLabelCheckboxEmpty() {
        verifyLabelCheckbox()
    }

    func testLabelCheckboxEmptyDisabled() {
        labelCheckbox.isEnabled = false
        verifyLabelCheckbox()
    }

    func testLabelCheckboxEmptyHighlighted() {
        labelCheckbox.isHighlighted = true
        verifyLabelCheckbox()
    }

    func testLabelCheckboxEmptyError() {
        labelCheckbox.hasError = true
        verifyLabelCheckbox()
    }

    func testLabelCheckboxEmptyLarge() {
        labelCheckbox.checkBoxSize = 80
        verifyLabelCheckbox()
    }

    func testLabelCheckboxChecked() {
        labelCheckbox.isSelected = true
        verifyLabelCheckbox()
    }

    func testLabelCheckboxCheckedDisabled() {
        labelCheckbox.isSelected = true
        labelCheckbox.isEnabled = false
        verifyLabelCheckbox()
    }

    func testLabelCheckboxCheckedHighlighted() {
        labelCheckbox.isSelected = true
        labelCheckbox.isHighlighted = true
        verifyLabelCheckbox()
    }

    func testLabelCheckboxCheckedError() {
        labelCheckbox.isSelected = true
        labelCheckbox.hasError = true
        verifyLabelCheckbox()
    }

    func testLabelCheckboxCheckedLarge() {
        labelCheckbox.checkBoxSize = 80
        labelCheckbox.isSelected = true
        verifyLabelCheckbox()
    }

    func testLabelCheckboxIntermediate() {
        labelCheckbox.mark = .intermediate
        verifyLabelCheckbox()
    }

    func testLabelCheckboxIntermediateDisabled() {
        labelCheckbox.mark = .intermediate
        labelCheckbox.isEnabled = false
        verifyLabelCheckbox()
    }

    func testLabelCheckboxIntermediateHighlighted() {
        labelCheckbox.mark = .intermediate
        labelCheckbox.isHighlighted = true
        verifyLabelCheckbox()
    }

    func testLabelCheckboxIntermediateError() {
        labelCheckbox.mark = .intermediate
        labelCheckbox.hasError = true
        verifyLabelCheckbox()
    }

    func testLabelCheckboxIntermediateLarge() {
        labelCheckbox.checkBoxSize = 80
        labelCheckbox.mark = .intermediate
        verifyLabelCheckbox()
    }

    func testLabelCheckboxContentLeft() {
        labelCheckbox.contentPlacement = .left
        verifyLabelCheckbox()
    }

    func testLabelCheckboxContentInsets() {
        labelCheckbox.contentInsets = UIEdgeInsets(top: 10, left: 20, bottom: 30, right: 40)
        verifyLabelCheckbox()
    }

    func testLabelCheckboxMultilineText() {
        labelCheckbox.numberOfLines = 0
        labelCheckbox.text = "This is a checkbox label text that will spread out over multiple lines because this text is too big to fit on one line"
        verifyLabelCheckbox(limitedWidth: true)
    }

    // MARK: - Private

    private func verifyLabelCheckbox(limitedWidth: Bool = false) {
        verify(
            view: labelCheckbox,
            sizes: [limitedWidth ? .defaultWidthIntrinsicHeight : .intrinsic],
            verifyLayoutAmbiguity: false
        )
    }
}
