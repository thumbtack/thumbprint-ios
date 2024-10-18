import Thumbprint
import UIKit

class IconButtonTest: SnapshotTestCase {
    private let themes: [String: IconButton.Theme] = [
        "default": .default,
        "dark": .dark,
    ]

    @MainActor func testIconButton() {
        let containerView = UIView()
        containerView.backgroundColor = Color.blue

        themes.forEach {
            let (themeIdentifier, theme) = $0

            let iconButton = IconButton(
                icon: Icon.notificationAlertsInfoFilledMedium.image,
                accessibilityLabel: "Add",
                theme: theme
            )
            containerView.addSubview(iconButton)
            iconButton.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }

            verify(view: containerView,
                   identifier: "\(themeIdentifier)_normal",
                   contentSizeCategories: [.unspecified])

            iconButton.isHighlighted = true

            verify(view: containerView,
                   identifier: "\(themeIdentifier)_highlighted",
                   contentSizeCategories: [.unspecified])

            iconButton.isHighlighted = false
            iconButton.isEnabled = false

            verify(view: containerView,
                   identifier: "\(themeIdentifier)_disabled",
                   contentSizeCategories: [.unspecified])

            iconButton.isEnabled = true

            iconButton.removeFromSuperview()
        }
    }

    @MainActor func testChangeIconSize() {
        let iconButton = IconButton(
            icon: Icon.notificationAlertsInfoFilledMedium.image,
            accessibilityLabel: "Add",
            theme: .default
        )

        iconButton.setIcon(
            Icon.notificationAlertsWarningFilledMedium.image,
            accessibilityLabel: "Filter"
        )

        verify(view: iconButton, contentSizeCategories: [.unspecified])
    }

    @MainActor func testAddInsetsToIconButton() {
        let iconButton = IconButton(
            icon: Icon.notificationAlertsInfoFilledMedium.image,
            accessibilityLabel: "Add",
            theme: .dark
        )
        iconButton.backgroundColor = Color.blue
        iconButton.contentEdgeInsets = UIEdgeInsets(top: Space.two, left: Space.two, bottom: Space.two, right: Space.two)
        verify(view: iconButton, contentSizeCategories: [.unspecified])
    }

    @MainActor func testChangeIconAndTheme() {
        let iconButton = IconButton(
            icon: Icon.notificationAlertsInfoFilledMedium.image,
            accessibilityLabel: "Add",
            theme: .dark
        )
        iconButton.setIcon(
            Icon.notificationAlertsWarningFilledMedium.image,
            accessibilityLabel: "Warning",
            theme: .default
        )
        verify(view: iconButton, contentSizeCategories: [.unspecified])
    }
}
