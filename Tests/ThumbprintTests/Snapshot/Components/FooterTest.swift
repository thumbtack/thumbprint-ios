import Thumbprint
import UIKit

class FooterTest: SnapshotTestCase {
    private let buttonTitles: [String: (String, String?)] = [
        "short": ("Title", "Title"),
        "long": ("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam pretium ornare magna et tristique.", "Etiam egestas, metus id dignissim ultrices, odio enim imperdiet est, placerat ullamcorper augue ligula sed odio."),
        "short-primary": ("Title", "Etiam egestas, metus id dignissim ultrices, odio enim imperdiet est, placerat ullamcorper augue ligula sed odio."),
        "short-secondary": ("Etiam egestas, metus id dignissim ultrices, odio enim imperdiet est, placerat ullamcorper augue ligula sed odio.", "Title"),
    ]

    @MainActor func testSafeArea() {
        let factory: () -> UIViewController = {
            let buttonRow = ButtonRow(leftButton: Button(theme: .tertiary, adjustsFontForContentSizeCategory: false), rightButton: Button(adjustsFontForContentSizeCategory: false))
            buttonRow.leftButton.title = "Title"
            buttonRow.rightButton.title = "Title"

            let viewController = UIViewController(nibName: nil, bundle: nil)
            viewController.view.backgroundColor = Color.gray

            let footer = Footer()
            viewController.view.addSubview(footer)
            footer.snp.makeConstraints { make in
                make.leading.bottom.trailing.equalToSuperview()
            }
            footer.contentView.addSubview(buttonRow)
            buttonRow.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }

            return viewController
        }

        verify(viewControllerFactory: factory,
               identifier: "nosafearea",
               contentSizeCategories: [.unspecified])

        verify(viewControllerFactory: factory,
               identifier: "safearea",
               safeArea: UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0),
               contentSizeCategories: [.unspecified])
    }

    @MainActor func testScreenWidths() {
        verify(
            viewControllerFactory: {
                let buttonRow = ButtonRow(leftButton: Button(theme: .tertiary, adjustsFontForContentSizeCategory: false), rightButton: Button(adjustsFontForContentSizeCategory: false))
                buttonRow.leftButton.title = "Title"
                buttonRow.rightButton.title = "Title"

                let viewController = UIViewController(nibName: nil, bundle: nil)
                viewController.view.backgroundColor = Color.gray

                let footer = Footer()
                viewController.view.addSubview(footer)
                footer.snp.makeConstraints { make in
                    make.leading.bottom.trailing.equalToSuperview()
                }
                footer.contentView.addSubview(buttonRow)
                buttonRow.snp.makeConstraints { make in
                    make.edges.equalToSuperview()
                }

                return viewController
            },
            contentSizeCategories: [.unspecified]
        )
    }

    @MainActor func testRegularSizeClass() {
        verify(
            viewControllerFactory: {
                let buttonRow = ButtonRow(leftButton: Button(theme: .tertiary, adjustsFontForContentSizeCategory: false), rightButton: Button(adjustsFontForContentSizeCategory: false))
                buttonRow.leftButton.title = "Title"
                buttonRow.rightButton.title = "Title"

                let viewController = UIViewController(nibName: nil, bundle: nil)
                viewController.view.backgroundColor = Color.gray

                let parentViewController = UIViewController(nibName: nil, bundle: nil)
                parentViewController.addChild(viewController)
                parentViewController.view.addSubview(viewController.view)
                viewController.didMove(toParent: parentViewController)
                parentViewController.setOverrideTraitCollection(
                    UITraitCollection(horizontalSizeClass: .regular),
                    forChild: viewController
                )

                let footer = Footer()
                viewController.view.addSubview(footer)
                footer.snp.makeConstraints { make in
                    make.leading.bottom.trailing.equalToSuperview()
                }
                footer.contentView.addSubview(buttonRow)
                buttonRow.snp.makeConstraints { make in
                    make.edges.equalToSuperview()
                }

                return parentViewController
            },
            contentSizeCategories: [.unspecified]
        )
    }

    @MainActor func testShowShadowByDefault() {
        verify(
            viewControllerFactory: {
                let viewController = UIViewController(nibName: nil, bundle: nil)
                viewController.view.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
                viewController.view.backgroundColor = Color.white

                let footer = Footer(showShadowByDefault: true)
                viewController.view.addSubview(footer)
                footer.snp.makeConstraints { make in
                    make.leading.bottom.trailing.equalToSuperview()
                }

                //  We need some content for the footer to hold its height.
                let button = Button(adjustsFontForContentSizeCategory: true)
                button.title = "Title"
                footer.contentView.addSubview(button)
                button.snp.makeConstraints { make in
                    make.edges.equalToSuperview()
                }

                return viewController
            },
            contentSizeCategories: [.unspecified]
        )
    }
}
