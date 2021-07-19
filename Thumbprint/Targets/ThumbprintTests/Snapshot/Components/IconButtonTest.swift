import Thumbprint
import UIKit

class IconButtonTest: SnapshotTestCase {
    private let themes: [String: IconButton.Theme] = [
        "default": .default,
        "dark": .dark,
    ]

    func testIconButton() {
        let containerView = UIView()
        containerView.backgroundColor = Color.blue

        themes.forEach {
            let (themeIdentifier, theme) = $0

            let iconButton = IconButton(
                icon: Icon.notificationAlertsInfoFilledMedium,
                accessibilityLabel: "Add",
                theme: theme
            )
            containerView.addManagedSubview(iconButton)
            iconButton.snapToSuperviewEdges(.all)

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

    func testChangeIconSize() {
        let iconButton = IconButton(
            icon: Icon.notificationAlertsInfoFilledMedium,
            accessibilityLabel: "Add",
            theme: .default
        )

        iconButton.setIcon(
            Icon.notificationAlertsWarningFilledMedium,
            accessibilityLabel: "Filter"
        )

        verify(view: iconButton, contentSizeCategories: [.unspecified])
    }

    func testAddInsetsToIconButton() {
        let iconButton = IconButton(
            icon: Icon.notificationAlertsInfoFilledMedium,
            accessibilityLabel: "Add",
            theme: .dark
        )
        iconButton.backgroundColor = Color.blue
        iconButton.contentEdgeInsets = UIEdgeInsets(top: Space.two, left: Space.two, bottom: Space.two, right: Space.two)
        verify(view: iconButton, contentSizeCategories: [.unspecified])
    }
}
