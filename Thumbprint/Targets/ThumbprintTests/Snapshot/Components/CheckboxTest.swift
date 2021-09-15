@testable import Thumbprint
import UIKit

class CheckboxTest: SnapshotTestCase {
    var checkbox: Checkbox!
    var labeledCheckbox: LabeledCheckbox!

    override func setUp() {
        super.setUp()

        checkbox = Checkbox()
        labeledCheckbox = LabeledCheckbox(text: "This is a label checkbox", adjustsFontForContentSizeCategory: true)
    }

    override func tearDown() {
        checkbox = nil
        labeledCheckbox = nil
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
        labeledCheckbox.isEnabled = false
        verifyLabelCheckbox()
    }

    func testLabelCheckboxEmptyHighlighted() {
        labeledCheckbox.isHighlighted = true
        verifyLabelCheckbox()
    }

    func testLabelCheckboxEmptyError() {
        labeledCheckbox.hasError = true
        verifyLabelCheckbox()
    }

    func testLabelCheckboxEmptyLarge() {
        labeledCheckbox.checkBoxSize = 80
        verifyLabelCheckbox()
    }

    func testLabelCheckboxChecked() {
        labeledCheckbox.isSelected = true
        verifyLabelCheckbox()
    }

    func testLabelCheckboxCheckedDisabled() {
        labeledCheckbox.isSelected = true
        labeledCheckbox.isEnabled = false
        verifyLabelCheckbox()
    }

    func testLabelCheckboxCheckedHighlighted() {
        labeledCheckbox.isSelected = true
        labeledCheckbox.isHighlighted = true
        verifyLabelCheckbox()
    }

    func testLabelCheckboxCheckedError() {
        labeledCheckbox.isSelected = true
        labeledCheckbox.hasError = true
        verifyLabelCheckbox()
    }

    func testLabelCheckboxCheckedLarge() {
        labeledCheckbox.checkBoxSize = 80
        labeledCheckbox.isSelected = true
        verifyLabelCheckbox()
    }

    func testLabelCheckboxIntermediate() {
        labeledCheckbox.mark = .intermediate
        verifyLabelCheckbox()
    }

    func testLabelCheckboxIntermediateDisabled() {
        labeledCheckbox.mark = .intermediate
        labeledCheckbox.isEnabled = false
        verifyLabelCheckbox()
    }

    func testLabelCheckboxIntermediateHighlighted() {
        labeledCheckbox.mark = .intermediate
        labeledCheckbox.isHighlighted = true
        verifyLabelCheckbox()
    }

    func testLabelCheckboxIntermediateError() {
        labeledCheckbox.mark = .intermediate
        labeledCheckbox.hasError = true
        verifyLabelCheckbox()
    }

    func testLabelCheckboxIntermediateLarge() {
        labeledCheckbox.checkBoxSize = 80
        labeledCheckbox.mark = .intermediate
        verifyLabelCheckbox()
    }

    func testLabelCheckboxContentLeft() {
        labeledCheckbox.contentPlacement = .left
        verifyLabelCheckbox()
    }

    func testLabelCheckboxContentInsets() {
        labeledCheckbox.contentInsets = UIEdgeInsets(top: 10, left: 20, bottom: 30, right: 40)
        verifyLabelCheckbox()
    }

    func testLabelCheckboxMultilineText() {
        labeledCheckbox.numberOfLines = 0
        labeledCheckbox.text = "This is a checkbox label text that will spread out over multiple lines because this text is too big to fit on one line"
        verifyLabelCheckbox(limitedWidth: true)
    }

    // MARK: - Private

    private func verifyCheckbox() {
        verify(view: checkbox, contentSizeCategories: [.large])
    }

    private func verifyLabelCheckbox(limitedWidth: Bool = false) {
        verify(
            view: labeledCheckbox,
            sizes: [limitedWidth ? .defaultWidthIntrinsicHeight : .intrinsic],
            verifyLayoutAmbiguity: false
        )
    }
}
