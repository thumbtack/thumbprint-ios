import Thumbprint
import UIKit

extension UserAvatar: InspectableView {
    var useImage: Bool {
        get {
            image != nil
        }
        set {
            image = newValue ? UIImage(named: "cat") : nil
        }
    }

    var inspectableProperties: [InspectableProperty] {
        let useImageProperty = BoolInspectableProperty(inspectedView: self)
        useImageProperty.title = "Use image"
        useImageProperty.property = \UserAvatar.useImage

        let onlineProperty = BoolInspectableProperty(inspectedView: self)
        onlineProperty.title = "Online"
        onlineProperty.property = \UserAvatar.isOnline

        let initialsProperty = StringInspectableProperty(inspectedView: self)
        initialsProperty.title = "Initials"
        initialsProperty.property = \UserAvatar.initials

        let sizeProperty = DropdownInspectableProperty(
            inspectedView: self,
            property: \UserAvatar.size,
            values: Self.allSizes
        )

        return [
            useImageProperty,
            onlineProperty,
            initialsProperty,
            sizeProperty,
        ]
    }

    static func makeInspectable() -> UIView & InspectableView {
        let avatar = UserAvatar(size: .large)
        avatar.initials = "AA"
        return avatar
    }

    private static let allSizes = [
        (Avatar.Size.xSmall, "xSmall"),
        (Avatar.Size.small, "small"),
        (Avatar.Size.medium, "medium"),
        (Avatar.Size.large, "large"),
        (Avatar.Size.xLarge, "xLarge"),
    ]
}
