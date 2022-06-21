import UIKit

/**
 * FilterChip typically used for filtering content immediately on tap
 *
 * See the Thumbprint documentation at https://thumbprint.design/components/chip/ios/
 */

public final class FilterChip: Chip {
    override class var selectedTheme: Pill.Theme {
        return .init(backgroundColor: Color.blue100, contentColor: Color.blue)
    }

    override func buildAccessibilityLabel() -> String {
        var result = isSelected ? "remove filter" : "apply filter"
        if let text = text {
            result += " for: \(text)"
        }
        return result
    }
}
