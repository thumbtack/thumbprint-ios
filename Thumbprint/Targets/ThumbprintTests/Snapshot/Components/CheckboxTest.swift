@testable import Thumbprint
import UIKit

class CheckboxTest: SnapshotTestCase {
    var checkbox: Checkbox!

    override func setUp() {
        super.setUp()

        checkbox = Checkbox()
    }

    override func tearDown() {
        checkbox = nil
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

    func testCheckboxIntermediateLarge() {
        checkbox.checkBoxSize = 80
        checkbox.mark = .intermediate
        verifyCheckbox()
    }

    // MARK: - Private

    private func verifyCheckbox() {
        verify(view: checkbox, contentSizeCategories: [.large])
    }
}
