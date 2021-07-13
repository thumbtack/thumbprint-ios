@testable import Thumbprint
import XCTest

class LabeledRadioTest: SnapshotTestCase {
    func testLabeledRadioNotSelected() {
        verifyLabeledRadio { _ in
        }
    }

    func testLabeledRadioEmptyDisabled() {
        verifyLabeledRadio { labeledRadio in
            labeledRadio.isEnabled = false
        }
    }

    func testLabeledRadioEmptyHighlighted() {
        verifyLabeledRadio { labeledRadio in
            labeledRadio.isHighlighted = true
        }
    }

    func testLabeledRadioChecked() {
        verifyLabeledRadio { labeledRadio in
            labeledRadio.isSelected = true
        }
    }

    func testLabeledRadioCheckedDisabled() {
        verifyLabeledRadio { labeledRadio in
            labeledRadio.isSelected = true
            labeledRadio.isEnabled = false
        }
    }

    func testLabeledRadioCheckedHighlighted() {
        verifyLabeledRadio { labeledRadio in
            labeledRadio.isSelected = true
            labeledRadio.isHighlighted = true
        }
    }

    func testLabeledRadioLeadingLabel() {
        verifyLabeledRadio { labeledRadio in
            labeledRadio.contentPlacement = .leading
        }
    }

    func testLabeledRadioContentInsets() {
        verifyLabeledRadio { labeledRadio in
            labeledRadio.contentInsets = .init(top: 10, leading: 20, bottom: 30, trailing: 40)
        }
    }

    func testLabeledRadioMultilineText() {
        verifyLabeledRadio(limitedWidth: true) { labeledRadio in
            labeledRadio.numberOfLines = 0
            labeledRadio.text = "This is labeled radio text that will spread out over multiple lines because this text is too big to fit on one line"
        }
    }

    func testLabeledRadioExtraSpaceLeading() {
        verifyLabeledRadio(limitedWidth: true) { labeledRadio in
            labeledRadio.text = "Radio!"
            labeledRadio.contentPlacement = .leading
        }
    }

    func testMultilabel() {
        verify(
            viewFactory: {
                let contents = MockMultilabel()
                let radioCheckbox = LabeledRadio(label: contents.titleLabel, content: contents)
                return radioCheckbox
            },
            sizes: [.defaultWidthIntrinsicHeight],
            verifyLayoutAmbiguity: false
        )
    }

    func testMultilabelLeading() {
        verify(
            viewFactory: {
                let contents = MockMultilabel()
                let radioCheckbox = LabeledRadio(label: contents.titleLabel, content: contents)
                radioCheckbox.contentPlacement = .leading
                return radioCheckbox
            },
            sizes: [.defaultWidthIntrinsicHeight],
            verifyLayoutAmbiguity: false
        )
    }

    // MARK: - Private

    private func verifyLabeledRadio(limitedWidth: Bool = false, configure: @escaping (LabeledRadio) -> Void) {
        verify(
            viewFactory: {
                let labeledRadio = LabeledRadio(text: "This is a labeled radio", adjustsFontForContentSizeCategory: true)
                configure(labeledRadio)
                return labeledRadio
            },
            sizes: [limitedWidth ? .defaultWidthIntrinsicHeight : .intrinsic],
            verifyLayoutAmbiguity: false
        )
    }
}
