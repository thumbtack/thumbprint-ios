@testable import Thumbprint
import XCTest

class AlertBannerUnitTest: UnitTestCase {
    var tappedActionLink: String?

    override func setUp() {
        super.setUp()

        Icon.register(bundle: Bundle.thumbprint)
    }

    override func tearDown() {
        tappedActionLink = nil

        super.tearDown()
    }

    func testActionDelegate() {
        let alertBanner = Thumbprint.AlertBanner(
            theme: .info,
            message: "This is a sample message for an info banner.",
            action: "Update action",
            actionLink: "/link",
            delegate: self
        )
        XCTAssert(alertBanner.textView.isUserInteractionEnabled)
        XCTAssert(alertBanner.textView.isSelectable)
        XCTAssertFalse(alertBanner.textView(alertBanner.textView, shouldInteractWith: URL(fileURLWithPath: "/link"), in: NSRange(), interaction: .invokeDefaultAction))
        XCTAssertNotNil(tappedActionLink)
    }
}

extension AlertBannerUnitTest: AlertBannerDelegate {
    func alertBannerDidTapAction(_ alertBanner: AlertBanner, link: String) {
        tappedActionLink = link
    }
}
