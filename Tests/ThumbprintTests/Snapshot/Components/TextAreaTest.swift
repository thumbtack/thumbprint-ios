@testable import Thumbprint
import UIKit

class TextAreaTest: SnapshotTestCase {
    var textArea: TextArea!

    override func setUp() {
        super.setUp()
        textArea = TextArea()
        textArea.placeholder = "Type something..."
    }

    override func tearDown() {
        textArea = nil
        super.tearDown()
    }

    @MainActor func testDefaultState() {
        verify()
    }

    @MainActor func testDefaultStateWithText() {
        textArea.text = "This is a simple text that can cover multiple lines if the control is too small to fit everything on one line."
        verify()
    }

    // Disabled because hangs frequently under github actions
    // https://thumbtack.atlassian.net/browse/MINF-2392
    @MainActor func testFirstResponderEmpty() {
        verify {
            self.textArea.becomeFirstResponder()
        }
    }

    // Disabled because hangs frequently under github actions
    // https://thumbtack.atlassian.net/browse/MINF-2392
    @MainActor func testFirstResponderFilled() {
        textArea.text = "Test."

        verify {
            self.textArea.becomeFirstResponder()
        }
    }

    @MainActor func testHighlightedEmpty() {
        textArea.isHighlighted = true

        verify()
    }

    @MainActor func testHighlightedFilled() {
        textArea.isHighlighted = true
        textArea.text = "Come up with something buzzworthy time vampire. To be inspired is to become creative, innovative and energized we want this philosophy to trickle down to all our stakeholders shotgun approach."

        verify()
    }

    @MainActor func testDisabledEmpty() {
        textArea.isEnabled = false

        verify()
    }

    @MainActor func testDisabledFilled() {
        textArea.isEnabled = false
        textArea.text = "Blue money guerrilla marketing hard stop we need to future-proof this, nor criticality or low hanging fruit the last person we talked to said this would be ready."

        verify()
    }

    @MainActor func testErrorEmpty() {
        textArea.hasError = true

        verify()
    }

    @MainActor func testErrorFilled() {
        textArea.hasError = true
        textArea.text = "Alert! Alert!"

        verify()
    }

    @MainActor func testErrorAndDisabled() {
        textArea.hasError = true
        textArea.isEnabled = false
        textArea.text = "This should appear disabled"

        verify()
    }

    @MainActor func testErrorAndSelected() {
        textArea.hasError = true
        textArea.isSelected = true
        textArea.text = "This should appear as error"

        verify()
    }

    @MainActor private func verify(file: StaticString = #filePath, line: UInt = #line, setUp: (() -> Void)? = nil) {
        verify(view: textArea,
               sizes: [.size(width: .defaultWidth, height: 400)],
               file: file,
               line: line,
               setUp: setUp)
    }
}
