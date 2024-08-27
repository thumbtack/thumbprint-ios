import SnapKit
import UIKit

/**
 * Entity Avatar
 * Intended for use when displaying business, or service profiles.
 *
 * See Thumbprint Documentation on [Avatar]( https://thumbprint.design/components/avatar/react/ ).
 */
public final class EntityAvatar: UserAvatar {
    /**
     Any string longer that one character will be truncated for display.
     */
    public override var initials: String? {
        didSet {
            guard oldValue != initials else { return }
            if let initials {
                avatar.label.text = String(initials.uppercased().prefix(1))
            } else {
                avatar.label.text = nil
            }
            updateEmptyTheme()
        }
    }
}
