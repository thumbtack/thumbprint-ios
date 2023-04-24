import ThumbprintTokens
import UIKit

/// A set of utilities for configuring the appearance of tab bars
/// to match Thumbprint guidelines.
public enum TabBar {
    private static var normalTitleTextAttributes: [NSAttributedString.Key: Any] = [
        .foregroundColor: Color.black300,
        .font: Font.TextStyle(
            weight: .bold,
            size: 10,
            uiFontTextStyle: .body
        ).uiFont,
    ]

    private static var selectedTitleTextAttributes: [NSAttributedString.Key: Any] = [
        .foregroundColor: Color.blue,
    ]

    private static var badgeTextAttributes: [NSAttributedString.Key: Any] = [
        .foregroundColor: Color.white,
        .font: Font.TextStyle(
            weight: .normal,
            size: 14,
            uiFontTextStyle: .body
        ).uiFont,
    ]

    /// Convenience function for setting the appearance of a tab bar.
    /// The provided tab bar can either be the one returned by
    /// UITabBar.appearance() or another individual instance.
    ///
    /// - Parameters:
    ///     - tabBar: The tab bar to configure.
    public static func configure(tabBar: UITabBar) {
        if #available(iOS 15.0, *) {
            let tabBarAppearance = UITabBarAppearance()
            tabBarAppearance.configureWithOpaqueBackground()
            tabBarAppearance.backgroundColor = Color.white

            tabBarAppearance.stackedLayoutAppearance.selected.iconColor = Color.blue
            tabBarAppearance.stackedLayoutAppearance.normal.iconColor = Color.black300
            tabBarAppearance.stackedLayoutAppearance.selected.titleTextAttributes = selectedTitleTextAttributes
            tabBarAppearance.stackedLayoutAppearance.normal.titleTextAttributes = normalTitleTextAttributes
            tabBarAppearance.stackedLayoutAppearance.normal.badgeBackgroundColor = Color.red
            tabBarAppearance.stackedLayoutAppearance.selected.badgeBackgroundColor = Color.red
            tabBarAppearance.stackedLayoutAppearance.normal.badgeTextAttributes = badgeTextAttributes
            tabBarAppearance.stackedLayoutAppearance.selected.badgeTextAttributes = badgeTextAttributes

            tabBarAppearance.inlineLayoutAppearance.selected.iconColor = Color.blue
            tabBarAppearance.inlineLayoutAppearance.normal.iconColor = Color.black300
            tabBarAppearance.inlineLayoutAppearance.selected.titleTextAttributes = selectedTitleTextAttributes
            tabBarAppearance.inlineLayoutAppearance.normal.titleTextAttributes = normalTitleTextAttributes
            tabBarAppearance.inlineLayoutAppearance.normal.badgeBackgroundColor = Color.red
            tabBarAppearance.inlineLayoutAppearance.selected.badgeBackgroundColor = Color.red
            tabBarAppearance.inlineLayoutAppearance.normal.badgeTextAttributes = badgeTextAttributes
            tabBarAppearance.inlineLayoutAppearance.selected.badgeTextAttributes = badgeTextAttributes

            tabBarAppearance.compactInlineLayoutAppearance.selected.iconColor = Color.blue
            tabBarAppearance.compactInlineLayoutAppearance.normal.iconColor = Color.black300
            tabBarAppearance.compactInlineLayoutAppearance.selected.titleTextAttributes = selectedTitleTextAttributes
            tabBarAppearance.compactInlineLayoutAppearance.normal.titleTextAttributes = normalTitleTextAttributes
            tabBarAppearance.compactInlineLayoutAppearance.normal.badgeBackgroundColor = Color.red
            tabBarAppearance.compactInlineLayoutAppearance.selected.badgeBackgroundColor = Color.red
            tabBarAppearance.compactInlineLayoutAppearance.normal.badgeTextAttributes = badgeTextAttributes
            tabBarAppearance.compactInlineLayoutAppearance.selected.badgeTextAttributes = badgeTextAttributes

            tabBar.standardAppearance = tabBarAppearance
            tabBar.scrollEdgeAppearance = tabBarAppearance
        } else {
            tabBar.barTintColor = Color.white
            tabBar.isTranslucent = false
            tabBar.tintColor = Color.blue
            tabBar.unselectedItemTintColor = Color.black300
        }
    }

    /// Convenience function for setting the appearance of a tab bar item.
    /// The provided tab bar item can either be the one returned by
    /// UITabBarItem.appearance() or another individual instance.
    ///
    /// - Parameters:
    ///     - tabBarItem: The tab bar item to configure.
    public static func configure(tabBarItem: UITabBarItem) {
        guard #available(iOS 15.0, *) else {
            tabBarItem.badgeColor = Color.red
            tabBarItem.setBadgeTextAttributes(badgeTextAttributes, for: .normal)
            tabBarItem.setTitleTextAttributes(TabBar.normalTitleTextAttributes, for: .normal)
            tabBarItem.setTitleTextAttributes(TabBar.selectedTitleTextAttributes, for: .selected)
            return
        }
    }
}
