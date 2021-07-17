import UIKit

/**
 A labeled radio button.

 While we don't need to store new data over its superclass, the implementation of ThumbprintPlayground requires it to be its own, non-generic class.

 If Thumbprint playground changes or the Swift type system allows for orthogonal conditional extension implementations of the same protocol for a generic type
 then this class can be removed and replaced with an extension and a `typealias`
 */
public final class LabeledRadio: LabeledControl<Radio> {
    // That's it folks, that's the class.
}
