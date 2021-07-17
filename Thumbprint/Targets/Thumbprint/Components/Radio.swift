import UIKit

/**
 A radio button.

 This control *only* manages the radio button itself. You normally want to use `LabeledRadio` instead, but this is left public so custom radio button UIs
 can be built on top.
 */
public final class Radio: Control {
    public init() {
        self.innerDot = UIImageView(image: Self.innerDotImage)
        self.outerRing = UIImageView(image: Self.outerRingImage)
        self.backgroundFill = UIImageView(image: Self.backgroundFillImage)

        super.init(frame: .null)

        addSubview(backgroundFill)
        addSubview(outerRing)
        addSubview(innerDot)

        backgroundFill.snp.makeConstraints { make in
            make.size.equalTo(Self.backgroundFillImage?.size ?? .zero)
            make.edges.equalToSuperview()
        }

        outerRing.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        innerDot.snp.makeConstraints { make in
            make.size.equalTo(Self.innerDotImage?.size ?? .zero)
            make.center.equalToSuperview()
        }

        backgroundColor = .clear

        // Make sure all the UI is up to date.
        updateUIState()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UIView Overrides

    public override var intrinsicContentSize: CGSize {
        Self.backgroundFillImage?.size ?? super.intrinsicContentSize
    }

    public override func sizeThatFits(_ size: CGSize) -> CGSize {
        intrinsicContentSize
    }

    public override var isSelected: Bool {
        didSet {
            guard isSelected != oldValue else {
                return
            }

            updateUIState()
        }
    }

    public override var isEnabled: Bool {
        didSet {
            guard isEnabled != oldValue else {
                return
            }

            updateUIState()
        }
    }

    public override var isHighlighted: Bool {
        didSet {
            guard isHighlighted != oldValue else {
                return
            }

            updateUIState()
        }
    }

    private func updateUIState() {
        innerDot.isHidden = !isSelected

        if isEnabled {
            // Inner dot blue if it shows.
            innerDot.tintColor = Color.blue
            backgroundFill.tintColor = .clear

            if isSelected || isHighlighted {
                outerRing.tintColor = Color.blue
            } else {
                outerRing.tintColor = Color.gray
            }
        } else {
            // Disabled. Outer ring draws lighter than inner dot if selected.
            innerDot.tintColor = Color.gray
            outerRing.tintColor = isSelected ? Color.gray : Color.gray300
            backgroundFill.tintColor = Color.white
        }
    }

    private let innerDot: UIImageView
    private let outerRing: UIImageView
    private let backgroundFill: UIImageView

    private static let innerDotImage = UIImage(named: "Radio-InnerDot", in: Bundle.thumbprint, compatibleWith: nil)
    private static let outerRingImage = UIImage(named: "Radio-OuterRing", in: Bundle.thumbprint, compatibleWith: nil)
    private static let backgroundFillImage = UIImage(named: "Radio-BackgroundFill", in: Bundle.thumbprint, compatibleWith: nil)
}

// MARK: - SimpleControl Implementation

extension Radio: SimpleControl {
    public func performAction() {
        // Show as selected. If something is wrong with that the controller will revise later.
        isSelected = true

        sendActions(for: .touchUpInside)
    }

    public func set(target: Any?, action: Selector) {
        addTarget(target, action: action, for: .touchUpInside)
    }
}
