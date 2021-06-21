@testable import Thumbprint
import XCTest

class LabelCheckboxTest: SnapshotTestCase {
    func testLabelCheckboxEmpty() {
        verifyLabelCheckbox { _ in
        }
    }

    func testLabelCheckboxEmptyDisabled() {
        verifyLabelCheckbox { labelCheckbox in
            labelCheckbox.isEnabled = false
        }
    }

    func testLabelCheckboxEmptyHighlighted() {
        verifyLabelCheckbox { labelCheckbox in
            labelCheckbox.isHighlighted = true
        }
    }

    func testLabelCheckboxEmptyError() {
        verifyLabelCheckbox { labelCheckbox in
            labelCheckbox.hasError = true
        }
    }

    func testLabelCheckboxEmptyLarge() {
        verifyLabelCheckbox { labelCheckbox in
            labelCheckbox.checkBoxSize = 80
        }
    }

    func testLabelCheckboxChecked() {
        verifyLabelCheckbox { labelCheckbox in
            labelCheckbox.isSelected = true
        }
    }

    func testLabelCheckboxCheckedDisabled() {
        verifyLabelCheckbox { labelCheckbox in
            labelCheckbox.isSelected = true
            labelCheckbox.isEnabled = false
        }
    }

    func testLabelCheckboxCheckedHighlighted() {
        verifyLabelCheckbox { labelCheckbox in
            labelCheckbox.isSelected = true
            labelCheckbox.isHighlighted = true
        }
    }

    func testLabelCheckboxCheckedError() {
        verifyLabelCheckbox { labelCheckbox in
            labelCheckbox.isSelected = true
            labelCheckbox.hasError = true
        }
    }

    func testLabelCheckboxCheckedLarge() {
        verifyLabelCheckbox { labelCheckbox in
            labelCheckbox.checkBoxSize = 80
            labelCheckbox.isSelected = true
        }
    }

    func testLabelCheckboxIntermediate() {
        verifyLabelCheckbox { labelCheckbox in
            labelCheckbox.mark = .intermediate
        }
    }

    func testLabelCheckboxIntermediateDisabled() {
        verifyLabelCheckbox { labelCheckbox in
            labelCheckbox.mark = .intermediate
            labelCheckbox.isEnabled = false
        }
    }

    func testLabelCheckboxIntermediateHighlighted() {
        verifyLabelCheckbox { labelCheckbox in
            labelCheckbox.mark = .intermediate
            labelCheckbox.isHighlighted = true
        }
    }

    func testLabelCheckboxIntermediateError() {
        verifyLabelCheckbox { labelCheckbox in
            labelCheckbox.mark = .intermediate
            labelCheckbox.hasError = true
        }
    }

    func testLabelCheckboxIntermediateLarge() {
        verifyLabelCheckbox { labelCheckbox in
            labelCheckbox.checkBoxSize = 80
            labelCheckbox.mark = .intermediate
        }
    }

    func testLabelCheckboxLeadingLabel() {
        verifyLabelCheckbox { labelCheckbox in
            labelCheckbox.labelPlacement = .leading
        }
    }

    func testLabelCheckboxContentInsets() {
        verifyLabelCheckbox { labelCheckbox in
            labelCheckbox.contentInsets = .init(top: 10, leading: 20, bottom: 30, trailing: 40)
        }
    }

    func testLabelCheckboxMultilineText() {
        verifyLabelCheckbox(limitedWidth: true) { labelCheckbox in
            labelCheckbox.numberOfLines = 0
            labelCheckbox.text = "This is a checkbox label text that will spread out over multiple lines because this text is too big to fit on one line"
        }
    }

    func testLabelCheckboxExtraSpaceLeading() {
        verifyLabelCheckbox(limitedWidth: true) { labelCheckbox in
            labelCheckbox.text = "Checkbox!"
            labelCheckbox.labelPlacement = .leading
        }
    }

    // MARK: - Private

    private func verifyLabelCheckbox(limitedWidth: Bool = false, configure: @escaping (LabelCheckbox) -> Void) {
        verify(
            viewFactory: {
                let labelCheckbox = LabelCheckbox(text: "This is a label checkbox", adjustsFontForContentSizeCategory: true)
                configure(labelCheckbox)
                return labelCheckbox
            },
            sizes: [limitedWidth ? .defaultWidthIntrinsicHeight : .intrinsic],
            verifyLayoutAmbiguity: false
        )
    }
}
