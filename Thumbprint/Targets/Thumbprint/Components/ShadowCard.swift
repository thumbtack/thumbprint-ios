import UIKit

public final class ShadowCard: UIView {
    /// Main content view of the card.
    ///
    /// If subviews should inherit the rounded corners of the card,
    /// add them as subviews of `mainView` and then set
    /// `mainView.clipsToBounds = true`.
    public let contentView: UIView

    private let shadowImageView: UIImageView

    public var isHighlighted: Bool {
        didSet {
            contentView.backgroundColor = isHighlighted ? Color.gray300 : Color.white
        }
    }

    public init(shadowImage: UIImage = Shadow.roundedShadow300) {
        self.shadowImageView = UIImageView(image: shadowImage)
        self.contentView = UIView()
        self.isHighlighted = false

        super.init(frame: .null)

        addManagedSubview(shadowImageView)
        shadowImageView.snapToSuperviewEdges(.all)

        contentView.backgroundColor = Color.white
        contentView.layer.cornerRadius = 4
        contentView.clipsToBounds = true
        addManagedSubview(contentView)
        contentView.snapToSuperviewEdges(.all)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
