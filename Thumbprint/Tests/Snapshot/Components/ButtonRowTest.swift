import Thumbprint
import UIKit

class ButtonRowTest: SnapshotTestCase {
    private let buttonTitles: [String: (String, String?)] = [
        "short": ("Title", "Title"),
        "long": ("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam pretium ornare magna et tristique.", "Etiam egestas, metus id dignissim ultrices, odio enim imperdiet est, placerat ullamcorper augue ligula sed odio."),
        "short-primary": ("Title", "Etiam egestas, metus id dignissim ultrices, odio enim imperdiet est, placerat ullamcorper augue ligula sed odio."),
        "short-secondary": ("Etiam egestas, metus id dignissim ultrices, odio enim imperdiet est, placerat ullamcorper augue ligula sed odio.", "Title"),
    ]
    private let distributions: [ButtonRow.Distribution] = [
        .equal,
        .emphasis,
        .minimal,
    ]

    func testAll() {
        let buttonRow = ButtonRow(leftButton: Button(theme: .tertiary, adjustsFontForContentSizeCategory: false), rightButton: Button(adjustsFontForContentSizeCategory: false))

        distributions.forEach { distribution in
            buttonRow.distribution = distribution

            buttonTitles.forEach {
                let (buttonTitleIdentifier, (primaryTitle, secondaryTitle)) = $0

                buttonRow.rightButton.title = primaryTitle
                buttonRow.leftButton.title = secondaryTitle

                verify(view: buttonRow,
                       identifier: "\(distribution)_\(buttonTitleIdentifier)",
                       sizes: .allWithIntrinsicHeight + [.size(width: 1024, height: .intrinsic)],
                       contentSizeCategories: [.unspecified])
            }
        }
    }
}
