import Thumbprint
import UIKit

class IconFloatingActionButtonTest: SnapshotTestCase {
    @MainActor func testWithPrimaryTheme() {
        let button = IconFloatingActionButton(icon: Icon.notificationAlertsInfoFilledMedium.image, accessibilityLabel: "Add action")
        verify(view: button, contentSizeCategories: [.unspecified])
    }

    @MainActor func testWithSecondaryTheme() {
        let button = IconFloatingActionButton(
            icon: Icon.notificationAlertsInfoFilledMedium.image,
            accessibilityLabel: "Add action",
            theme: .secondary
        )
        verify(view: button, contentSizeCategories: [.unspecified])
    }

    @MainActor func testIsHighlighted() {
        let button = IconFloatingActionButton(icon: Icon.notificationAlertsInfoFilledMedium.image, accessibilityLabel: "Add action")
        button.isHighlighted = true
        verify(view: button, contentSizeCategories: [.unspecified])
    }

    @MainActor func testIsHighlightedSecondary() {
        let button = IconFloatingActionButton(
            icon: Icon.notificationAlertsInfoFilledMedium.image,
            accessibilityLabel: "Add action",
            theme: .secondary
        )
        button.isHighlighted = true
        verify(view: button, contentSizeCategories: [.unspecified])
    }

    @MainActor func testChangeIcon() {
        let button = IconFloatingActionButton(icon: Icon.notificationAlertsInfoFilledMedium.image, accessibilityLabel: "Add action")
        button.setIcon(Icon.notificationAlertsBlockedFilledMedium.image, accessibilityLabel: "Archive")
        verify(view: button, contentSizeCategories: [.unspecified])
    }

    @MainActor func testChangeTheme() {
        let button = IconFloatingActionButton(icon: Icon.notificationAlertsInfoFilledMedium.image, accessibilityLabel: "Add action")
        button.theme = .secondary
        verify(view: button, contentSizeCategories: [.unspecified])
    }

    @MainActor func testChangeThemeHighlighted() {
        let button = IconFloatingActionButton(icon: Icon.notificationAlertsInfoFilledMedium.image, accessibilityLabel: "Add action")
        button.theme = .secondary
        button.isHighlighted = true
        verify(view: button, contentSizeCategories: [.unspecified])
    }

    @MainActor func testChangeThemeAndBack() {
        let button = IconFloatingActionButton(icon: Icon.notificationAlertsInfoFilledMedium.image, accessibilityLabel: "Add action")
        button.theme = .secondary
        button.theme = .primary
        verify(view: button, contentSizeCategories: [.unspecified])
    }

    @MainActor func testChangeThemeAndBackHighlighted() {
        let button = IconFloatingActionButton(icon: Icon.notificationAlertsInfoFilledMedium.image, accessibilityLabel: "Add action")
        button.theme = .secondary
        button.theme = .primary
        button.isHighlighted = true
        verify(view: button, contentSizeCategories: [.unspecified])
    }
}
