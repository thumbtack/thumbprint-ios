import Thumbprint
import UIKit

class IconFloatingActionButtonTest: SnapshotTestCase {
    func testWithPrimaryTheme() {
        let button = IconFloatingActionButton(icon: Icon.contentActionsAddMedium, accessibilityLabel: "Add action")
        verify(view: button, contentSizeCategories: [.unspecified])
    }

    func testWithSecondaryTheme() {
        let button = IconFloatingActionButton(
            icon: Icon.contentActionsAddMedium,
            accessibilityLabel: "Add action",
            theme: .secondary
        )
        verify(view: button, contentSizeCategories: [.unspecified])
    }

    func testIsHighlighted() {
        let button = IconFloatingActionButton(icon: Icon.contentActionsAddMedium, accessibilityLabel: "Add action")
        button.isHighlighted = true
        verify(view: button, contentSizeCategories: [.unspecified])
    }

    func testIsHighlightedSecondary() {
        let button = IconFloatingActionButton(
            icon: Icon.contentActionsAddMedium,
            accessibilityLabel: "Add action",
            theme: .secondary
        )
        button.isHighlighted = true
        verify(view: button, contentSizeCategories: [.unspecified])
    }

    func testChangeIcon() {
        let button = IconFloatingActionButton(icon: Icon.contentActionsAddMedium, accessibilityLabel: "Add action")
        button.setIcon(Icon.contentActionsArchiveMedium, accessibilityLabel: "Archive")
        verify(view: button, contentSizeCategories: [.unspecified])
    }

    func testChangeTheme() {
        let button = IconFloatingActionButton(icon: Icon.contentActionsAddMedium, accessibilityLabel: "Add action")
        button.theme = .secondary
        verify(view: button, contentSizeCategories: [.unspecified])
    }

    func testChangeThemeHighlighted() {
        let button = IconFloatingActionButton(icon: Icon.contentActionsAddMedium, accessibilityLabel: "Add action")
        button.theme = .secondary
        button.isHighlighted = true
        verify(view: button, contentSizeCategories: [.unspecified])
    }

    func testChangeThemeAndBack() {
        let button = IconFloatingActionButton(icon: Icon.contentActionsAddMedium, accessibilityLabel: "Add action")
        button.theme = .secondary
        button.theme = .primary
        verify(view: button, contentSizeCategories: [.unspecified])
    }

    func testChangeThemeAndBackHighlighted() {
        let button = IconFloatingActionButton(icon: Icon.contentActionsAddMedium, accessibilityLabel: "Add action")
        button.theme = .secondary
        button.theme = .primary
        button.isHighlighted = true
        verify(view: button, contentSizeCategories: [.unspecified])
    }
}
