import UIKit

public extension UIView {
    /**
     An option set for we can use when calling our utility methods to easily snap several edges of a view against
     another view, usually its superview.
     */
    struct SnapEdges: OptionSet {
        public let rawValue: Int

        public init(rawValue: Int) {
            self.rawValue = rawValue
        }

        public static let top = SnapEdges(rawValue: 1 << 0)
        public static let bottom = SnapEdges(rawValue: 1 << 1)
        public static let leading = SnapEdges(rawValue: 1 << 2)
        public static let trailing = SnapEdges(rawValue: 1 << 3)

        //  Snap both sides in the horizontal axis. Declared to facilitate clarity of intent.
        public static let horizontal: SnapEdges = [.leading, .trailing]

        //  Snap both sides in the vertical axis. Declared to facilitate clarity of intent.
        public static let vertical: SnapEdges = [.top, .bottom]

        //  Snap all sides.
        public static let all: SnapEdges = [.top, .bottom, .leading, .trailing]
    }

    /**
     Returns a set of constraints that snap the calling view edges to its superview's for the given edges, optionally
     configured with a common inset.

     Use this method instead of `snapToSuperview(edges:inset:)` when you want to store the constraints and/or
     manage them manually in any way.
     - Precondition: The calling view has a superview.
     - Parameter edges: Which edges to produce snapping constraints for.
     - Parameter inset: A common inset for the produced constraints. Defaults to 0.
     - Returns: An array containing all the layout constraints that enforce the given parameters.
     */
    func constraintsEqualToSuperview(edges: SnapEdges, inset: CGFloat = 0.0) -> [NSLayoutConstraint] {
        guard let superview = superview else {
            preconditionFailure("Cannot create constraints against superview if there is no superview")
        }

        var results = [NSLayoutConstraint]()

        if edges.contains(.leading) {
            results.append(leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: inset))
        }

        if edges.contains(.trailing) {
            results.append(superview.trailingAnchor.constraint(equalTo: trailingAnchor, constant: inset))
        }

        if edges.contains(.top) {
            results.append(topAnchor.constraint(equalTo: superview.topAnchor, constant: inset))
        }

        if edges.contains(.bottom) {
            results.append(superview.bottomAnchor.constraint(equalTo: bottomAnchor, constant: inset))
        }

        return results
    }

    /**
     Builds up and activates the constraints that snap the calling view to its superview for the given edges.

     Additionally turns off `translatesAutoresizingMaskIntoConstraints` to ensure that the layout behavior of the
     view will be as expected after calling this method.
     - Precondition: The calling view has a superview.
     - Parameter edges: Which edges to produce snapping constraints for.
     - Parameter inset: A common inset for the produced constraints. Defaults to 0.
     */
    func snapToSuperview(edges: SnapEdges, inset: CGFloat = 0.0) {
        //  If we're doing this we definitely want the flag off.
        translatesAutoresizingMaskIntoConstraints = false

        let constraints = constraintsEqualToSuperview(edges: edges, inset: inset)
        NSLayoutConstraint.activate(constraints)
    }

    /**
     Enforces the given aspect ratio for the calling view.

     Arter calling this method the layout system will lay out this view with the given aspect ratio with a required
     priority. Superviews should make sure that they can accommodate it.

     Don't call again with a different value or you'll get autolayout exceptions.
     - Parameter aspectRatio: The aspect ratio that the returned constraint will enforce. It's the expression of
     x/y, so values greater than 1.0 will enforce a view that is wider than taller and values less than 1.0 and
     above 0.0 will enforce a view that is taller than wider. Pass 0 to make the app crash.
     */
    func enforce(aspectRatio: CGFloat) {
        //  Mostly adding this function because folks are scared of the raw NSLayoutConstraint init method but it's
        //  the only way to build a layout constraint for this.
        translatesAutoresizingMaskIntoConstraints = false
        let layoutConstraint = NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: self, attribute: .height, multiplier: aspectRatio, constant: 0.0)
        layoutConstraint.isActive = true
    }
}
