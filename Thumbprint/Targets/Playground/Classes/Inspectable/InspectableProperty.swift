import UIKit

/// A protocol supplying the information needed to construct
/// an InspectablePropertyView for a given inspectable property.
protocol InspectableProperty: AnyObject {
    /// The view responsible for controlling the input view.
    var controlView: UIView { get }

    /// Title of the property, to be displayed in the inspector.
    var title: String? { get set }
}
