import UIKit

/**
 Utilities to facilitate the layout setup in code.

 They do not aim to cover all of the auto layout API, just commonly used patterns that are a drudgery to apply in code or error-prone. For simple setups or
 rarely used ones not covered by these utilities using the regular auto layout API is fine.
 */

// MARK: - View hierarchy setup

public extension UIView {
    /**
     Simple wrapper around `addSubview` that ensures that the new subview will be properly set up for further layout management
     (in other words, turns off `translatesAutoresizingMaskIntoConstraints`).
     - Parameter subview: The subview to add.
     */
    func addManagedSubview(_ subview: UIView) {
        subview.translatesAutoresizingMaskIntoConstraints = false
        addSubview(subview)
    }
}

// MARK: - Common layout types

/**
 For whatever reason UIKit doesn't make UIView and UILayoutGuide implement a common protocol despite them implementing the *exact same API*

 This protocol takes care of that.
 */
public protocol LayoutElement {
    var bottomAnchor: NSLayoutYAxisAnchor { get }
    var centerXAnchor: NSLayoutXAxisAnchor { get }
    var centerYAnchor: NSLayoutYAxisAnchor { get }
    var heightAnchor: NSLayoutDimension { get }
    var leadingAnchor: NSLayoutXAxisAnchor { get }
    var leftAnchor: NSLayoutXAxisAnchor { get }
    var rightAnchor: NSLayoutXAxisAnchor { get }
    var topAnchor: NSLayoutYAxisAnchor { get }
    var trailingAnchor: NSLayoutXAxisAnchor { get }
    var widthAnchor: NSLayoutDimension { get }
}

/**
 An option set for we can use when calling our utility methods to easily snap several edges of a layout element against another's at once.
 */
public struct LayoutEdges: OptionSet {
    public let rawValue: Int

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    public static let top = LayoutEdges(rawValue: 1 << 0)
    public static let bottom = LayoutEdges(rawValue: 1 << 1)
    public static let leading = LayoutEdges(rawValue: 1 << 2)
    public static let trailing = LayoutEdges(rawValue: 1 << 3)

    //  Snap both sides in the horizontal axis. Declared to facilitate clarity of intent.
    public static let horizontal: LayoutEdges = [.leading, .trailing]

    //  Snap both sides in the vertical axis. Declared to facilitate clarity of intent.
    public static let vertical: LayoutEdges = [.top, .bottom]

    //  Snap all sides.
    public static let all: LayoutEdges = [.top, .bottom, .leading, .trailing]
}

/**
 An option set for the x and y axis. Used by layout centering methods
 */
public struct LayoutAxis: OptionSet {
    public let rawValue: Int

    public init(rawValue axis: Int) {
        self.rawValue = axis
    }

    public static let horizontal = LayoutAxis(rawValue: 1 << 0)
    public static let vertical = LayoutAxis(rawValue: 1 << 1)

    public static let both: LayoutAxis = [.horizontal, .vertical]
}

public extension LayoutElement {
    /**
     Basic method to create constraints that snap the caller's given edges against another layout elemet.
     - Parameter layoutElement: The layout element whose edges we're snapping against.
     - Parameter edges: The edges we want to snap.
     - Parameter inset: Inset to apply to the created constraints. Notice that this is an inset not an offset so for `.trailing/.bottom`
     the applied constant will be in opposite direction than for `.leading/.top`
     - Returns: An array with the created constraints, inactive.
     */
    func constraintsEqual(to layoutElement: LayoutElement, edges: LayoutEdges, inset: CGFloat) -> [NSLayoutConstraint] {
        var results = [NSLayoutConstraint]()

        if edges.contains(.leading) {
            results.append(leadingAnchor.constraint(equalTo: layoutElement.leadingAnchor, constant: inset))
        }

        if edges.contains(.trailing) {
            results.append(layoutElement.trailingAnchor.constraint(equalTo: trailingAnchor, constant: inset))
        }

        if edges.contains(.top) {
            results.append(topAnchor.constraint(equalTo: layoutElement.topAnchor, constant: inset))
        }

        if edges.contains(.bottom) {
            results.append(layoutElement.bottomAnchor.constraint(equalTo: bottomAnchor, constant: inset))
        }

        return results
    }
}

extension UIView: LayoutElement {}

extension UILayoutGuide: LayoutElement {}

// MARK: - Snap to edges

public extension UIView {
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
    func constraintsEqualToSuperviewEdges(_ edges: LayoutEdges, inset: CGFloat = 0.0) -> [NSLayoutConstraint] {
        guard let superview = self.superview else {
            preconditionFailure("Cannot create constraints against superview if there is no superview")
        }

        return constraintsEqual(to: superview, edges: edges, inset: inset)
    }

    /**
     Builds up and activates the constraints that snap the calling view to its superview for the given edges.

     Additionally turns off `translatesAutoresizingMaskIntoConstraints` to ensure that the layout behavior of the
     view will be as expected after calling this method.
     - Precondition: The calling view has a superview.
     - Parameter edges: Which edges to produce snapping constraints for.
     - Parameter inset: A common inset for the produced constraints. Defaults to 0.
     */
    func snapToSuperviewEdges(_ edges: LayoutEdges, inset: CGFloat = 0.0) {
        //  If we're doing this we definitely want the flag off.
        translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate(constraintsEqualToSuperviewEdges(edges, inset: inset))
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
    func constraintsEqualToSuperviewMargins(_ margins: LayoutEdges, inset: CGFloat = 0.0) -> [NSLayoutConstraint] {
        guard let superview = self.superview else {
            preconditionFailure("Cannot create constraints against superview if there is no superview")
        }

        return constraintsEqual(to: superview.layoutMarginsGuide, edges: margins, inset: inset)
    }

    /**
     Builds up and activates the constraints that snap the calling view to its superview for the given edges.

     Additionally turns off `translatesAutoresizingMaskIntoConstraints` to ensure that the layout behavior of the
     view will be as expected after calling this method.
     - Precondition: The calling view has a superview.
     - Parameter edges: Which edges to produce snapping constraints for.
     - Parameter inset: A common inset for the produced constraints. Defaults to 0.
     */
    func snapToSuperviewMargins(_ margins: LayoutEdges, inset: CGFloat = 0.0) {
        //  If we're doing this we definitely want the flag off.
        translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate(constraintsEqualToSuperviewMargins(margins, inset: inset))
    }
}

// MARK: - Centering in superview

public extension UIView {
    /**
     Builds and returns constraints to center the calling view into its superview.

     The method will blow up if no superview is set.

     Use this method instead of `centerInSuperview(along:)` when you want to store the constraints and/or
     manage them manually in any way.
     - Parameter axis: The axis we want to center ourselves along in the superview.
     - Returns: An array containing the constraints that produce the desired effect, deactivated.
     */
    func constraintsCenteringInSuperview(along axis: LayoutAxis) -> [NSLayoutConstraint] {
        guard let superview = self.superview else {
            preconditionFailure("Cannot create constraints against superview if there is no superview")
        }

        var results = [NSLayoutConstraint]()

        if axis.contains(.horizontal) {
            results.append(centerXAnchor.constraint(equalTo: superview.centerXAnchor))
        }
        if axis.contains(.vertical) {
            results.append(centerYAnchor.constraint(equalTo: superview.centerYAnchor))
        }

        return results
    }

    /**
     Builds up and activates constraints to center the caller in its superview along the given axis.
     - Parameter axis: The axis we want to center ourselves along in the superview.
     */
    func centerInSuperview(along axis: LayoutAxis) {
        //  If we're doing this we definitely want the flag off.
        translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate(constraintsCenteringInSuperview(along: axis))
    }
}

// MARK: - Aspect ratio

public extension UIView {
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
