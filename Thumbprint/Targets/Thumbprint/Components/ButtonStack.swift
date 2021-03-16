import UIKit

/**
 * Vertical button stack
 */
public final class ButtonStack: UIStackView {
    public let buttons: [Button]

    /// Creates and returns a new button stack with the specified buttons.
    public init(buttons: [Button] = []) {
        self.buttons = buttons

        super.init(frame: .null)

        axis = .vertical
        distribution = .equalSpacing
        spacing = Space.two
        alignment = .fill

        buttons.forEach {
            addArrangedSubview($0)
        }
    }

    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
