import UIKit

/**
 A labeled checkbox.

 While we don't need to store new data over its superclass, the implementation of ThumbprintPlayground requires it to be its own, non-generic class.

 If Thumbprint playground changes or the Swift type system allows for orthogonal conditional extension implementations of the same protocol for a generic type
 then this class can be removed and replaced with an extension and a `typealias`
 */
public final class LabeledCheckbox: LabeledControl<Checkbox> {
    var checkBoxSize: CGFloat {
        get {
            rootControl.checkBoxSize
        }

        set {
            // This may require a revision of the layout so we can't just redirect.
            guard newValue != checkBoxSize else {
                return
            }

            rootControl.checkBoxSize = newValue
            setNeedsUpdateConstraints()
        }
    }

    public var mark: Checkbox.Mark {
        get {
            rootControl.mark
        }

        set {
            rootControl.mark = newValue
        }
    }
}
