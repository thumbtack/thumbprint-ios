@testable import Thumbprint
import UIKit
import XCTest

class TextInputTest: SnapshotTestCase {
    var textInput: TextInput!

    override func setUp() {
        super.setUp()

        textInput = TextInput()
        textInput.placeholder = "Type something..."
        textInput.hidesCaret = true
    }

    override func tearDown() {
        textInput = nil
        super.tearDown()
    }

    func testDefaultState() {
        verify()
    }

    func testSelectedEmpty() {
        textInput.isSelected = true

        verify()
    }

    func testSelectedFilled() {
        textInput.isSelected = true
        textInput.text = "Me first!"

        verify()
    }

    func testHighlightedEmpty() {
        textInput.isHighlighted = true

        verify()
    }

    func testHighlightedFilled() {
        textInput.isHighlighted = true
        textInput.text = "I am so highlighted right now"

        verify()
    }

    func testDisabledEmpty() {
        textInput.isEnabled = false

        verify()
    }

    func testDisabledFilled() {
        textInput.isEnabled = false
        textInput.text = "When I was your age..."

        verify()
    }

    func testErrorEmpty() {
        textInput.hasError = true

        verify()
    }

    func testErrorFilled() {
        textInput.hasError = true
        textInput.text = "Alert! Alert!"

        verify()
    }

    func testErrorAndDisabled() {
        textInput.hasError = true
        textInput.isEnabled = false
        textInput.text = "This should appear disabled"

        verify()
    }

    func testErrorAndSelected() {
        textInput.hasError = true
        textInput.isSelected = true
        textInput.text = "This should appear as error"

        verify()
    }

    func testLeftView() {
        let leftView = UIButton(type: .system)
        leftView.setTitle("left", for: .normal)

        textInput.leftView = leftView
        textInput.leftViewMode = .always

        textInput.text = "This should appear with a left button"

        verify()
    }

    func testRightView() {
        let rightView = UIButton(type: .system)
        rightView.setTitle("right", for: .normal)

        textInput.rightView = rightView
        textInput.rightViewMode = .always

        textInput.text = "This should appear with a right button"

        verify()
    }

    func testLeftAndRightView() {
        let leftView = UIButton(type: .system)
        leftView.setTitle("left", for: .normal)

        textInput.leftView = leftView
        textInput.leftViewMode = .always

        let rightView = UIButton(type: .system)
        rightView.setTitle("right", for: .normal)

        textInput.rightView = rightView
        textInput.rightViewMode = .always

        textInput.text = "This should appear with left and right buttons"

        verify()
    }

    private func verify(file: StaticString = #filePath, line: UInt = #line) {
        verify(
            view: textInput,
            sizes: [.defaultWidthIntrinsicHeight],
            file: file,
            line: line
        )
    }
}
