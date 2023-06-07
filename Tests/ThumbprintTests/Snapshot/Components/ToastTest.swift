@testable import Thumbprint
import UIKit

class ToastTest: SnapshotTestCase {
    func testDefaultTheme() {
        let toast = Toast(message: "This is a message?", theme: .default, iconType: .defaultForTheme, action: Toast.Action(text: "Take Action", handler: {}))
        verify(toast: toast)
    }

    func testAlertTheme() {
        let toast = Toast(message: "This is a message?", theme: .alert, iconType: .defaultForTheme, action: Toast.Action(text: "Take Action", handler: {}))
        verify(toast: toast)
    }

    func testInfoTheme() {
        let toast = Toast(message: "This is a message?", theme: .info, iconType: .defaultForTheme, action: Toast.Action(text: "Take Action", handler: {}))
        verify(toast: toast)
    }

    func testCautionTheme() {
        let toast = Toast(message: "This is a message?", theme: .caution, iconType: .defaultForTheme, action: Toast.Action(text: "Take Action", handler: {}))
        verify(toast: toast)
    }

    func testSuccessTheme() {
        // NOTE WE SET NO IMAGE HERE BECAUSE THE DEFAULT IMAGE ISNT BUNDLED
        let toast = Toast(message: "This is a message?", theme: .success, iconType: .custom(nil), action: Toast.Action(text: "Take Action", handler: {}))
        verify(toast: toast)
    }

    func testCustomImage() {
        let toast = Toast(message: "This is a message?", theme: .success, iconType: .custom(.contentActionsAddMedium), action: Toast.Action(text: "Take Action", handler: {}))
        verify(toast: toast)
    }

    func testLongText() {
        let toast = Toast(message: "This is a very long message that should probably wrap to fit multiple lines, except on iPad.", theme: .success, iconType: .custom(.contentActionsAddMedium), action: Toast.Action(text: "Hyperlink Text", handler: {}))
        verify(toast: toast)
    }

    private func verify(toast: Toast) {
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
