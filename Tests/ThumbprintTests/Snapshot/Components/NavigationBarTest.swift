import Thumbprint
import UIKit

class NavigationBarTest: SnapshotTestCase {
    @MainActor private let appearances: [String: NavigationBar.Appearance] = [
        "default": .default,
        "scrollEdgeShadowless": .scrollEdgeShadowless,
        "shadowless": .shadowless,
        "transparent": .transparent,
    ]

    private let contentStyles: [String: NavigationBar.ContentStyle] = [
        "default": .default,
        "light": .light,
    ]

    @MainActor func testAppearances() {
        appearances.forEach {
            let (appearanceIdentifier, appearance) = $0

            verify(identifier: appearanceIdentifier) {
                NavigationBar.configure($0, appearance: appearance, content: .default)
            }
        }
    }

    @MainActor func testContentStyles() {
        contentStyles.forEach {
            let (contentStyleIdentifier, contentStyle) = $0

            verify(identifier: contentStyleIdentifier) {
                NavigationBar.configure($0, appearance: .transparent, content: contentStyle)
            }
        }
    }

    @MainActor func verify(identifier: String?, file: StaticString = #file, line: UInt = #line, configure: (UINavigationBar) -> Void) {
        verify(
            viewControllerFactory: {
                let viewController = UIViewController()
                viewController.view.backgroundColor = Color.gray
                viewController.title = "Test"
                viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(image: Icon.navigationCaretLeftMedium.image, style: .plain, target: nil, action: nil)

                let navigationController = UINavigationController(rootViewController: viewController)
                navigationController.view.frame = CGRect(x: 0, y: 0, width: 375, height: 400)

                configure(navigationController.navigationBar)
                return navigationController
            },
            identifier: identifier,
            sizes: [.default],
            contentSizeCategories: [.unspecified]
        )
    }
}
