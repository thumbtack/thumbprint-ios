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

    @MainActor func testDefaultState() {
        verify()
    }

    @MainActor func testSelectedEmpty() {
        textInput.isSelected = true

        verify()
    }

    @MainActor func testSelectedFilled() {
        textInput.isSelected = true
        textInput.text = "Me first!"

        verify()
    }

    @MainActor func testHighlightedEmpty() {
        textInput.isHighlighted = true

        verify()
    }

    @MainActor func testHighlightedFilled() {
        textInput.isHighlighted = true
        textInput.text = "I am so highlighted right now"

        verify()
    }

    @MainActor func testDisabledEmpty() {
        textInput.isEnabled = false

        verify()
    }

    @MainActor func testDisabledFilled() {
        textInput.isEnabled = false
        textInput.text = "When I was your age..."

        verify()
    }

    @MainActor func testErrorEmpty() {
        textInput.hasError = true

        verify()
    }

    @MainActor func testErrorFilled() {
        textInput.hasError = true
        textInput.text = "Alert! Alert!"

        verify()
    }

    @MainActor func testErrorAndDisabled() {
        textInput.hasError = true
        textInput.isEnabled = false
        textInput.text = "This should appear disabled"

        verify()
    }

    @MainActor func testErrorAndSelected() {
        textInput.hasError = true
        textInput.isSelected = true
        textInput.text = "This should appear as error"

        verify()
    }

    @MainActor func testLeftView() {
        let leftView = UIButton(type: .system)
        leftView.setTitle("left", for: .normal)

        textInput.leftView = leftView
        textInput.leftViewMode = .always

        textInput.text = "This should appear with a left button"

        verify()
    }

    @MainActor func testRightView() {
        let rightView = UIButton(type: .system)
        rightView.setTitle("right", for: .normal)

        textInput.rightView = rightView
        textInput.rightViewMode = .always

        textInput.text = "This should appear with a right button"

        verify()
    }

    @MainActor func testLeftAndRightView() {
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

    @MainActor private func verify(file: StaticString = #filePath, line: UInt = #line) {
        verify(
            view: textInput,
            sizes: [.defaultWidthIntrinsicHeight],
            file: file,
            line: line
        )
    }
}
