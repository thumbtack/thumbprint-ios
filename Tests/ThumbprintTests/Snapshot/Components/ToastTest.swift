@testable import Thumbprint
import UIKit

class ToastTest: SnapshotTestCase {
    @MainActor func testDefaultTheme() {
        let toast = Toast(message: "This is a message?", theme: Toast.Theme.default(), action: Toast.Action(text: "Take Action", handler: {}))
        verify(toast: toast)
    }

    @MainActor func testAlertTheme() {
        let toast = Toast(message: "This is a message?", theme: Toast.Theme.alert(), action: Toast.Action(text: "Take Action", handler: {}))
        verify(toast: toast)
    }

    @MainActor func testInfoTheme() {
        let toast = Toast(message: "This is a message?", theme: Toast.Theme.info(), action: Toast.Action(text: "Take Action", handler: {}))
        verify(toast: toast)
    }

    @MainActor func testCautionTheme() {
        let toast = Toast(message: "This is a message?", theme: Toast.Theme.caution(), action: Toast.Action(text: "Take Action", handler: {}))
        verify(toast: toast)
    }

    @MainActor func testSuccessTheme() {
        // NOTE WE SET NO IMAGE HERE BECAUSE THE DEFAULT IMAGE ISNT BUNDLED
        let toast = Toast(message: "This is a message?", theme: Toast.Theme.success(nil), action: Toast.Action(text: "Take Action", handler: {}))
        verify(toast: toast)
    }

    @MainActor func testCustomImage() {
        let toast = Toast(message: "This is a message?", theme: Toast.Theme.success(Icon.contentActionsAddMedium), action: Toast.Action(text: "Take Action", handler: {}))
        verify(toast: toast)
    }

    @MainActor func testLongText() {
        let toast = Toast(message: "This is a very long message that should probably wrap to fit multiple lines, except on iPad.", theme: Toast.Theme.success(Icon.contentActionsAddMedium), action: Toast.Action(text: "Hyperlink Text", handler: {}))
        verify(toast: toast)
    }

    @MainActor private func verify(toast: Toast) {
        verify(
            viewFactory: {
                toast.showToast(animated: false, completion: nil)
                let containerView = UIView()
                containerView.addSubview(toast)
                toast.snp.makeConstraints { make in
                    make.leading.trailing.bottom.equalToSuperview()
                }
                return containerView
            },
            sizes: .all,
            contentSizeCategories: [.unspecified]
        )
    }
}
