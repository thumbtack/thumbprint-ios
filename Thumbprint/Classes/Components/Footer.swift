import SnapKit
import UIKit

/**
 * Full-width sticky footer
 */
open class Footer: UIView, UIScrollViewDelegate {
    /// The main view to which you add your content.
    public let contentView: UIView

    /// How far above the bottom of the content the shadow starts
    /// transitioning in.
    public var shadowTransitionHeight: CGFloat = 16

    private let shadowImageView: UIImageView

    private var compactHorizontalConstraints: [Constraint] = []
    private var regularHorizontalConstraints: [Constraint] = []

    private static let shadowImage = UIImage(named: "footer-shadow", in: Bundle.thumbprint, compatibleWith: nil)!

    /// When in a .regular horizontal size class, what proportion of the
    /// footer width should be taken up by the content view.
    private static let regularMaxContentWidthProportion: CGFloat = 0.5

    /// Creates and returns a new footer.
    ///
    /// - Parameters:
    ///     - showShadowByDefault: Boolean specifying whether the footer shadow should
    ///         initially be visible. Should typically be set to true if the footer is
    ///         on top of a scroll view or if the page background is a color other than
    ///         white.
    public init(showShadowByDefault: Bool = false) {
        self.contentView = UIView()
        self.shadowImageView = UIImageView(image: Footer.shadowImage)

        super.init(frame: .null)

        backgroundColor = Color.white

        shadowImageView.alpha = showShadowByDefault ? 1.0 : 0.0
        addSubview(shadowImageView)
        shadowImageView.snp.makeConstraints { make in
            make.bottom.equalTo(snp.top)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(Footer.shadowImage.size.height)
        }

        addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(Space.three)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).inset(Space.three)
        }

        self.compactHorizontalConstraints = contentView.snp.prepareConstraints { make in
            make.leading.trailing.equalToSuperview().inset(Space.three)
        }

        self.regularHorizontalConstraints = contentView.snp.prepareConstraints { make in
            make.width.equalToSuperview().multipliedBy(Footer.regularMaxContentWidthProportion)
        }

        setNeedsUpdateConstraints()
    }

    @available(*, unavailable)
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// Set visibility of drop shadow.
    public func setShadow(visible: Bool, animated: Bool) {
        UIView.animate(withDuration: animated ? Duration.one : 0) {
            self.shadowImageView.alpha = visible ? 1.0 : 0.0
        }
    }

    /// To have the footer's shadow visible only when scrolling over content,
    /// either set the footer as your scroll view's delegate or call this method
    /// manually inside your own implementation of scrollViewDidScroll (e.g., if
    /// a view controller must be set as the table view delegate, preventing you
    /// from also setting the footer as the delegate).
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentHeight = scrollView.contentSize.height + scrollView.contentInset.top + scrollView.contentInset.bottom
        let maxVisibleY = scrollView.contentOffset.y + scrollView.bounds.height

        let unboundedShadowAlpha = (contentHeight - maxVisibleY - shadowTransitionHeight) / shadowTransitionHeight

        // 1.0 when still have at least `transitionHeight` of content remaining to scroll down
        // 0.0 when scrolled to/past bottom of content.
        let shadowAlpha = max(CGFloat(0.0), min(unboundedShadowAlpha, CGFloat(1.0)))

        shadowImageView.alpha = shadowAlpha
    }

    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        if traitCollection.horizontalSizeClass != previousTraitCollection?.horizontalSizeClass {
            setNeedsUpdateConstraints()
        }
    }

    public override func updateConstraints() {
        switch traitCollection.horizontalSizeClass {
        case .regular:
            compactHorizontalConstraints.forEach { $0.deactivate() }
            regularHorizontalConstraints.forEach { $0.activate() }
        case .compact, .unspecified:
            fallthrough
        @unknown default:
            regularHorizontalConstraints.forEach { $0.deactivate() }
            compactHorizontalConstraints.forEach { $0.activate() }
        }

        super.updateConstraints()
    }
}
