import Thumbprint
import UIKit

extension EntityAvatar: InspectableView {
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
        useImageProperty.property = \EntityAvatar.useImage

        let onlineProperty = BoolInspectableProperty(inspectedView: self)
        onlineProperty.title = "Online"
        onlineProperty.property = \EntityAvatar.isOnline

        let initialsProperty = StringInspectableProperty(inspectedView: self)
        initialsProperty.title = "Initials"
        initialsProperty.property = \EntityAvatar.initials

        let sizeProperty = DropdownInspectableProperty(
            inspectedView: self,
            property: \EntityAvatar.size,
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
        let avatar = EntityAvatar(size: .large)
        avatar.initials = "A"
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
