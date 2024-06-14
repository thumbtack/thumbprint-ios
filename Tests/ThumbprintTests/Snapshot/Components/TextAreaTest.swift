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

    func testDefaultState() {
        verify()
    }

    func testDefaultStateWithText() {
        textArea.text = "This is a simple text that can cover multiple lines if the control is too small to fit everything on one line."
        verify()
    }

    // Disabled because hangs frequently under github actions
    // https://thumbtack.atlassian.net/browse/MINF-2392
    func testFirstResponderEmpty() {
        verify(setUp: {
            self.textArea.setNeedsLayout()
            self.textArea.layoutIfNeeded()
            self.textArea.becomeFirstResponder()
        })
    }

    // Disabled because hangs frequently under github actions
    // https://thumbtack.atlassian.net/browse/MINF-2392
    func testFirstResponderFilled() {
        textArea.text = "Test."

        verify {
            self.textArea.becomeFirstResponder()
        }
    }

    func testHighlightedEmpty() {
        textArea.isHighlighted = true

        verify()
    }

    func testHighlightedFilled() {
        textArea.isHighlighted = true
        textArea.text = "Come up with something buzzworthy time vampire. To be inspired is to become creative, innovative and energized we want this philosophy to trickle down to all our stakeholders shotgun approach."

        verify()
    }

    func testDisabledEmpty() {
        textArea.isEnabled = false

        verify()
    }

    func testDisabledFilled() {
        textArea.isEnabled = false
        textArea.text = "Blue money guerrilla marketing hard stop we need to future-proof this, nor criticality or low hanging fruit the last person we talked to said this would be ready."

        verify()
    }

    func testErrorEmpty() {
        textArea.hasError = true

        verify()
    }

    func testErrorFilled() {
        textArea.hasError = true
        textArea.text = "Alert! Alert!"

        verify()
    }

    func testErrorAndDisabled() {
        textArea.hasError = true
        textArea.isEnabled = false
        textArea.text = "This should appear disabled"

        verify()
    }

    func testErrorAndSelected() {
        textArea.hasError = true
        textArea.isSelected = true
        textArea.text = "This should appear as error"

        verify()
    }

    private func verify(file: StaticString = #filePath, line: UInt = #line, setUp: (() -> Void)? = nil) {
        verify(view: textArea,
               sizes: [.size(width: .defaultWidth, height: 400)],
               file: file,
               line: line,
               setUp: setUp)
    }
}
