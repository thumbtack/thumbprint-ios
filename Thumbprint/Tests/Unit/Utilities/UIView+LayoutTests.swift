import Thumbprint
import XCTest

class UIView_LayoutTests: UnitTestCase {
    //  Tests that snapping to all edges with an inset produces the expected behavior.
    func testSnapToAllEdges() {
        let inset = CGFloat(5.0)
        let superviewSize = CGFloat(100.0)
        let superview = UIView(frame: CGRect(x: 0.0, y: 0.0, width: superviewSize, height: superviewSize))
        let view = UIView()
        superview.addSubview(view)

        view.snapToSuperview(edges: .all, inset: inset)
        superview.layoutIfNeeded()

        XCTAssertEqual(view.frame, CGRect(x: inset, y: inset, width: superviewSize - 2.0 * inset, height: superviewSize - 2.0 * inset))
    }

    //  Tests that layout happens as expected for three edges (in this case leading, top and bottom), also tests
    //  that RTL behavior is as expected.
    func testThreeEdgesSnapped() {
        let inset = CGFloat(5.0)
        let superviewSize = CGFloat(100.0)
        let superview = UIView(frame: CGRect(x: 0.0, y: 0.0, width: superviewSize, height: superviewSize))
        let view = UIView()
        superview.addSubview(view)
        superview.semanticContentAttribute = .forceLeftToRight

        view.snapToSuperview(edges: [.vertical, .leading], inset: inset)
        view.widthAnchor.constraint(equalToConstant: superviewSize * 0.5).isActive = true
        superview.layoutIfNeeded()

        XCTAssertEqual(view.frame, CGRect(x: inset, y: inset, width: superviewSize * 0.5, height: superviewSize - 2.0 * inset))

        //  Bonus: Test RTL behavior.
        superview.semanticContentAttribute = .forceRightToLeft
        superview.layoutIfNeeded()

        XCTAssertEqual(view.frame, CGRect(x: superviewSize * 0.5 - inset, y: inset, width: superviewSize * 0.5, height: superviewSize - 2.0 * inset))
    }

    //  Tests that a wide aspect ratio does as expected.
    func testWideAspectRatio() {
        let height = CGFloat(50.0)
        let view = UIView()
        let heightConstraint = view.heightAnchor.constraint(equalToConstant: height)
        heightConstraint.isActive = true

        let wideAspectRatio = CGFloat(1.5)
        view.enforce(aspectRatio: wideAspectRatio)

        XCTAssertEqual(view.systemLayoutSizeFitting(.zero), CGSize(width: height * wideAspectRatio, height: height))
    }

    //  Tests that a narrow aspect ratio does as expected.
    func testNarrowAspectRatio() {
        let height = CGFloat(50.0)
        let view = UIView()
        let heightConstraint = view.heightAnchor.constraint(equalToConstant: height)
        heightConstraint.isActive = true

        let narrowAspectRatio = CGFloat(0.8)
        view.enforce(aspectRatio: narrowAspectRatio)

        XCTAssertEqual(view.systemLayoutSizeFitting(.zero), CGSize(width: height * narrowAspectRatio, height: height))
    }
}
