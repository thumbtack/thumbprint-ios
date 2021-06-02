//
//  ButtonUnitTest.swift
//  ThumbprintTests
//
//  Created by yliao on 6/2/21.
//
@testable import Thumbprint
import XCTest

class ButtonUnitTest: XCTestCase {

    func testAccessibilityLabel() {
        let button = Button()
        XCTAssertNil(button.title)
        XCTAssertNil(button.accessibilityLabel)

        button.title = "tap it"
        XCTAssertEqual(button.accessibilityLabel, "tap it")

        button.title = "smash it"
        XCTAssertEqual(button.accessibilityLabel, "smash it")

        button.accessibilityLabel = "smash it to select an item"
        XCTAssertEqual(button.accessibilityLabel, "smash it to select an item")

        button.title = nil
        XCTAssertEqual(button.accessibilityLabel, "smash it to select an item")
    }

}
