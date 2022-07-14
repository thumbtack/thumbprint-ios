@testable import Thumbprint
import UIKit

import XCTest

class PillTest: SnapshotTestCase {
    var stackView: UIStackView!

    override func setUp() {
        super.setUp()
        stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 8
    }

    override func tearDown() {
        stackView = nil

        super.tearDown()
    }

    func testBlankPills() {
        let defaultPill = Pill()
        stackView.addArrangedSubview(defaultPill)

        for theme in Pill.Theme.allPredefined {
            let pill = Pill()
            pill.theme = theme
            stackView.addArrangedSubview(pill)
        }

        verify(view: stackView)
    }

    func testPillsWithTextOnly() {
        let defaultPill = Pill()
        defaultPill.text = "Default"
        stackView.addArrangedSubview(defaultPill)

        for theme in Pill.Theme.allPredefined {
            let pill = Pill()
            pill.theme = theme
            pill.text = "\(theme.name ?? "Wrong")"
            stackView.addArrangedSubview(pill)
        }

        verify(view: stackView)
    }

    func testPillsWithIconAndText() {
        let defaultPill = Pill()
        defaultPill.text = "Default"
        defaultPill.image = Icon.notificationAlertsInfoFilledMedium.image
        stackView.addArrangedSubview(defaultPill)

        for theme in Pill.Theme.allPredefined {
            let pill = Pill()
            pill.theme = theme
            pill.image = Icon.notificationAlertsInfoFilledMedium.image
            pill.text = "\(theme.name ?? "Wrong")"
            stackView.addArrangedSubview(pill)
        }

        verify(view: stackView)
    }

    //  Verifies that the pills look right when expanded beyond their content hugging.
    func testPillsExpanded() {
        stackView.alignment = .fill
        let defaultPill = Pill()
        defaultPill.text = "Default"
        defaultPill.image = Icon.notificationAlertsInfoFilledMedium.image
        defaultPill.setContentHuggingPriority(.defaultLow, for: .horizontal)
        stackView.addArrangedSubview(defaultPill)

        for theme in Pill.Theme.allPredefined {
            let pill = Pill()
            pill.theme = theme
            pill.image = Icon.notificationAlertsInfoFilledMedium.image
            pill.text = "\(theme.name ?? "Wrong")"
            pill.setContentHuggingPriority(.defaultLow, for: .horizontal)
            stackView.addArrangedSubview(pill)
        }

        verify(view: stackView)
    }

    //  Verifies that the pills deal with horizontal compression below intrinsic content width gracefully. We'd
    //  expect the contents to eventually use all space in the pill and then start clipping the label before the
    //  icon.
    func testPillsCompressed() {
        let defaultPill = Pill()
        defaultPill.text = "Default"
        defaultPill.image = Icon.notificationAlertsInfoFilledMedium.image
        stackView.addArrangedSubview(defaultPill)

        for theme in Pill.Theme.allPredefined {
            let pill = Pill()
            pill.theme = theme
            pill.image = Icon.notificationAlertsInfoFilledMedium.image
            pill.text = "\(theme.name ?? "Wrong")"
            stackView.addArrangedSubview(pill)
        }

        //  Shring whe width to around two thirds what it ought to be.
        stackView.widthAnchor.constraint(equalToConstant: stackView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).width * 0.65).isActive = true

        //  Can't do multiple sizes since the test depends on the width we calculate within before the call to verify.
        verify(view: stackView, contentSizeCategories: [.unspecified])
    }

    /**
     This one doubles as a way to produce the iamges for the Thumbprint documentation.
     */
    func testDocumentationPills() {
        let documentationPills: [(title: String, icon: UIImage, theme: Pill.Theme)] = [
            ("Green", Icon.notificationAlertsInfoFilledMedium.image, .green),
            ("Red", Icon.notificationAlertsInfoFilledMedium.image, .red),
            ("Indigo", Icon.notificationAlertsInfoFilledMedium.image, .indigo),
            ("Gray", Icon.notificationAlertsInfoFilledMedium.image, .gray),
            ("Blue", Icon.notificationAlertsInfoFilledMedium.image, .blue),
            ("Yellow", Icon.notificationAlertsInfoFilledMedium.image, .yellow),
            ("Purple", Icon.notificationAlertsInfoFilledMedium.image, .purple),
        ]

        documentationPills.forEach { pillSpec in
            //  Add one with text and one with text and image.
            let textPill = Pill()
            textPill.theme = pillSpec.theme
            textPill.text = pillSpec.title
            stackView.addArrangedSubview(textPill)

            let iconAndTextPill = Pill()
            iconAndTextPill.theme = pillSpec.theme
            iconAndTextPill.image = pillSpec.icon
            iconAndTextPill.text = pillSpec.title
            stackView.addArrangedSubview(iconAndTextPill)
        }

        verify(view: stackView, contentSizeCategories: [.unspecified])
    }
}
