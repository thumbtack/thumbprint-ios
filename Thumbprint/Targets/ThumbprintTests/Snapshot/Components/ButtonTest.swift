import Thumbprint
import UIKit

class ButtonTest: SnapshotTestCase {
    private let themes: [String: (theme: Button.Theme, size: Button.Size)] = [
        "Primary": (theme: .primary, size: .default),
        "Secondary": (theme: .secondary, size: .default),
        "Tertiary": (theme: .tertiary, size: .default),
        "Caution": (theme: .caution, size: .default),
        "Solid": (theme: .solid, size: .default),
        "Text": (theme: .text, size: .text),
        "Link": (theme: .link, size: .text),
    ]

    private let sizes: [String: (size: Button.Size, exampleTheme: Button.Theme)] = [
        "default": (size: .default, exampleTheme: .primary),
        "small": (size: .small, exampleTheme: .primary),
        "text": (size: .text, exampleTheme: .link),
    ]

    private let icons: [String: Button.Icon?] = [
        "no icon": nil,
        "leading": Button.Icon(.leading, image: Icon.notificationAlertsInfoFilledMedium.image),
        "trailing": Button.Icon(.trailing, image: Icon.navigationCaretRightMedium.image),
    ]

    private var button: Button!

    override func tearDown() {
        button = nil
        super.tearDown()
    }

    func testThemes() {
        themes.forEach { themeIdentifier, buttonConfig in
            icons.forEach { iconIdentifier, iconConfig in
                let size = WindowSize.intrinsic

                func buttonMaker(postfix: String?) -> Button {
                    let button = Button(theme: buttonConfig.theme, size: buttonConfig.size)
                    var title = "\(themeIdentifier) \(iconIdentifier)"
                    if let postfix = postfix {
                        title += " " + postfix
                    }
                    button.title = title
                    button.icon = iconConfig
                    return button
                }

                let stackView = UIStackView()
                stackView.axis = .vertical
                stackView.alignment = .fill
                stackView.spacing = Space.two

                //  Add button in normal state.
                stackView.addArrangedSubview(buttonMaker(postfix: nil))

                //  Add button in highlighted state.
                let highlightedButton = buttonMaker(postfix: "highlighted")
                highlightedButton.isHighlighted = true
                stackView.addArrangedSubview(highlightedButton)

                //  Add button in disabled state.
                let disabledButton = buttonMaker(postfix: "disabled")
                disabledButton.isEnabled = false
                stackView.addArrangedSubview(disabledButton)

                if buttonConfig.theme.loaderTheme != nil {
                    //  Add button in loading state. Title isn't going to show so we don't add identifier.
                    let loadingButton = buttonMaker(postfix: nil)
                    loadingButton.isLoading = true
                    stackView.addArrangedSubview(loadingButton)
                }

                //  Add button with forced shape.
                let shapeButton = buttonMaker(postfix: "shape")
                shapeButton.forceButtonShapesEnabledForTesting = true
                stackView.addArrangedSubview(shapeButton)

                verify(
                    view: stackView,
                    identifier: "\(themeIdentifier)_\(iconIdentifier)",
                    sizes: [size]
                )
            }
        }
    }

    func testSizes() {
        sizes.forEach { sizeIdentifier, buttonConfig in
            icons.forEach { iconIdentifier, iconConfig in
                button = Button(theme: buttonConfig.exampleTheme, size: buttonConfig.size)
                button.title = "Test Button"
                button.icon = iconConfig

                verify(
                    view: button,
                    identifier: "\(sizeIdentifier)_\(iconIdentifier)"
                )
            }
        }
    }

    func testStretchWidth() {
        button = Button(adjustsFontForContentSizeCategory: true)
        button.title = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam pretium ornare magna et tristique."
        button.icon = .init(.leading, image: Icon.notificationAlertsInfoFilledMedium.image)

        verify(
            view: button
        )
    }
}
