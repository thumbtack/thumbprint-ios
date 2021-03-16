import UIKit

public extension UIView {
    /**
     This extension is a workaround for http://www.openradar.me/25087688 and should be used for views that are
     part of a UIStackView's `arrangedSubviews` to hide or show them, instead of using the `isHidden` property of
     the view.

     Once UIKit fixes the issue and we drop any version that doesn't have the fix it can be removed.
     */
    var showsInStackView: Bool {
        get {
            assert(
                (superview as? UIStackView)?.arrangedSubviews.contains(self) ?? false,
                "showsInStackView should only be used for views that are part of a UIStackView arrangedSubviews"
            )

            return !isHidden
        }

        set {
            assert(
                (superview as? UIStackView)?.arrangedSubviews.contains(self) ?? false,
                "showsInStackView should only be used for views that are part of a UIStackView arrangedSubviews"
            )

            guard showsInStackView != newValue else {
                return
            }

            isHidden = !newValue
        }
    }
}
