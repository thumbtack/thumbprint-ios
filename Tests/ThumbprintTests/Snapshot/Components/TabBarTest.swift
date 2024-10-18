import Thumbprint
import UIKit

class TabBarTest: SnapshotTestCase {
    @MainActor func testAppearance() {
        let tabBar = UITabBar(frame: CGRect(origin: .zero, size: SnapshotTestCase.WindowSize.defaultWidthIntrinsicHeight.cgSize))
        let items = [
            UITabBarItem(title: "Left", image: Icon.notificationAlertsInfoFilledMedium.image, selectedImage: nil),
            UITabBarItem(title: "Middle", image: Icon.notificationAlertsInfoFilledMedium.image, selectedImage: nil),
            UITabBarItem(title: "Right", image: Icon.notificationAlertsInfoFilledMedium.image, selectedImage: nil),
        ]
        items.forEach { TabBar.configure(tabBarItem: $0) }
        tabBar.items = items
        TabBar.configure(tabBar: tabBar)

        verify(
            viewControllerFactory: {
                let viewController = UIViewController()
                viewController.view.backgroundColor = Color.white
                viewController.view.addSubview(tabBar)
                tabBar.snp.makeConstraints { make in
                    make.left.bottom.right.equalToSuperview()
                }
                return viewController
            },
            sizes: [.default],
            contentSizeCategories: [.unspecified]
        )
    }
}
