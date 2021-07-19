import Thumbprint
import UIKit

class TabBarTest: SnapshotTestCase {
    func testAppearance() {
        let tabBar = UITabBar(frame: CGRect(origin: .zero, size: SnapshotTestCase.WindowSize.defaultWidthIntrinsicHeight.cgSize))
        let items = [
            UITabBarItem(title: "Left", image: Icon.notificationAlertsInfoFilledMedium, selectedImage: nil),
            UITabBarItem(title: "Middle", image: Icon.notificationAlertsInfoFilledMedium, selectedImage: nil),
            UITabBarItem(title: "Right", image: Icon.notificationAlertsInfoFilledMedium, selectedImage: nil),
        ]
        items.forEach { TabBar.configure(tabBarItem: $0) }
        tabBar.items = items
        TabBar.configure(tabBar: tabBar)

        verify(
            viewControllerFactory: {
                let viewController = UIViewController()
                viewController.view.backgroundColor = Color.white
                viewController.view.addManagedSubview(tabBar)
                tabBar.snapToSuperviewEdges([.leading, .bottom, .trailing])
                return viewController
            },
            sizes: [.default],
            contentSizeCategories: [.unspecified]
        )
    }
}
