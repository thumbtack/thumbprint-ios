import UIKit

/**
 * Full-width button row
 */
public final class ButtonRow: UIView, UIContentSizeCategoryAdjusting {
    public let leftButton: Button
    public let rightButton: Button

    /// Enum specifying how the buttons should be distributed along the horizontal axis.
    public enum Distribution {
        /// Left & right buttons each use 50% of the total space.
        case equal

        /// Left button is given enough space to fit its content, and
        /// right button takes up the remaining space.
        case emphasis

        /// Left & right buttons are each given only enough space to fit their content.
        case minimal
    }

    /// Button row distribution
    public var distribution: Distribution {
        didSet {
            updateDistribution()
        }
    }

    public enum Alignment {
        /// Left & right buttons each use 50% of the total space.
        case horizontal

        /// Left button is laid out at the bottom and right on top, both have the save width and height
        case vertical
    }

    public var alignment: Alignment {
        didSet { updateAlignment() }
    }

    public var adjustsFontForContentSizeCategory: Bool {
        didSet {
            // Since the buttons' `adjustsFontForContentSizeCategory` properties
            // can technically be set individually, not guarding against
            // `adjustsFontForContentSizeCategory == oldValue` (since even if that were true,
            // one or both of the buttons' properties might already be out of sync, necessitating
            // an update anyway.
            leftButton.adjustsFontForContentSizeCategory = adjustsFontForContentSizeCategory
            rightButton.adjustsFontForContentSizeCategory = adjustsFontForContentSizeCategory
        }
    }

    /// Creates and returns a new button row with the specified buttons.
    /// Right should generally have the "primary" button style.
    /// Secondary button should typically have either a "secondary" or "tertiary" button style.
    public init(leftButton: Button, rightButton: Button, distribution: Distribution = .emphasis, alignment: Alignment = .horizontal) {
        self.leftButton = leftButton
        self.rightButton = rightButton
        self.distribution = distribution
        self.alignment = alignment
        self.adjustsFontForContentSizeCategory = (leftButton.adjustsFontForContentSizeCategory && rightButton.adjustsFontForContentSizeCategory)

        super.init(frame: .null)

        addSubview(leftButton)
        addSubview(rightButton)

        updateAlignment()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func updateDistribution() {
        switch distribution {
        case .equal:
            leftButton.setContentHuggingPriority(.defaultLow, for: .horizontal)
            leftButton.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 999), for: .horizontal)
            leftButton.snp.remakeConstraints { make in
                make.top.bottom.leading.equalToSuperview()
            }

            rightButton.setContentHuggingPriority(.defaultLow, for: .horizontal)
            rightButton.snp.remakeConstraints { make in
                make.top.bottom.trailing.equalToSuperview()
                make.leading.equalTo(leftButton.snp.trailing).offset(Space.three)
                make.width.equalTo(leftButton)
            }

        case .emphasis:
            leftButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
            leftButton.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 999), for: .horizontal)
            leftButton.snp.remakeConstraints { make in
                make.top.bottom.leading.equalToSuperview()
                make.width.greaterThanOrEqualToSuperview().multipliedBy(0.3)
            }

            rightButton.setContentHuggingPriority(.defaultLow, for: .horizontal)
            rightButton.snp.remakeConstraints { make in
                make.top.bottom.trailing.equalToSuperview()
                make.leading.equalTo(leftButton.snp.trailing).offset(Space.three)
                make.width.greaterThanOrEqualTo(leftButton)
            }

        case .minimal:
            leftButton.setContentHuggingPriority(.required, for: .horizontal)
            leftButton.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 999), for: .horizontal)
            leftButton.snp.remakeConstraints { make in
                make.top.bottom.leading.equalToSuperview()
            }

            rightButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
            rightButton.snp.remakeConstraints { make in
                make.top.bottom.trailing.equalToSuperview()
                make.leading.greaterThanOrEqualTo(leftButton.snp.trailing).offset(Space.three)
                make.width.greaterThanOrEqualTo(leftButton)
            }
        }
    }

    private func updateAlignment() {
        switch alignment {
        case .vertical:
            rightButton.snp.removeConstraints()
            rightButton.snp.remakeConstraints { make in
                make.leading.top.trailing.equalToSuperview()
            }

            leftButton.snp.removeConstraints()
            leftButton.snp.remakeConstraints { make in
                make.leading.bottom.trailing.equalToSuperview()
                make.top.equalTo(rightButton.snp.bottom).offset(Space.two)
                make.height.equalTo(rightButton.snp.height)
            }
        case .horizontal:
            updateDistribution()
        }
    }
}
