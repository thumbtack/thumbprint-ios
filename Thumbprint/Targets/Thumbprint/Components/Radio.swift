import UIKit

// MARK: - RadioImage
public final class Radio: Control {
    // MARK: - UIView Overrides

    public override var intrinsicContentSize: CGSize {
        Self.backgroundFillImage?.size ?? super.intrinsicContentSize
    }

    public override func sizeThatFits(_ size: CGSize) -> CGSize {
        intrinsicContentSize
    }

    public override var isSelected: Bool {
        didSet {
            innerDot.isHidden = !isSelected
        }
    }

    var inputState: InputState = .default {
        didSet {
            updateInnerCircleColor()
            updateOuterCircleColor()
        }
    }

    private func updateInnerCircleColor() {
        switch inputState {
        case .default, .highlighted:
            innerDot.tintColor = Color.blue
        case .disabled:
            innerDot.tintColor = Color.gray
        case .error:
            innerDot.tintColor = Color.red
        }
    }

    private func updateOuterCircleColor() {
        switch inputState {
        case .default:
            outerRing.tintColor = isSelected ? Color.blue : Color.gray
            backgroundFill.tintColor = .clear
        case .disabled:
            outerRing.tintColor = Color.gray300
            backgroundFill.tintColor = Color.white
        case .error:
            outerRing.tintColor = Color.red
            backgroundFill.tintColor = .clear
        case .highlighted:
            outerRing.tintColor = Color.blue
            backgroundFill.tintColor = .clear
        }
    }

    private let innerDot: UIImageView
    private let outerRing: UIImageView
    private let backgroundFill: UIImageView

    private static let innerDotImage = UIImage(named: "Radio-InnerDot", in: Bundle.thumbprint, compatibleWith: nil)
    private static let outerRingImage = UIImage(named: "Radio-OuterRing", in: Bundle.thumbprint, compatibleWith: nil)
    private static let backgroundFillImage = UIImage(named: "Radio-BackgroundFill", in: Bundle.thumbprint, compatibleWith: nil)

    init() {
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

        defer { // swiftlint:disable:this inert_defer
            isSelected = false
            inputState = .default
        }
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
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
