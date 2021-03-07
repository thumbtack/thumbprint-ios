import ThumbprintTokens
import UIKit

/// A set of utilities for configuring the appearance of tab bars
/// to match Thumbprint guidelines.
public enum TabBar {
    /// Convenience function for setting the appearance of a tab bar.
    /// The provided tab bar can either be the one returned by
    /// UITabBar.appearance() or another individual instance.
    ///
    /// - Parameters:
    ///     - tabBar: The tab bar to configure.
    public static func configure(tabBar: UITabBar) {
        tabBar.barTintColor = Color.white
        tabBar.isTranslucent = false
        tabBar.tintColor = Color.blue
        tabBar.unselectedItemTintColor = Color.black300
    }

    /// Convenience function for setting the appearance of a tab bar item.
    /// The provided tab bar item can either be the one returned by
    /// UITabBarItem.appearance() or another individual instance.
    ///
    /// - Parameters:
    ///     - tabBarItem: The tab bar item to configure.
    public static func configure(tabBarItem: UITabBarItem) {
        tabBarItem.setTitleTextAttributes(
            [
                .foregroundColor: Color.black300,
                .font: Font.TextStyle(
                    weight: .bold,
                    size: 10,
                    uiFontTextStyle: .body
                ).uiFont,
            ],
            for: .normal
        )

        tabBarItem.setTitleTextAttributes(
            [
                .foregroundColor: Color.blue,
            ],
            for: .selected
        )

        tabBarItem.badgeColor = Color.red

        tabBarItem.setBadgeTextAttributes(
            [
                .foregroundColor: Color.white,
                .font: Font.TextStyle(
                    weight: .normal,
                    size: 14,
                    uiFontTextStyle: .body
                ).uiFont,
            ],
            for: .normal
        )
    }
}
