import Thumbprint
import UIKit

class ButtonStackTest: SnapshotTestCase {
    func testOneButton() {
        let button1 = Button(adjustsFontForContentSizeCategory: false)
        button1.title = "Button 1"

        verify(ButtonStack(buttons: [button1]))
    }

    func testTwoButtons() {
        let button1 = Button(adjustsFontForContentSizeCategory: false)
        button1.title = "Button 1"

        let button2 = Button(adjustsFontForContentSizeCategory: false)
        button2.title = "Button 2"

        verify(ButtonStack(buttons: [button1, button2]))
    }

    func testThreeButtons() {
        let button1 = Button(adjustsFontForContentSizeCategory: false)
        button1.title = "Button 1"

        let button2 = Button(adjustsFontForContentSizeCategory: false)
        button2.title = "Button 2"

        let button3 = Button(adjustsFontForContentSizeCategory: false)
        button3.title = "Button 3"

        verify(ButtonStack(buttons: [button1, button2, button3]))
    }

    func verify(_ buttonStack: ButtonStack, file: StaticString = #filePath, line: UInt = #line) {
        verify(view: buttonStack,
               identifier: "\(buttonStack.arrangedSubviews.count)buttons",
               contentSizeCategories: [.unspecified],
               file: file,
               line: line)
    }
}
