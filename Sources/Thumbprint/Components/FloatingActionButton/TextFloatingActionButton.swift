// import ThumbprintResources
import UIKit

/// A floating action button with text and the
/// option to add a view to the left of it

public class TextFloatingActionButton: Control {
    public struct Theme: Equatable {
        let backgroundColor: UIColor
        let borderColor: UIColor
        let tintColor: UIColor
        let highlightedBackgroundColor: UIColor
        let highlightedBorderColor: UIColor
        let height: CGFloat
        let horizontalPadding: CGFloat
        let iconTextSpacing: CGFloat
        let textStyle: Font.TextStyle
        let shadowImage: UIImage?

        public static let primary = TextFloatingActionButton.Theme(
            backgroundColor: Color.blue,
            borderColor: Color.blue,
            tintColor: Color.white,
            highlightedBackgroundColor: Color.blue500,
            highlightedBorderColor: Color.blue500
        )

        public static let secondary = TextFloatingActionButton.Theme(
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
                    highlightedBorderColor: UIColor,
                    textStyle: Font.TextStyle = .title6,
                    shadowImage: UIImage? = UIImage(named: "textFabShadow", in: Bundle.thumbprint, compatibleWith: nil),
                    height: CGFloat = 44,
                    horizontalPadding: CGFloat = Space.three,
                    iconTextSpacing: CGFloat = Space.two) {
            self.backgroundColor = backgroundColor
            self.borderColor = borderColor
            self.tintColor = tintColor
            self.highlightedBackgroundColor = highlightedBackgroundColor
            self.highlightedBorderColor = highlightedBorderColor
            self.textStyle = textStyle
            self.shadowImage = shadowImage
            self.height = height
            self.horizontalPadding = horizontalPadding
            self.iconTextSpacing = iconTextSpacing
        }
    }

    private let shadowImageView: UIImageView

    private let titleLabel: Label
    private let contentStackView: UIStackView
    private let contentView = UIView()

    public private(set) var text: String? {
        get {
            titleLabel.text
        }
        set {
            titleLabel.text = newValue
            setNeedsLayout()
        }
    }

    public func setText(_ text: String?, accessibilityLabel: String) {
        assert(!accessibilityLabel.isEmpty, "Please provide a non-empty accessibility label when setting the text.")
        self.text = text
        if #available(iOS 13.0, *) {
            self.largeContentTitle = text
        }
        self.accessibilityLabel = accessibilityLabel
    }

    public private(set) var leftView: UIView? {
        didSet {
            oldValue?.removeFromSuperview()
            guard let leftView = leftView else {
                return
            }
            contentStackView.insertArrangedSubview(leftView, at: 0)
            setupTheme()
            setNeedsLayout()
        }
    }

    public func setLeftView(_ view: UIView, largeContentImage: UIImage?) {
        if #available(iOS 13.0, *) {
            self.largeContentImage = largeContentImage
        }
        leftView = view
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

    public init(
        text: String,
        accessibilityLabel: String,
        theme: TextFloatingActionButton.Theme = .primary
    ) {
        assert(!accessibilityLabel.isEmpty, "Please provide a non-empty accessibility label when initializing a text floating action button.")

        self.theme = theme
        self.shadowImageView = UIImageView(image: theme.shadowImage)

        self.titleLabel = Label(textStyle: theme.textStyle, adjustsFontForContentSizeCategory: false)
        titleLabel.text = text
        titleLabel.textAlignment = .center
        titleLabel.setContentHuggingPriority(.required, for: .horizontal)
        titleLabel.setContentCompressionResistancePriority(.required, for: .horizontal)

        self.contentStackView = UIStackView()
        contentStackView.axis = .horizontal
        contentStackView.spacing = theme.iconTextSpacing
        contentStackView.alignment = .center

        super.init(frame: .null)

        if #available(iOS 13.0, *) {
            showsLargeContentViewer = true
            largeContentTitle = text
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
        shadowImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        contentView.addSubview(contentStackView)
        contentStackView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(theme.horizontalPadding)
            make.centerY.equalToSuperview()
        }

        contentStackView.addArrangedSubview(titleLabel)

        addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    private func setupTheme() {
        contentView.backgroundColor = theme.backgroundColor
        titleLabel.textColor = theme.tintColor
        leftView?.tintColor = theme.tintColor
        contentView.layer.borderColor = theme.borderColor.cgColor
    }

    public override var intrinsicContentSize: CGSize {
        CGSize(width: UIView.noIntrinsicMetric, height: theme.height)
    }
}
