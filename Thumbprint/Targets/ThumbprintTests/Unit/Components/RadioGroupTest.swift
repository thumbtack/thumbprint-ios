import Combine
@testable import Thumbprint
import XCTest

class RadioGroupTest: UnitTestCase {
    func testRadioGroup() {
        let radioGroup = RadioGroup<Int>()

        let radios = [
            Radio(text: "One"),
            Radio(text: "Two"),
            Radio(text: "Thre"),
            Radio(text: "Four"),
            Radio(text: "Five")
        ]

        radios.enumerated().forEach { (index, radio) in
            radioGroup.registerRadio(radio, forKey: index + 1)
        }

        var currentSelection: Int? = 1000
        var updateCount = 0

        let firstCallExpectation = expectation(description: "Initial selection update call")
        let updateExpectation = expectation(description: "Selection updated")

        var subscriptions = [AnyCancellable]()

        radioGroup.selection
            .sink { selection in
                currentSelection = selection
                switch updateCount {
                case 0:
                    firstCallExpectation.fulfill()

                case 1:
                    updateExpectation.fulfill()

                default:
                    XCTFail("Too many selection update calls")
                }
                updateCount += 1
            }
            .store(in: &subscriptions)

        // Test initialization of the selection subscription.
        wait(for: [firstCallExpectation], timeout: 1.0)
        XCTAssertNil(currentSelection)
        XCTAssertEqual(updateCount, 1)

        // Test for selection update.
        radioGroup.setSelection(1)
        wait(for: [updateExpectation], timeout: 1.0)
        XCTAssertEqual(currentSelection, 1)
        XCTAssertEqual(updateCount, 2)

        // Test that we don't get extra calls when re-setting selection. It'll fail in the subscription block.
        radioGroup.setSelection(1)
    }
}
