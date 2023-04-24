// import ThumbprintResources
import UIKit

/// An icon only floating action button

public class IconFloatingActionButton: Control {
    public struct Theme: Equatable {
        let backgroundColor: UIColor
        let borderColor: UIColor
        let tintColor: UIColor
        let highlightedBackgroundColor: UIColor
        let highlightedBorderColor: UIColor

        public static let primary = IconFloatingActionButton.Theme(
            backgroundColor: Color.blue,
            borderColor: Color.blue,
            tintColor: Color.white,
            highlightedBackgroundColor: Color.blue500,
            highlightedBorderColor: Color.blue500
        )

        public static let secondary = IconFloatingActionButton.Theme(
            backgroundColor: Color.white,
            borderColor: UIAccessibility.isInvertColorsEnabled ? Color.black300 : Color.gray,
            tintColor: Color.blue,
            highlightedBackgroundColor: Color.white,
            highlightedBorderColor: Color.blue
        )

        public init(backgroundColor: UIColor,
                    borderColor: UIColor,
                    tintColor: UIColor,
                    highlightedBackgroundColor: UIColor,
                    highlightedBorderColor: UIColor) {
            self.backgroundColor = backgroundColor
            self.borderColor = borderColor
            self.tintColor = tintColor
            self.highlightedBackgroundColor = highlightedBackgroundColor
            self.highlightedBorderColor = highlightedBorderColor
        }
    }

    private let iconImageView: UIImageView
    private let contentView = UIView()
    private let shadowImageView: UIImageView = {
        let image = UIImage(named: "iconFabShadow", in: Bundle.thumbprint, compatibleWith: nil)! // swiftlint:disable:this force_unwrapping
        return UIImageView(image: image)
    }()

    public private(set) var icon: UIImage? {
        get {
            iconImageView.image
        }
        set {
            if iconImageView.image !== newValue {
                iconImageView.image = newValue
                setNeedsLayout()
            }
        }
    }

    public func setIcon(_ icon: UIImage, accessibilityLabel: String) {
        assert(!accessibilityLabel.isEmpty, "Please provide a non-empty accessibility label when setting an icon image.")
        self.icon = icon
        self.accessibilityLabel = accessibilityLabel
        if #available(iOS 13.0, *) {
            largeContentImage = icon
            largeContentTitle = accessibilityLabel
        }
    }

    public var theme: Theme {
        didSet {
            setupTheme()
        }
    }

    public override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                contentView.backgroundColor = theme.highlightedBackgroundColor
                contentView.layer.borderColor = theme.highlightedBorderColor.cgColor
            } else {
                contentView.backgroundColor = theme.backgroundColor
                contentView.layer.borderColor = theme.borderColor.cgColor
            }
        }
    }

    public init(icon: UIImage, accessibilityLabel: String, theme: IconFloatingActionButton.Theme = .primary) {
        assert(!accessibilityLabel.isEmpty, "Please provide a non-empty accessibility label when initializing an icon floating action button.")
        self.iconImageView = UIImageView()
        iconImageView.image = icon
        self.theme = theme
        super.init(frame: .null)

        if #available(iOS 13.0, *) {
            showsLargeContentViewer = true
            largeContentTitle = accessibilityLabel
            largeContentImage = icon
            addInteraction(UILargeContentViewerInteraction())
        }

        self.accessibilityLabel = accessibilityLabel
        setupView()
        setupTheme()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        contentView.layer.borderWidth = 2
        contentView.layer.cornerRadius = intrinsicContentSize.height / 2
        contentView.isUserInteractionEnabled = false

        addSubview(shadowImageView)
        shadowImageView.contentMode = .center
        shadowImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

        contentView.addSubview(iconImageView)
        iconImageView.contentMode = .center
        iconImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

        addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    private func setupTheme() {
        contentView.backgroundColor = theme.backgroundColor
        iconImageView.tintColor = theme.tintColor
        contentView.layer.borderColor = theme.borderColor.cgColor
    }

    public override var intrinsicContentSize: CGSize {
        CGSize(width: 56, height: 56)
    }
}
