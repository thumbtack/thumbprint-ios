import UIKit

public final class ShadowCard: UIView {
    /// Main content view of the card.
    ///
    /// If subviews should inherit the rounded corners of the card,
    /// add them as subviews of `mainView` and then set
    /// `mainView.clipsToBounds = true`.
    public let mainView: UIView

    private let shadowImageView: UIImageView

    public var isHighlighted: Bool {
        didSet {
            mainView.backgroundColor = isHighlighted ? Color.gray300 : Color.white
        }
    }

    public init(shadowImage: UIImage = Shadow.roundedShadow300) {
        self.shadowImageView = UIImageView(image: shadowImage)
        self.mainView = UIView()
        self.isHighlighted = false

        super.init(frame: .null)

        super.addSubview(shadowImageView)
        shadowImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        mainView.backgroundColor = Color.white
        mainView.layer.cornerRadius = 4
        mainView.clipsToBounds = true
        super.addSubview(mainView)
        mainView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func addSubview(_ view: UIView) {
        // Add subviews to mainView so that square corners are clipped.
        mainView.addSubview(view)
    }
}
