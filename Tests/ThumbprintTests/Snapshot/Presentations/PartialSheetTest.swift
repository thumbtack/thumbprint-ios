@testable import Thumbprint
import UIKit
import XCTest

// Sheets are not presented for some reason maybe because it's testing in SPM

class PartialSheetTest: SnapshotTestCase {
    // TODO: (mkaissi) https://thumbtack.atlassian.net/browse/MINF-1952 fix this test case which broke as part of the move to SPM
//    func testSheetWithSize() {
//        verify(
//            modalViewControllerFactory: {
//                let viewController = SheetWithSizeViewController()
//                viewController.modalPresentationStyle = .custom
//                viewController.transitioningDelegate = Presentation.partialSheet
//                return viewController
//            },
//            sizes: [.default],
//            contentSizeCategories: [.unspecified]
//        )
//    }
//
//    func testSheetWithoutSize() {
//        verify(
//            modalViewControllerFactory: {
//                let viewController = SheetWithoutSizeViewController()
//                viewController.modalPresentationStyle = .custom
//                viewController.transitioningDelegate = Presentation.partialSheet
//                return viewController
//            },
//            sizes: [.default],
//            contentSizeCategories: [.unspecified]
//        )
//    }
//
//    func testSheetWithSizeAndDragger() {
//        verify(
//            modalViewControllerFactory: {
//                let viewController = SheetWithSizeViewController()
//                viewController.modalPresentationStyle = .custom
//                viewController.transitioningDelegate = Presentation.partialSheet
//                viewController.partialSheetPresentationController?.isGrabberViewHidden = false
//                return viewController
//            },
//            sizes: [.default],
//            contentSizeCategories: [.unspecified]
//        )
//    }
//
//    func testSheetWithoutSizeWithDragger() {
//        verify(
//            modalViewControllerFactory: {
//                let viewController = SheetWithoutSizeViewController()
//                viewController.modalPresentationStyle = .custom
//                viewController.transitioningDelegate = Presentation.partialSheet
//                viewController.partialSheetPresentationController?.isGrabberViewHidden = false
//                return viewController
//            },
//            sizes: [.default],
//            contentSizeCategories: [.unspecified]
//        )
//    }
}

private class SheetWithSizeViewController: UIViewController {
    let label: Label = {
        let result = Label(textStyle: .text1, adjustsFontForContentSizeCategory: true)
        result.text = "This view controller sets its own preferred content size depending the contents of this label."
        result.numberOfLines = 0
        return result
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview().inset(Space.three)
        }
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        updatePreferredContentSize(with: size.width)
    }

    @objc
    private func toggleDoubleHeight(sender: UISwitch) {
        updatePreferredContentSize(with: view.bounds.width)
    }

    private func updatePreferredContentSize(with width: CGFloat) {
        // Manually calculate the preferred content size
        let labelWidth: CGFloat = width - Space.three - Space.three
        let labelHeight: CGFloat = label.sizeThatFits(CGSize(width: labelWidth, height: .infinity)).height
        let contentHeight: CGFloat = Space.three + labelHeight + Space.three

        preferredContentSize = CGSize(width: width, height: contentHeight)
    }
}

private class SheetWithoutSizeViewController: UIViewController {
    let label = Label(textStyle: .text1, adjustsFontForContentSizeCategory: true)

    override func viewDidLoad() {
        super.viewDidLoad()

        label.text = "This view controller does not set its own preferred content size."
        label.numberOfLines = 0

        view.backgroundColor = .white

        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(Space.three)
        }
    }
}
