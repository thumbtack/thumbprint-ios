@testable import Thumbprint
import UIKit

class LoaderDotsTest: SnapshotTestCase {
    // TODO: (mkaissi) Fix and re-enable. Seemed to be broken during the change to SPM.
//    private var snapshotFrameView: UIView!
//    override func setUp() {
//        super.setUp()
//
//        snapshotFrameView = UIView(frame: .null)
//        snapshotFrameView.backgroundColor = Color.white
//    }
//
//    override func tearDown() {
//        snapshotFrameView = nil
//        super.tearDown()
//    }
//
//    func testDefault() {
//        let loaderDotsView = LoaderDots()
//        snapshotFrameView.addSubview(loaderDotsView)
//        loaderDotsView.snp.makeConstraints { make in
//            make.edges.equalToSuperview()
//        }
//
//        verify(view: snapshotFrameView, contentSizeCategories: [.unspecified])
//    }
//
//    func testSmall() {
//        let loaderDotsView = LoaderDots(size: .small)
//        snapshotFrameView.addSubview(loaderDotsView)
//
//        loaderDotsView.snp.makeConstraints { make in
//            make.edges.equalToSuperview()
//        }
//
//        verify(view: snapshotFrameView, contentSizeCategories: [.unspecified])
//    }
//
//    func testMuted() {
//        let loaderDotsView = LoaderDots(theme: .muted)
//        snapshotFrameView.addSubview(loaderDotsView)
//
//        loaderDotsView.snp.makeConstraints { make in
//            make.edges.equalToSuperview()
//        }
//
//        verify(view: snapshotFrameView, contentSizeCategories: [.unspecified])
//    }
//
//    func testInverse() {
//        snapshotFrameView.backgroundColor = Color.blue
//        let loaderDotsView = LoaderDots(theme: .inverse)
//        snapshotFrameView.addSubview(loaderDotsView)
//
//        loaderDotsView.snp.makeConstraints { make in
//            make.edges.equalToSuperview()
//        }
//
//        verify(view: snapshotFrameView, contentSizeCategories: [.unspecified])
//    }
//
//    func testConstrainedTooLarge() {
//        let loaderDotsView = LoaderDots()
//        snapshotFrameView.addSubview(loaderDotsView)
//        loaderDotsView.snp.makeConstraints { make in
//            // Note, the constraints should always position the view, but never dictate its size,
//            // otherwise it will affect the spacing of the dots and cause it to diverge from the
//            // design specs
//            make.edges.equalToSuperview()
//        }
//
//        verify(view: snapshotFrameView, contentSizeCategories: [.unspecified])
//    }
//
//    func testStoppedHidden() {
//        let loaderDotsView = LoaderDots()
//        loaderDotsView.hidesOnStop = true
//        snapshotFrameView.addSubview(loaderDotsView)
//        loaderDotsView.snp.makeConstraints { make in
//            make.edges.equalToSuperview()
//        }
//
//        loaderDotsView.stop()
//        verify(view: snapshotFrameView, contentSizeCategories: [.unspecified])
//    }
//
//    func testStoppedVisible() {
//        let loaderDotsView = LoaderDots()
//        loaderDotsView.hidesOnStop = false
//        snapshotFrameView.addSubview(loaderDotsView)
//        loaderDotsView.snp.makeConstraints { make in
//            make.edges.equalToSuperview()
//        }
//
//        loaderDotsView.stop()
//        verify(view: snapshotFrameView, contentSizeCategories: [.unspecified])
//    }
}
