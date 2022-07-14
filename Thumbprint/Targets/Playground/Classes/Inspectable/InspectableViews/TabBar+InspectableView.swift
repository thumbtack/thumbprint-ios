import Thumbprint
import UIKit

extension UITabBar: InspectableView {
    static var name: String {
        "Tab Bar"
    }

    var inspectableProperties: [InspectableProperty] {
        []
    }

    static func makeInspectable() -> UIView & InspectableView {
        let tabBar = UITabBar()
        TabBar.configure(tabBar: tabBar)

        let exploreItem = UITabBarItem(title: "Explore", image: Icon.featureExploreMedium.image, selectedImage: nil)
        TabBar.configure(tabBarItem: exploreItem)

        let inboxItem = UITabBarItem(title: "Inbox", image: Icon.featureInboxMedium.image, selectedImage: nil)
        TabBar.configure(tabBarItem: inboxItem)

        let notificationsItem = UITabBarItem(title: "Notifications", image: Icon.notificationAlertsNotificationMedium.image, selectedImage: nil)
        notificationsItem.badgeValue = "4"
        TabBar.configure(tabBarItem: notificationsItem)

        tabBar.items = [exploreItem, inboxItem, notificationsItem]

        return tabBar
    }
}
