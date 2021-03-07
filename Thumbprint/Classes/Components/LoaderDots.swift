import UIKit

/**
 * Loading indicator for use within components such as buttons.
 */
public final class LoaderDots: UIView {
    public enum Theme {
        case brand
        case inverse
        case muted

        public var color: UIColor {
            switch self {
            case .brand: return Color.blue
            case .muted: return Color.black300
            case .inverse: return Color.white
            }
        }
    }

    public enum Size {
        case medium
        case small

        public var size: CGFloat {
            switch self {
            case .medium: return 16
            case .small: return 8
            }
        }

        public var spacing: CGFloat {
            switch self {
            case .medium: return 10
            case .small: return 5
            }
        }
    }

    public var hidesOnStop: Bool = true

    public var theme: Theme {
        didSet {
            reconfigureDotViews()
        }
    }

    public var size: Size {
        didSet {
            invalidateIntrinsicContentSize()
            reconfigureDotViews()
        }
    }

    private class DotView: UIView {
        var size: CGFloat {
            didSet {
                guard size != oldValue else {
                    return
                }

                invalidateIntrinsicContentSize()
            }
        }

        init(size: CGFloat) {
            self.size = size

            super.init(frame: .zero)

            //  Default to high content compression/hugging priorities.
            setContentHuggingPriority(.defaultHigh, for: .horizontal)
            setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
            setContentHuggingPriority(.defaultHigh, for: .vertical)
            setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        }

        @available(*, unavailable)
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        override var intrinsicContentSize: CGSize {
            return CGSize(width: size, height: size)
        }
    }

    private let dotCount: Int = 3
    private let fadeInDuration: Double = 0.3 // note *not* seconds, rather percentage of animationDuration
    private let fadeOutDuration: Double = 0.4 // note *not* seconds, rather percentage of animationDuration
    private let startTimes: [Double] = [0, 0.15, 0.3] // since total fade duration is 70%, latest start time possible is 30%
    // per: https://github.com/thumbtack/thumbprint/blob/6b8fc594224842fee831e16c90da469da0486d9e/packages/tp-ui-react-loader-dots/index.module.scss#L13
    private let animationDuration: TimeInterval = 1.3 // seconds
    private let dotsContainerStackView = UIStackView()
    private var dotViews: [DotView] = []
    private var isAnimating: Bool

    /// Creates and returns a loading indicator with the specified theme/size.
    public init(theme: Theme = .brand, size: Size = .medium) {
        self.theme = theme
        self.size = size
        self.isAnimating = false

        super.init(frame: CGRect.zero)

        setupView()
        play()
    }

    @available(*, unavailable)
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// Start animating the loader dots if not already animating.
    public func play() {
        guard !isAnimating else { return }

        isAnimating = true
        dotsContainerStackView.isHidden = false

        // Hack to get UIView.AnimationOptions into UIView.KeyframeAnimationOptions, per: https://stackoverflow.com/a/34256232
        let easing: UIView.AnimationOptions = .curveEaseIn
        let keyframeEasing = UIView.KeyframeAnimationOptions(rawValue: easing.rawValue)

        UIView.animateKeyframes(
            withDuration: animationDuration,
            delay: 0,
            options: [keyframeEasing, .repeat],
            animations: { [weak self] in
                self?.startTimes.enumerated().forEach { [weak self] index, startTime in
                    guard let self = self else { return }
                    UIView.addKeyframe(
                        withRelativeStartTime: startTime,
                        relativeDuration: self.fadeInDuration,
                        animations: { [weak self] in
                            self?.dotViews[index].backgroundColor = self?.theme.color
                        }
                    )
                    UIView.addKeyframe(
                        withRelativeStartTime: startTime + self.fadeInDuration,
                        relativeDuration: self.fadeOutDuration,
                        animations: { [weak self] in
                            self?.dotViews[index].backgroundColor = self?.theme.color.withAlphaComponent(0.2)
                        }
                    )
                }
            }
        )
    }

    public func stop() {
        isAnimating = false
        dotsContainerStackView.isHidden = hidesOnStop
        dotViews.forEach({ $0.layer.removeAllAnimations() })
    }

    /**
     * Mark that the animation has stopped.
     *
     * This must be called when the animation has been paused by UIKit, such as after
     * a table view cell has ended displaying and might be reused.
     */
    public func animationDidStop() {
        isAnimating = false
    }

    public override var intrinsicContentSize: CGSize {
        let width = (size.size * CGFloat(dotCount)) + (size.spacing * CGFloat(dotCount - 1))
        let height = size.size
        return CGSize(width: width, height: height)
    }

    private func setupView() {
        addSubview(dotsContainerStackView)
        dotsContainerStackView.translatesAutoresizingMaskIntoConstraints = false
        dotsContainerStackView.alignment = .center
        dotsContainerStackView.spacing = size.spacing

        for _ in 0 ..< dotCount {
            let dotView = DotView(size: size.size)
            dotView.clipsToBounds = true
            configureDotView(dotView: dotView)

            dotViews.append(dotView)
            dotsContainerStackView.addArrangedSubview(dotView)
        }

        dotsContainerStackView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        dotsContainerStackView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }

    private func configureDotView(dotView: DotView) {
        dotView.layer.cornerRadius = CGFloat(size.size) / 2.0
        dotView.backgroundColor = theme.color.withAlphaComponent(0.2)
        dotView.size = size.size
    }

    private func reconfigureDotViews() {
        dotViews.forEach({ configureDotView(dotView: $0) })
        if isAnimating {
            stop()
            play()
        }
    }
}
