import Thumbprint
import UIKit

class AlertBannerTest: SnapshotTestCase {
    @MainActor func testInfo() {
        let alertBanner = Thumbprint.AlertBanner(
            theme: .info,
            message: "This is a sample message for an info banner.",
            action: "Update action",
            actionLink: "/link",
            delegate: self
        )
        verify(alertBanner: alertBanner)
    }

    @MainActor func testWarning() {
        let alertBanner = Thumbprint.AlertBanner(
            theme: .warning,
            message: "This is a sample message for a warning banner.",
            action: "Update action",
            actionLink: "/link",
            delegate: self
        )
        verify(alertBanner: alertBanner)
    }

    @MainActor func testCaution() {
        let alertBanner = Thumbprint.AlertBanner(
            theme: .caution,
            message: "This is a sample message for a caution banner.",
            action: "Update action",
            actionLink: "/link",
            delegate: self
        )
        verify(alertBanner: alertBanner)
    }

    @MainActor func testMaxHeight() {
        let alertBanner = Thumbprint.AlertBanner(
            theme: .info,
            message: "This is a sample message for an info banner.",
            action: "Update action",
            actionLink: "/link",
            delegate: self
        )
        alertBanner.snp.makeConstraints { make in
            make.height.lessThanOrEqualTo(200)
        }
        verify(alertBanner: alertBanner)
    }

    @MainActor func testUpdate() {
        let alertBanner = Thumbprint.AlertBanner(
            theme: .info,
            message: "This is a sample message for an info banner.",
            action: "Update action",
            actionLink: "/link",
            delegate: self
        )
        alertBanner.update(theme: .caution, message: "This is an info banner updated to a caution banner.", action: "Updated action", actionLink: "/updatedlink")
        verify(alertBanner: alertBanner)
    }

    @MainActor func verify(alertBanner: AlertBanner) {
        for widthToVerify in WindowSize.allPhones.map({ windowSize in windowSize.cgSize.width }) {
            verify(
                view: alertBanner,
                identifier: "\(widthToVerify)",
                sizes: [
                    WindowSize.size(
                        width: widthToVerify,
                        height: .intrinsic
                    ),
                ],
                padding: 0
            )
        }
    }
}

extension AlertBannerTest: AlertBannerDelegate {
    func alertBannerDidTapAction(_ alertBanner: AlertBanner, link: String) {}
}
