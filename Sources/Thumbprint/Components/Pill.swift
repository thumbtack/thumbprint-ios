import UIKit

/**
 Implementation of the Thumbprint Pill component.

 See documentation at https://thumbprint.design/components/pill/ios

 Pills often get used, as a UI element, for other purposes beyond simple informative labels so the API presented
 here is a bit more extensive than what is needed for the component's ostensible intended use.
 */
open class Pill: UIView, UIContentSizeCategoryAdjusting {
    // MARK: - Class configuration

    public struct Config {
        public static var defaultHeight: CGFloat = 24.0
        public static var defaultPadding: CGFloat = 12.0
        public static var defaultTextStyle: Font.TextStyle = .title7

        var height: CGFloat
        var padding: CGFloat
        var textStyle: Font.TextStyle

        public init(height: CGFloat = defaultHeight,
                    padding: CGFloat = defaultPadding,
                    textStyle: Font.TextStyle = defaultTextStyle) {
            self.height = height
            self.padding = padding
            self.textStyle = textStyle
        }
    }

    // MARK: - Implementation Views

    public let iconImageView: UIImageView = {
        let result = UIImageView()
        result.setContentHuggingPriority(.required, for: .horizontal)
        result.contentMode = .center
        return result
    }()

    public let label: Label

    public let stackView: UIStackView = {
        let result = UIStackView()
        result.axis = .horizontal
        result.spacing = Space.one
        result.alignment = .center
        return result
    }()

    public var adjustsFontForContentSizeCategory: Bool {
        didSet {
            guard adjustsFontForContentSizeCategory != oldValue else { return }

            label.adjustsFontForContentSizeCategory = adjustsFontForContentSizeCategory
            invalidateIntrinsicContentSize()
        }
    }

    var contentHeight: CGFloat {
        if adjustsFontForContentSizeCategory {
            return Font.scaledValue(config.height, for: label.textStyle)
        } else {
            return config.height
        }
    }

    var sidePadding: CGFloat {
        if adjustsFontForContentSizeCategory {
            return Font.scaledValue(config.padding, for: label.textStyle)
        } else {
            return config.padding
        }
    }

    public struct Theme: Equatable {
        public let backgroundColor: UIColor
        public let contentColor: UIColor
        public let name: String? //  Used by some old legacy logic that stores it.

        public init(backgroundColor: UIColor, contentColor: UIColor, name: String? = nil) {
            self.backgroundColor = backgroundColor
            self.contentColor = contentColor
            self.name = name
        }

        public static let green = Theme(backgroundColor: Color.green100, contentColor: Color.green600, name: Name.green)
        public static let blue = Theme(backgroundColor: Color.blue100, contentColor: Color.blue600, name: Name.blue)
        public static let red = Theme(backgroundColor: Color.red100, contentColor: Color.red600, name: Name.red)
        public static let indigo = Theme(backgroundColor: Color.indigo100, contentColor: Color.indigo600, name: Name.indigo)
        public static let gray = Theme(backgroundColor: Color.gray300, contentColor: Color.black, name: Name.gray)
        public static let yellow = Theme(backgroundColor: Color.yellow100, contentColor: Color.yellow600, name: Name.yellow)
        public static let purple = Theme(backgroundColor: Color.purple100, contentColor: Color.purple600, name: Name.purple)

        //  Theme names, used by legacy stuff (TTLeadStatusItem)
        enum Name {
            static let green = "light_green"
            static let blue = "light_blue"
            static let red = "light_red"
            static let indigo = "light_indigo"
            static let gray = "gray"
            static let yellow = "light_yellow"
            static let purple = "light_purple"
        }

        public static let allPredefined: [Theme] = [.green, .blue, .red, .indigo, .gray, .yellow, .purple]
    }

    public static func theme(for string: String?) -> Theme {
        guard let string = string else { return .gray }

        switch string {
        case Theme.Name.green:
            return .green

        case Theme.Name.blue:
            return .blue

        case Theme.Name.red:
            return .red

        case Theme.Name.indigo:
            return .indigo

        case Theme.Name.yellow:
            return .yellow

        case Theme.Name.purple:
            return .purple

        case Theme.Name.gray:
            return .gray

        default:
            return .gray
        }
    }

    private var pillContentsIntrinsicWidth: CGFloat {
        let arrangedSubviews = stackView.arrangedSubviews
        if arrangedSubviews.isEmpty {
            return 0.0
        } else {
            //  Add up the intrinsic content widths of whatever is in the stack view.
            let intrinsicContentWidths = arrangedSubviews.reduce(0.0) { result, view in
                result + view.intrinsicContentSize.width
            }

            //  Add separator widths if any
            let separatorWidths = CGFloat(arrangedSubviews.count - 1) * stackView.spacing

            return intrinsicContentWidths + separatorWidths
        }
    }

    public override var intrinsicContentSize: CGSize {
        //  Manually calculate width to avoid UIKit inefficiencies.
        let intrinsicContentWidth = 2.0 * sidePadding + pillContentsIntrinsicWidth

        return CGSize(width: intrinsicContentWidth, height: contentHeight)
    }

    // Should always be a `tiny` image
    public var image: UIImage? {
        get {
            iconImageView.image
        }
        set {
            guard iconImageView.image != newValue else {
                return
            }

            if newValue != nil, iconImageView.superview == nil {
                stackView.insertArrangedSubview(iconImageView, at: 0)
            } else if newValue == nil, iconImageView.superview != nil {
                iconImageView.removeFromSuperview()
            }

            iconImageView.image = newValue
            invalidateIntrinsicContentSize()
            setNeedsLayout()
        }
    }

    public var text: String? {
        get {
            label.text
        }
        set {
            guard text != newValue else {
                return
            }

            label.text = newValue
            invalidateIntrinsicContentSize()
        }
    }

    public var theme: Theme = .gray {
        didSet {
            setNeedsLayout()
        }
    }

    public var config = Config() {
        didSet {
            label.textStyle = config.textStyle
            setNeedsLayout()
        }
    }

    public override var forFirstBaselineLayout: UIView {
        label
    }

    public override var forLastBaselineLayout: UIView {
        label
    }

    public init(adjustsFontForContentSizeCategory: Bool = true) {
        self.adjustsFontForContentSizeCategory = adjustsFontForContentSizeCategory
        self.label = Label(textStyle: config.textStyle, adjustsFontForContentSizeCategory: adjustsFontForContentSizeCategory)

        super.init(frame: .null)

        //  Like other display-only types (i.e. UILabel/UIImageView), Pill is just meant for display by default,
        //  so user interaction is off by default as well.
        self.isUserInteractionEnabled = false

        label.textAlignment = .center
        stackView.addArrangedSubview(label)

        iconImageView.snp.makeConstraints { make in
            make.height.equalTo(Icon.Size.tiny.dimension)
            make.width.equalTo(Icon.Size.tiny.dimension).priority(.high)
        }

        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }

        //  Set extremely low compression resistance to the contents so it doesn't interfere with the general
        //  pill sizing/layout based on calculated intrinsicContentSize. Then make sure contents shrink if needed by
        //  overall pill layout size.
        //  Label should clip before icon so it gets an even lower content compression priority.
        label.setContentCompressionResistancePriority(.fittingSizeLevel + 1.0, for: .horizontal)
        iconImageView.setContentCompressionResistancePriority(.fittingSizeLevel + 2.0, for: .horizontal)
        stackView.widthAnchor.constraint(lessThanOrEqualTo: widthAnchor).isActive = true

        //  Default to high hugging/compression resistance since this is meant to strongly size with its contents.
        setContentHuggingPriority(.defaultHigh, for: .vertical)
        setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        setContentHuggingPriority(.defaultHigh, for: .horizontal)
        setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
    }

    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        return intrinsicContentSize
    }

    @available(*, unavailable)
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open override func layoutSubviews() {
        super.layoutSubviews()

        //  Fully round up the smaller side (should be the sides almost always but if we ever do icon-only pills
        //  that may not remain true).
        let backgroundLayer = layer
        backgroundLayer.cornerRadius = min(backgroundLayer.bounds.height, backgroundLayer.bounds.width) * 0.5

        //  Apply content color.
        backgroundColor = theme.backgroundColor
        label.textColor = theme.contentColor
        iconImageView.tintColor = theme.contentColor
    }

    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        if adjustsFontForContentSizeCategory, previousTraitCollection?.preferredContentSizeCategory != traitCollection.preferredContentSizeCategory {
            invalidateIntrinsicContentSize()
            setNeedsLayout()
        }
    }
}
