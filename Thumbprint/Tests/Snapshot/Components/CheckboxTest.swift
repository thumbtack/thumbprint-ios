@testable import Thumbprint
import UIKit

class CheckboxTest: SnapshotTestCase {
    var checkbox: Checkbox!
    var labelCheckbox: LabelCheckbox!

    override func setUp() {
        super.setUp()

        checkbox = Checkbox()
        labelCheckbox = LabelCheckbox(text: "This is a label checkbox", adjustsFontForContentSizeCategory: true)
    }

    override func tearDown() {
        checkbox = nil
        labelCheckbox = nil
        super.tearDown()
    }

    // MARK: - Checkbox

    func testCheckboxEmpty() {
        verifyCheckbox()
    }

    func testCheckboxEmptyHighlighted() {
        checkbox.isHighlighted = true
        verifyCheckbox()
    }

    func testCheckboxEmptyDisabled() {
        checkbox.isEnabled = false
        verifyCheckbox()
    }

    func testCheckboxEmptyError() {
        checkbox.hasError = true
        verifyCheckbox()
    }

    func testCheckboxEmptyLarge() {
        checkbox.checkBoxSize = 80
        verifyCheckbox()
    }

    func testCheckboxChecked() {
        checkbox.isSelected = true
        verifyCheckbox()
    }

    func testCheckboxCheckedHighlighted() {
        checkbox.isSelected = true
        checkbox.isHighlighted = true
        verifyCheckbox()
    }

    func testCheckboxCheckedDisabled() {
        checkbox.isSelected = true
        checkbox.isEnabled = false
        verifyCheckbox()
    }

    func testCheckboxCheckedError() {
        checkbox.isSelected = true
        checkbox.hasError = true
        verifyCheckbox()
    }

    func testCheckboxCheckedLarge() {
        checkbox.checkBoxSize = 80
        checkbox.isSelected = true
        verifyCheckbox()
    }

    func testCheckboxIntermediate() {
        checkbox.mark = .intermediate
        verifyCheckbox()
    }

    func testCheckboxIntermediateDisabled() {
        checkbox.mark = .intermediate
        checkbox.isEnabled = false
        verifyCheckbox()
    }

    func testCheckboxIntermediateHighlighted() {
        checkbox.mark = .intermediate
        checkbox.isHighlighted = true
        verifyCheckbox()
    }

    func testCheckboxIntermediateError() {
        checkbox.mark = .intermediate
        checkbox.hasError = true
        verifyCheckbox()
    }

    func testCheckboxIntermediateLarge() {
        checkbox.checkBoxSize = 80
        checkbox.mark = .intermediate
        verifyCheckbox()
    }

    // MARK: - LabelCheckbox

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

    private func verifyCheckbox() {
        verify(view: checkbox, contentSizeCategories: [.large])
    }

    private func verifyLabelCheckbox(limitedWidth: Bool = false) {
        verify(
            view: labelCheckbox,
            sizes: [limitedWidth ? .defaultWidthIntrinsicHeight : .intrinsic],
            verifyLayoutAmbiguity: false
        )
    }
}
