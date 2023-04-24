import Foundation
// import ThumbprintResources
import UIKit

public enum Shadow {
    /**
     * A collection of Thumbprint-compliant shadow tokens.
     *
     * The element of each tuple maps over to an analagous shadow property on CALayer.
     *
     * DISCLAIMER: CALayer Shadows are known for being expensive, so use the pre-rasterized
     * shadow images whenever possible.  If you have a case where you do need to use these tokens
     * directly, then please also utilize CALayer.shadowPath to mitigate some of this cost.
     */

    public typealias Token = (opacity: Float, radius: CGFloat, offset: CGSize)

    public static let shadow100Token: Token = (0.1, 3, CGSize(width: 0, height: 1))
    public static let shadow200Token: Token = (0.15, 4, CGSize(width: 0, height: 2))
    public static let shadow300Token: Token = (0.15, 7, CGSize(width: 0, height: 2))
    public static let shadow400Token: Token = (0.2, 10, CGSize(width: 0, height: 2))

    /**
     * A collection of Thumbprint-compliant shadow images.
     *
     * These images already have their cap insets and alignment rect insets
     * pre-configured.  To use these, put one of the shadow images inside a
     * UIImageView, ensure the UIImageView is behind the view you're shadowing,
     * and configure the UIImageView's layout constraints to exactly match the
     * shadowed view.
     *
     * If you are using manual layout (e.g. setting frames directly in layoutSubviews()),
     * use the `UIView.alignmentRect(forFrame:)` method to correctly calculate the
     * target frame for the UIImageView.
     */

    // MARK: - Regular shadows

    // swiftlint:disable force_unwrapping

    /// Shadow with blur radius: 3pt, opacity: 10%, vertical alignment offset 1pt, cornerRadius: 0
    public static let shadow100 = UIImage(named: "shadow100", in: Bundle.thumbprint, compatibleWith: nil)!

    /// Shadow with blur radius: 4pt, opacity: 15%, vertical alignment offset 2pt, cornerRadius: 0
    public static let shadow200 = UIImage(named: "shadow200", in: Bundle.thumbprint, compatibleWith: nil)!

    /// Shadow with blur radius: 7pt, opacity: 15%, vertical alignment offset 2pt, cornerRadius: 0
    public static let shadow300 = UIImage(named: "shadow300", in: Bundle.thumbprint, compatibleWith: nil)!

    /// Shadow with blur radius: 10pt, opacity: 20%, vertical alignment offset 2pt, cornerRadius: 0
    public static let shadow400 = UIImage(named: "shadow400", in: Bundle.thumbprint, compatibleWith: nil)!

    // MARK: - Rounded shadows (4pt)

    /// Shadow with blur radius: 3pt, opacity: 10%, vertical alignment offset 1pt, cornerRadius: 4
    public static let roundedShadow100 = UIImage(named: "roundedShadow100", in: Bundle.thumbprint, compatibleWith: nil)!

    /// Shadow with blur radius: 4pt, opacity: 15%, vertical alignment offset 2pt, cornerRadius: 4
    public static let roundedShadow200 = UIImage(named: "roundedShadow200", in: Bundle.thumbprint, compatibleWith: nil)!

    /// Shadow with blur radius: 7pt, opacity: 15%, vertical alignment offset 2pt, cornerRadius: 4
    public static let roundedShadow300 = UIImage(named: "roundedShadow300", in: Bundle.thumbprint, compatibleWith: nil)!

    /// Shadow with blur radius: 10pt, opacity: 20%, vertical alignment offset 2pt, cornerRadius: 4
    public static let roundedShadow400 = UIImage(named: "roundedShadow400", in: Bundle.thumbprint, compatibleWith: nil)!

    // swiftlint:enable force_unwrapping
}
