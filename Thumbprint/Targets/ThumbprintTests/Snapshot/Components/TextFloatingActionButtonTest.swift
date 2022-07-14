import Thumbprint
import UIKit

class TextFloatingActionButtonTest: SnapshotTestCase {
    func testWithPrimaryTheme() {
        let button = TextFloatingActionButton(text: "Floating action button", accessibilityLabel: "Floating action button")
        verify(view: button, contentSizeCategories: [.unspecified])
    }

    func testWithPrimaryThemeAndImage() {
        let button = TextFloatingActionButton(text: "Floating action button", accessibilityLabel: "Floating action button")
        let imageView = UIImageView()
        imageView.image = Icon.notificationAlertsInfoFilledMedium.image
        button.setLeftView(imageView, largeContentImage: imageView.image)
        verify(view: button, contentSizeCategories: [.unspecified])
    }

    func testWithPrimaryThemeImageAndShortText() {
        let button = TextFloatingActionButton(text: "Hey", accessibilityLabel: "Hey")
        let imageView = UIImageView()
        imageView.image = Icon.notificationAlertsInfoFilledMedium.image
        button.setLeftView(imageView, largeContentImage: imageView.image)
        verify(view: button, contentSizeCategories: [.unspecified])
    }

    func testWithSecondaryTheme() {
        let button = TextFloatingActionButton(
            text: "Floating action button",
            accessibilityLabel: "Floating action button",
            theme: .secondary
        )
        verify(view: button, contentSizeCategories: [.unspecified])
    }

    func testWithSecondaryThemeAndImage() {
        let button = TextFloatingActionButton(
            text: "Floating action button",
            accessibilityLabel: "Floating action button",
            theme: .secondary
        )
        let imageView = UIImageView()
        imageView.image = Icon.notificationAlertsInfoFilledMedium.image
        button.setLeftView(imageView, largeContentImage: imageView.image)
        verify(view: button, contentSizeCategories: [.unspecified])
    }

    func testWithSecondaryThemeImageAndShortText() {
        let button = TextFloatingActionButton(
            text: "Hey",
            accessibilityLabel: "Hey",
            theme: .secondary
        )
        let imageView = UIImageView()
        imageView.image = Icon.notificationAlertsInfoFilledMedium.image
        button.setLeftView(imageView, largeContentImage: imageView.image)
        verify(view: button, contentSizeCategories: [.unspecified])
    }

    func testIsHighlighted() {
        let button = TextFloatingActionButton(text: "Floating action button", accessibilityLabel: "Floating action button")
        button.isHighlighted = true
        verify(view: button, contentSizeCategories: [.unspecified])
    }

    func testIsHighlightedSecondary() {
        let button = TextFloatingActionButton(
            text: "Floating action button",
            accessibilityLabel: "Floating action button",
            theme: .secondary
        )
        button.isHighlighted = true
        verify(view: button, contentSizeCategories: [.unspecified])
    }

    func testChangeTheme() {
        let button = TextFloatingActionButton(text: "Floating action button", accessibilityLabel: "Floating action button")
        let imageView = UIImageView()
        imageView.image = Icon.notificationAlertsInfoFilledMedium.image
        button.setLeftView(imageView, largeContentImage: imageView.image)
        button.theme = .secondary
        verify(view: button, contentSizeCategories: [.unspecified])
    }

    func testChangeThemeHighlighted() {
        let button = TextFloatingActionButton(text: "Floating action button", accessibilityLabel: "Floating action button")
        let imageView = UIImageView()
        imageView.image = Icon.notificationAlertsInfoFilledMedium.image
        button.setLeftView(imageView, largeContentImage: imageView.image)
        button.theme = .secondary
        button.isHighlighted = true
        verify(view: button, contentSizeCategories: [.unspecified])
    }

    func testChangeThemeAndBack() {
        let button = TextFloatingActionButton(text: "Floating action button", accessibilityLabel: "Floating action button")
        let imageView = UIImageView()
        imageView.image = Icon.notificationAlertsInfoFilledMedium.image
        button.setLeftView(imageView, largeContentImage: imageView.image)
        button.theme = .secondary
        button.theme = .primary
        verify(view: button, contentSizeCategories: [.unspecified])
    }

    func testChangeThemeAndBackHighlighted() {
        let button = TextFloatingActionButton(text: "Floating action button", accessibilityLabel: "Floating action button")
        let imageView = UIImageView()
        imageView.image = Icon.notificationAlertsInfoFilledMedium.image
        button.setLeftView(imageView, largeContentImage: imageView.image)
        button.theme = .secondary
        button.theme = .primary
        button.isHighlighted = true
        verify(view: button, contentSizeCategories: [.unspecified])
    }
}
