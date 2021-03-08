import Thumbprint
import XCTest

class UIView_StackViewTests: UnitTestCase {
    var stackView: UIStackView?

    /**
     This is not so much a unit test as a canary to let us know if Apple ever fixes the issue with hiding views
     in a stack view within an animation (http://www.openradar.me/25087688). If this test ever starts failing it
     means they finally fixed the problem and we can mark that iOS version as the one where we'd be able to remove
     the workaround once older ones are no longer supported.
     */
    func testUIKitBug() {
        let view1 = UIView()
        let view2 = UIView()
        stackView = .init(arrangedSubviews: [view1, view2])
        defer {
            stackView = nil
        }

        let animationExpectation = expectation(description: "Animation completed")
        UIView.animate(withDuration: 0.1) {
            view1.isHidden = true
            view1.isHidden = true
            view1.isHidden = false
        } completion: { _ in
            animationExpectation.fulfill()
        }

        waitForExpectations(timeout: 1.0)
        XCTAssertEqual(view1.isHidden, true)
    }

    func testWorkaroundProperty() {
        let view1 = UIView()
        let view2 = UIView()
        stackView = .init(arrangedSubviews: [view1, view2])
        defer {
            stackView = nil
        }

        let animationExpectation = expectation(description: "Animation completed")
        UIView.animate(withDuration: 0.1) {
            view1.showsInStackView = false
            view1.showsInStackView = false
            view1.showsInStackView = true
        } completion: { _ in
            animationExpectation.fulfill()
        }

        waitForExpectations(timeout: 1.0)
        XCTAssertEqual(view1.isHidden, false)
    }
}
