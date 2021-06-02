import UIKit

/**
 * Button for forms and in-page interactions
 *
 * Despite its generic name, this class models the specific kind of labeled button. See Thumbprint Documentation on
 * [Buttons](https://thumbprint.design/guide/product/components/button/).
 */
public final class Button: Control, UIContentSizeCategoryAdjusting {
    /// Button theme
    public var theme: Theme {
        didSet {
            if oldValue != theme {
                updateTheme()
            }
        }
    }

    /// Button size
    public var size: Size {
        didSet {
            updateSize()
        }
    }

    /**
     Title of the button.

     Technically this value should never be nil (nor empty) for any button being displayed. The property is left
     optional however to match the impedance with UIKit and most network based models which treat everything as
     optional.
     */
    public var title: String? {
        get {
            titleLabel.text
        }
        set {
            guard newValue != title else { return }
            updateTitle(newValue)
        }
    }

    /**
     Whether the button displays an icon and where.
     */
    public var icon: Icon? {
        didSet {
            guard icon != oldValue else {
                return
            }

            updateSize()
        }
    }

    /// A Boolean value indicating whether the button is in the loading state.
    /// Should only be used with button themes which have a non-nil loaderTheme.
    public var isLoading: Bool {
        didSet {
            guard isLoading != oldValue,
                  let loaderDots = loaderDots
            else { return }

            loaderDots.isHidden = !isLoading
            contentView.isHidden = isLoading

            updateState()
            updateAccessibilityTraits()
        }
    }

    /// A Boolean value indicating whether the button should support Dynamic Type.
    ///
    /// Note: Changing the value of this property after initialization does not
    /// automatically update adjustsFontSizeToFitWidth.
    public var adjustsFontForContentSizeCategory: Bool {
        didSet {
            guard adjustsFontForContentSizeCategory != oldValue else { return }

            titleLabel.adjustsFontForContentSizeCategory = adjustsFontForContentSizeCategory
            invalidateIntrinsicContentSize()
        }
    }

    /// A Boolean value indicating whether the font size should be reduced in order
    /// to fit the title string into the button title’s bounding rectangle.
    /// Defaults to the same value passed into the constructor for adjustsFontForContentSizeCategory.
    public var adjustsFontSizeToFitWidth: Bool {
        get { titleLabel.adjustsFontSizeToFitWidth }
        set { titleLabel.adjustsFontSizeToFitWidth = newValue }
    }

    /// The minimum scale factor supported for the button title’s text.
    public var minimumScaleFactor: CGFloat {
        get { titleLabel.minimumScaleFactor }
        set { titleLabel.minimumScaleFactor = newValue }
    }

    /// A Boolean value indicating whether haptic feedback is enabled on tap.
    /// Should only be used with the primary and secondary button themes.
    public var isHapticFeedbackEnabled: Bool {
        didSet {
            guard isHapticFeedbackEnabled != oldValue else { return }

            if isHapticFeedbackEnabled {
                feedbackGenerator = UIImpactFeedbackGenerator(style: .light)

                addTarget(self, action: #selector(handleHapticFeedbackTouchDown), for: .touchDown)
                addTarget(self, action: #selector(handleHapticFeedbackTap), for: .touchUpInside)

            } else {
                removeTarget(self, action: #selector(handleHapticFeedbackTouchDown), for: .touchDown)
                removeTarget(self, action: #selector(handleHapticFeedbackTap), for: .touchUpInside)
                feedbackGenerator = nil
            }
        }
    }

    public override var isSelected: Bool {
        didSet {
            updateState()
            updateAccessibilityTraits()
        }
    }

    public override var isEnabled: Bool {
        get {
            super.isEnabled && !isLoading
        }
        set {
            super.isEnabled = newValue

            updateState()
            updateAccessibilityTraits()
        }
    }

    public override var isHighlighted: Bool {
        didSet {
            updateState()
        }
    }

    public override var accessibilityLabel: String? {
        get {
            super.accessibilityLabel ?? title
        }
        set {
            super.accessibilityLabel = newValue
        }
    }

    public override var intrinsicContentSize: CGSize {
        var intrinsicWidth = size.contentPadding.width * 2.0 + titleLabel.intrinsicContentSize.width
        if icon != nil {
            intrinsicWidth += size.iconTextSpacing + (iconImageView?.intrinsicContentSize.width ?? 0.0)
        }

        let intrinsicHeight = size.contentPadding.height * 2.0 + titleLabel.intrinsicContentSize.height

        return CGSize(width: intrinsicWidth, height: intrinsicHeight)
    }

    public override func sizeThatFits(_ size: CGSize) -> CGSize {
        let contentWidth = size.width - self.size.contentPadding.width * 2.0
        let contentHeight = size.height - self.size.contentPadding.height * 2.0

        let iconWidthNeeded = icon == .none
            ? 0
            : ((iconImageView?.intrinsicContentSize.width ?? 0.0) + self.size.iconTextSpacing)

        let titleWidthAvailable = contentWidth - iconWidthNeeded
        let titleSizeNeeded = titleLabel.sizeThatFits(CGSize(width: titleWidthAvailable, height: contentHeight))

        return CGSize(
            width: titleSizeNeeded.width +
                iconWidthNeeded +
                self.size.contentPadding.width * 2.0,
            height: titleSizeNeeded.height
        )
    }

    /// Creates and returns a new button with the specified theme and size.
    ///
    /// - Parameters:
    ///   - theme: Thumbprint button theme to use with this button.
    ///   - size: The layout settings for the button
    ///   - adjustsFontForContentSizeCategory: Boolean indicating whether this button
    ///                                        should support Dynamic Type.
    public init(theme: Theme = .primary,
                size: Size = .default,
                adjustsFontForContentSizeCategory: Bool = true) {
        self.theme = theme
        self.size = size
        self.adjustsFontForContentSizeCategory = adjustsFontForContentSizeCategory

        self.contentView = UIStackView()
        self.titleLabel = Label(textStyle: .title6, adjustsFontForContentSizeCategory: adjustsFontForContentSizeCategory)
        self.backgroundImageView = UIImageView()
        self.isLoading = false
        self.isHapticFeedbackEnabled = false

        super.init(frame: .null)

        isAccessibilityElement = true

        addSubview(backgroundImageView)
        backgroundImageView.snapToSuperview(edges: .all)

        // When adjustsFontForContentSizeCategory is true, also ensure text size remains
        // small enough that it fits in button's bounds (since the title is restricted
        // to a single line). Can be set back to false if desired with the mutable
        // Button.adjustsFontSizeToFitWidth property.
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.axis = .horizontal
        contentView.alignment = .center
        contentView.isUserInteractionEnabled = false
        addSubview(contentView)

        //  Center and add content width less than button width in case of tight layout clipping.
        let widthConstraint = contentView.widthAnchor.constraint(lessThanOrEqualTo: widthAnchor)
        let heightConstraint = contentView.heightAnchor.constraint(equalTo: heightAnchor)
        heightConstraint.priority = .defaultHigh
        NSLayoutConstraint.activate([
            contentView.centerXAnchor.constraint(equalTo: centerXAnchor),
            contentView.centerYAnchor.constraint(equalTo: centerYAnchor),
            widthConstraint,
            heightConstraint,
            contentView.heightAnchor.constraint(lessThanOrEqualTo: heightAnchor),
        ])

        //  We allow some expansion of the label beyond the padding on tight layouts but limit it to 2/3 of the
        //  declared padding as to avoid really messing the look of the button. Constant is set in `updateSize()`
        self.maxContentWidthConstraint = widthConstraint

        contentView.addArrangedSubview(titleLabel)
        titleLabel.adjustsFontSizeToFitWidth = adjustsFontForContentSizeCategory
        titleLabel.textAlignment = .center
        titleLabel.baselineAdjustment = .alignCenters
        titleLabel.minimumScaleFactor = 0.5

        //  We set horizontal content compression of the label to very low values as it will be the one to clip if needed.
        titleLabel.setContentCompressionResistancePriority(.fittingSizeLevel - 1.0, for: .horizontal)

        updateTheme()
        updateSize()
        updateAccessibilityTraits()

        if #available(iOS 14.0, *) {
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(buttonShapesEnabledStatusDidChange),
                name: UIAccessibility.buttonShapesEnabledStatusDidChangeNotification,
                object: nil
            )
        }

        //  Default to high vertical clipping/hugging resistance, high horizontal clipping and low horizontal hugging
        setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        setContentHuggingPriority(.defaultLow, for: .horizontal)
        setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        setContentHuggingPriority(.defaultHigh, for: .vertical)
    }

    @available(*, unavailable)
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override var forFirstBaselineLayout: UIView {
        titleLabel
    }

    public override var forLastBaselineLayout: UIView {
        titleLabel
    }

    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        if traitCollection.preferredContentSizeCategory != previousTraitCollection?.preferredContentSizeCategory {
            invalidateIntrinsicContentSize()
        }
    }

    // MARK: - Testing

    /// Used by snapshot tests to forcefully apply the given accessibility setting. Do not use in application code.
    public var forceButtonShapesEnabledForTesting: Bool = false {
        didSet {
            guard forceButtonShapesEnabledForTesting != oldValue else { return }
            buttonShapesEnabledStatusDidChange()
        }
    }

    // MARK: - Private Properties
    private let contentView: UIStackView
    private let titleLabel: Label
    private var iconImageView: UIImageView?
    private let backgroundImageView: UIImageView
    private var loaderDots: LoaderDots?
    private var maxContentWidthConstraint: NSLayoutConstraint?

    private var backgroundImage: UIImage?
    private var activeBackgroundImage: UIImage?
    private var disabledBackgroundImage: UIImage?

    private var feedbackGenerator: UIImpactFeedbackGenerator?

    private var buttonShapesEnabled: Bool {
        guard #available(iOS 14.0, *) else { return false }

        return UIAccessibility.buttonShapesEnabled || forceButtonShapesEnabledForTesting
    }

    private static let cornerRadius: CGFloat = 4
    private static let borderWidth: CGFloat = 2
    private static let backgroundImageSize = CGSize(width: Button.cornerRadius * 2 + 1, height: Button.cornerRadius * 2 + 1)
    private static let backgroundImageCapInsets = UIEdgeInsets(top: Button.cornerRadius,
                                                               left: Button.cornerRadius,
                                                               bottom: Button.cornerRadius,
                                                               right: Button.cornerRadius)
    private static let backgroundImageRenderer = UIGraphicsImageRenderer(size: Button.backgroundImageSize, format: UIGraphicsImageRendererFormat.default())
    private static let backgroundPathWithBorder: CGPath = {
        var backgroundRect = CGRect(origin: .zero, size: backgroundImageSize)
        let borderAdjustment = borderWidth / 2
        backgroundRect = backgroundRect.inset(by: UIEdgeInsets(top: borderAdjustment,
                                                               left: borderAdjustment,
                                                               bottom: borderAdjustment,
                                                               right: borderAdjustment))
        return UIBezierPath(roundedRect: backgroundRect, cornerRadius: cornerRadius - borderAdjustment).cgPath
    }()

    private static let backgroundPathNoBorder: CGPath = {
        let backgroundRect = CGRect(origin: .zero, size: backgroundImageSize)
        return UIBezierPath(roundedRect: backgroundRect, cornerRadius: cornerRadius).cgPath
    }()

    private static let backgroundImageCache = NSCache<NSString, UIImage>()
}

// MARK: - Private Implementation
private extension Button {
    private func updateTitle(_ newValue: String?) {
        if buttonShapesEnabled {
            // When button shapes accessibility setting is enabled, render button titles with an underline
            // to emphasize that the element is interactive.
            titleLabel.attributedText = newValue.flatMap({
                NSAttributedString(string: $0, attributes: [
                    .underlineStyle: NSUnderlineStyle.single.rawValue,
                ])
            })
        } else {
            titleLabel.text = newValue
        }
        invalidateIntrinsicContentSize()
    }

    private func updateTheme() {
        backgroundImage = Button.backgroundImage(withColor: theme.backgroundColor, borderColor: theme.borderColor)
        activeBackgroundImage = Button.backgroundImage(withColor: theme.activeBackgroundColor, borderColor: theme.activeBorderColor)
        disabledBackgroundImage = Button.backgroundImage(withColor: theme.disabledBackgroundColor, borderColor: theme.disabledBorderColor)

        if let loaderDots = loaderDots {
            loaderDots.removeFromSuperview()
        }
        if let loaderTheme = theme.loaderTheme {
            let loaderDots = LoaderDots(theme: loaderTheme, size: .small)
            loaderDots.translatesAutoresizingMaskIntoConstraints = false
            loaderDots.isHidden = !isLoading
            addSubview(loaderDots)
            NSLayoutConstraint.activate([
                loaderDots.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
                loaderDots.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            ])
            self.loaderDots = loaderDots
        }

        updateState()
    }

    private func updateSize() {
        //  Adjust sizing parameters.
        titleLabel.textStyle = size.textStyle
        contentView.spacing = size.iconTextSpacing

        //  We may let the contents expand beyond the padding in tight situations, but only up to 2/3 of the
        //  declared padding (We're cutting 1/3 on each side which is why we take out -2/3).
        maxContentWidthConstraint?.constant = -(2.0 / 3.0) * size.contentPadding.width

        //  Rejigger icon image view if needed.
        iconImageView?.removeFromSuperview()
        if let icon = icon {
            let imageView = iconImageView ?? {
                let imageView = UIImageView()
                imageView.setContentCompressionResistancePriority(.required, for: .horizontal)
                imageView.setContentCompressionResistancePriority(.required, for: .vertical)
                imageView.setContentHuggingPriority(.required, for: .horizontal)
                imageView.setContentHuggingPriority(.required, for: .vertical)
                iconImageView = imageView
                return imageView
            }()

            imageView.image = icon.image
            switch icon.position {
            case .leading:
                contentView.insertArrangedSubview(imageView, at: 0)

            case .trailing:
                contentView.addArrangedSubview(imageView)
            }
        } else {
            iconImageView = nil
        }

        invalidateIntrinsicContentSize()
    }

    private func updateState() {
        if !super.isEnabled {
            backgroundImageView.image = disabledBackgroundImage
            titleLabel.textColor = theme.disabledTitleColor
            contentView.tintColor = theme.disabledTitleColor // Tinting icons, etc.
        } else if isHighlighted || isSelected {
            backgroundImageView.image = activeBackgroundImage
            titleLabel.textColor = theme.activeTitleColor
            contentView.tintColor = theme.activeTitleColor // Tinting icons, etc.
        } else {
            backgroundImageView.image = backgroundImage
            titleLabel.textColor = theme.titleColor
            contentView.tintColor = theme.titleColor // Tinting icons, etc.
        }
    }

    private func updateAccessibilityTraits() {
        var traits: UIAccessibilityTraits = .button

        if isSelected {
            traits.insert(.selected)
        }

        if !isEnabled || isLoading {
            traits.insert(.notEnabled)
        }

        accessibilityTraits = traits
    }

    @objc private func handleHapticFeedbackTouchDown() {
        guard theme.supportsHapticFeedback else { return }

        feedbackGenerator?.prepare()
    }

    @objc private func handleHapticFeedbackTap() {
        guard theme.supportsHapticFeedback else { return }

        feedbackGenerator?.impactOccurred()
    }

    @objc private func buttonShapesEnabledStatusDidChange() {
        updateTitle(title)
    }

    private static func backgroundImage(withColor backgroundColor: UIColor?, borderColor: UIColor?) -> UIImage? {
        guard backgroundColor != nil || borderColor != nil else { return nil }

        let key = NSString(string: "\(backgroundColor?.description ?? "") \(borderColor?.description ?? "")")
        if let cachedResult = backgroundImageCache.object(forKey: key) {
            return cachedResult
        }

        let result = Button.backgroundImageRenderer.image(actions: { context in
            if let backgroundColor = backgroundColor {
                backgroundColor.setFill()

                let fillPath = borderColor == nil
                    ? Button.backgroundPathNoBorder
                    : Button.backgroundPathWithBorder
                context.cgContext.addPath(fillPath)
                context.cgContext.drawPath(using: .fill)
            }

            if let borderColor = borderColor {
                borderColor.setStroke()

                context.cgContext.setLineWidth(borderWidth)
                context.cgContext.addPath(Button.backgroundPathWithBorder)
                context.cgContext.drawPath(using: .stroke)
            }
        }).resizableImage(withCapInsets: Button.backgroundImageCapInsets, resizingMode: .stretch)

        backgroundImageCache.setObject(result, forKey: key)
        return result
    }
}
