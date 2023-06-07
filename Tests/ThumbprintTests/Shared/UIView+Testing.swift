import UIKit

extension UIView {
    enum LayoutAmbiguity {
        case unambiguous
        case ambiguous(view: UIView)
    }

    /**
     Use this to verify if the view or any of its descendants has an ambiguous layout. `UIView.hasAmbiguousLayout`
     doesn't dig in the hierarchy so a full accounting of the presence of ambiguity must run through the view tree.
     - Returns: True if self or any descendant view has an ambiguous layout.
     */
    func verifySubtreeLayoutAmbiguity() -> LayoutAmbiguity {
        //  UIKit will do some weird things with hidden views in UIStackViews) which trigger the verifier despite no
        //  actual layout effect. Since by definition a hidden arranged subview of a stack view doesn't affect layout
        //  we can skip them.
        guard !(isHidden && ((superview as? UIStackView)?.arrangedSubviews.contains(self)) ?? false) else {
            return .unambiguous
        }
        
        if hasAmbiguousLayout {
            return .ambiguous(view: self)
        } else {
            for subview in subviews {
                let subviewVerify = subview.verifySubtreeLayoutAmbiguity()
                if case .ambiguous = subviewVerify {
                    return subviewVerify
                }
            }
        }

        return .unambiguous
    }
}
