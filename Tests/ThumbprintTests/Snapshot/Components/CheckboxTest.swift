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

    @MainActor func testCheckboxEmpty() {
        verifyCheckbox()
    }

    @MainActor func testCheckboxEmptyHighlighted() {
        checkbox.isHighlighted = true
        verifyCheckbox()
    }

    @MainActor func testCheckboxEmptyDisabled() {
        checkbox.isEnabled = false
        verifyCheckbox()
    }

    @MainActor func testCheckboxEmptyError() {
        checkbox.hasError = true
        verifyCheckbox()
    }

    @MainActor func testCheckboxEmptyLarge() {
        checkbox.checkBoxSize = 80
        verifyCheckbox()
    }

    @MainActor func testCheckboxChecked() {
        checkbox.isSelected = true
        verifyCheckbox()
    }

    @MainActor func testCheckboxCheckedHighlighted() {
        checkbox.isSelected = true
        checkbox.isHighlighted = true
        verifyCheckbox()
    }

    @MainActor func testCheckboxCheckedDisabled() {
        checkbox.isSelected = true
        checkbox.isEnabled = false
        verifyCheckbox()
    }

    @MainActor func testCheckboxCheckedError() {
        checkbox.isSelected = true
        checkbox.hasError = true
        verifyCheckbox()
    }

    @MainActor func testCheckboxCheckedLarge() {
        checkbox.checkBoxSize = 80
        checkbox.isSelected = true
        verifyCheckbox()
    }

    @MainActor func testCheckboxIntermediate() {
        checkbox.mark = .intermediate
        verifyCheckbox()
    }

    @MainActor func testCheckboxIntermediateDisabled() {
        checkbox.mark = .intermediate
        checkbox.isEnabled = false
        verifyCheckbox()
    }

    @MainActor func testCheckboxIntermediateHighlighted() {
        checkbox.mark = .intermediate
        checkbox.isHighlighted = true
        verifyCheckbox()
    }

    @MainActor func testCheckboxIntermediateError() {
        checkbox.mark = .intermediate
        checkbox.hasError = true
        verifyCheckbox()
    }

    @MainActor func testCheckboxIntermediateLarge() {
        checkbox.checkBoxSize = 80
        checkbox.mark = .intermediate
        verifyCheckbox()
    }

    // MARK: - LabelCheckbox

    @MainActor func testLabelCheckboxEmpty() {
        verifyLabelCheckbox()
    }

    @MainActor func testLabelCheckboxEmptyDisabled() {
        labeledCheckbox.isEnabled = false
        verifyLabelCheckbox()
    }

    @MainActor func testLabelCheckboxEmptyHighlighted() {
        labeledCheckbox.isHighlighted = true
        verifyLabelCheckbox()
    }

    @MainActor func testLabelCheckboxEmptyError() {
        labeledCheckbox.hasError = true
        verifyLabelCheckbox()
    }

    @MainActor func testLabelCheckboxEmptyLarge() {
        labeledCheckbox.checkBoxSize = 80
        verifyLabelCheckbox()
    }

    @MainActor func testLabelCheckboxChecked() {
        labeledCheckbox.isSelected = true
        verifyLabelCheckbox()
    }

    @MainActor func testLabelCheckboxCheckedDisabled() {
        labeledCheckbox.isSelected = true
        labeledCheckbox.isEnabled = false
        verifyLabelCheckbox()
    }

    @MainActor func testLabelCheckboxCheckedHighlighted() {
        labeledCheckbox.isSelected = true
        labeledCheckbox.isHighlighted = true
        verifyLabelCheckbox()
    }

    @MainActor func testLabelCheckboxCheckedError() {
        labeledCheckbox.isSelected = true
        labeledCheckbox.hasError = true
        verifyLabelCheckbox()
    }

    @MainActor func testLabelCheckboxCheckedLarge() {
        labeledCheckbox.checkBoxSize = 80
        labeledCheckbox.isSelected = true
        verifyLabelCheckbox()
    }

    @MainActor func testLabelCheckboxIntermediate() {
        labeledCheckbox.mark = .intermediate
        verifyLabelCheckbox()
    }

    @MainActor func testLabelCheckboxIntermediateDisabled() {
        labeledCheckbox.mark = .intermediate
        labeledCheckbox.isEnabled = false
        verifyLabelCheckbox()
    }

    @MainActor func testLabelCheckboxIntermediateHighlighted() {
        labeledCheckbox.mark = .intermediate
        labeledCheckbox.isHighlighted = true
        verifyLabelCheckbox()
    }

    @MainActor func testLabelCheckboxIntermediateError() {
        labeledCheckbox.mark = .intermediate
        labeledCheckbox.hasError = true
        verifyLabelCheckbox()
    }

    @MainActor func testLabelCheckboxIntermediateLarge() {
        labeledCheckbox.checkBoxSize = 80
        labeledCheckbox.mark = .intermediate
        verifyLabelCheckbox()
    }

    @MainActor func testLabelCheckboxContentLeft() {
        labeledCheckbox.contentPlacement = .left
        verifyLabelCheckbox()
    }

    @MainActor func testLabelCheckboxContentInsets() {
        labeledCheckbox.contentInsets = UIEdgeInsets(top: 10, left: 20, bottom: 30, right: 40)
        verifyLabelCheckbox()
    }

    @MainActor func testLabelCheckboxMultilineText() {
        labeledCheckbox.numberOfLines = 0
        labeledCheckbox.text = "This is a checkbox label text that will spread out over multiple lines because this text is too big to fit on one line"
        verifyLabelCheckbox(limitedWidth: true)
    }

    // MARK: - Private

    @MainActor private func verifyCheckbox() {
        verify(view: checkbox, contentSizeCategories: [.large])
    }

    @MainActor private func verifyLabelCheckbox(limitedWidth: Bool = false) {
        verify(
            view: labeledCheckbox,
            sizes: [limitedWidth ? .defaultWidthIntrinsicHeight : .intrinsic],
            verifyLayoutAmbiguity: false
        )
    }
}
