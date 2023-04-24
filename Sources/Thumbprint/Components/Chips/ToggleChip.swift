import UIKit

/**
 * ToggleChip typically used grouped with other chips to select/deselect different options
 *
 * See the Thumbprint documentation at https://thumbprint.design/components/chip/ios/
 */

public final class ToggleChip: Chip {
    override class var selectedTheme: Pill.Theme {
        return .init(backgroundColor: Color.blue, contentColor: Color.white)
    }

    override func buildAccessibilityLabel() -> String {
        var result = isSelected ? "remove selection" : "select"
        if let text = text {
            result += " for: \(text)"
        }
        return result
    }
}
