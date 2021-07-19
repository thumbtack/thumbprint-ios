@testable import Thumbprint
import UIKit

class LoaderDotsTest: SnapshotTestCase {
    private var snapshotFrameView: UIView!
    override func setUp() {
        super.setUp()

        snapshotFrameView = UIView(frame: .null)
        snapshotFrameView.backgroundColor = Color.white
    }

    override func tearDown() {
        snapshotFrameView = nil
        super.tearDown()
    }

    func testDefault() {
        let loaderDotsView = LoaderDots()
        snapshotFrameView.addManagedSubview(loaderDotsView)
        loaderDotsView.snapToSuperviewEdges(.all)

        verify(view: snapshotFrameView, contentSizeCategories: [.unspecified])
    }

    func testSmall() {
        let loaderDotsView = LoaderDots(size: .small)
        snapshotFrameView.addManagedSubview(loaderDotsView)

        loaderDotsView.snapToSuperviewEdges(.all)

        verify(view: snapshotFrameView, contentSizeCategories: [.unspecified])
    }

    func testMuted() {
        let loaderDotsView = LoaderDots(theme: .muted)
        snapshotFrameView.addManagedSubview(loaderDotsView)

        loaderDotsView.snapToSuperviewEdges(.all)

        verify(view: snapshotFrameView, contentSizeCategories: [.unspecified])
    }

    func testInverse() {
        snapshotFrameView.backgroundColor = Color.blue
        let loaderDotsView = LoaderDots(theme: .inverse)
        snapshotFrameView.addManagedSubview(loaderDotsView)

        loaderDotsView.snapToSuperviewEdges(.all)

        verify(view: snapshotFrameView, contentSizeCategories: [.unspecified])
    }

    func testConstrainedTooLarge() {
        let loaderDotsView = LoaderDots()
        snapshotFrameView.addManagedSubview(loaderDotsView)
        // Note, the constraints should always position the view, but never dictate its size,
        // otherwise it will affect the spacing of the dots and cause it to diverge from the
        // design specs
        loaderDotsView.snapToSuperviewEdges(.all)

        verify(view: snapshotFrameView, contentSizeCategories: [.unspecified])
    }

    func testStoppedHidden() {
        let loaderDotsView = LoaderDots()
        loaderDotsView.hidesOnStop = true
        snapshotFrameView.addManagedSubview(loaderDotsView)
        loaderDotsView.snapToSuperviewEdges(.all)

        loaderDotsView.stop()
        verify(view: snapshotFrameView, contentSizeCategories: [.unspecified])
    }

    func testStoppedVisible() {
        let loaderDotsView = LoaderDots()
        loaderDotsView.hidesOnStop = false
        snapshotFrameView.addManagedSubview(loaderDotsView)
        loaderDotsView.snapToSuperviewEdges(.all)

        loaderDotsView.stop()
        verify(view: snapshotFrameView, contentSizeCategories: [.unspecified])
    }
}
