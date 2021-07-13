@testable import Thumbprint
import XCTest

class LabeledCheckboxTest: SnapshotTestCase {
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

    func testLabelCheckboxIntermediateLarge() {
        verifyLabelCheckbox { labelCheckbox in
            labelCheckbox.checkBoxSize = 80
            labelCheckbox.mark = .intermediate
        }
    }

    func testLabelCheckboxLeadingLabel() {
        verifyLabelCheckbox { labelCheckbox in
            labelCheckbox.contentPlacement = .leading
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
            labelCheckbox.contentPlacement = .leading
        }
    }

    func testMultilabel() {
        verify(
            viewFactory: {
                let contents = MockMultilabel()
                let labelCheckbox = LabeledCheckbox(label: contents.titleLabel, content: contents)
                return labelCheckbox
            },
            sizes: [.defaultWidthIntrinsicHeight],
            verifyLayoutAmbiguity: false
        )
    }

    func testMultilabelLeading() {
        verify(
            viewFactory: {
                let contents = MockMultilabel()
                let labelCheckbox = LabeledCheckbox(label: contents.titleLabel, content: contents)
                labelCheckbox.contentPlacement = .leading
                return labelCheckbox
            },
            sizes: [.defaultWidthIntrinsicHeight],
            verifyLayoutAmbiguity: false
        )
    }

    // MARK: - Private

    private func verifyLabelCheckbox(limitedWidth: Bool = false, configure: @escaping (LabeledCheckbox) -> Void) {
        verify(
            viewFactory: {
                let labelCheckbox = LabeledCheckbox(text: "This is a label checkbox", adjustsFontForContentSizeCategory: true)
                configure(labelCheckbox)
                return labelCheckbox
            },
            sizes: [limitedWidth ? .defaultWidthIntrinsicHeight : .intrinsic],
            verifyLayoutAmbiguity: false
        )
    }
}
