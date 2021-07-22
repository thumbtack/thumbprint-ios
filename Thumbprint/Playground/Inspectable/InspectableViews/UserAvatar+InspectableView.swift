import Thumbprint
import UIKit

extension UserAvatar: InspectableView {
    var useImage: Bool {
        get {
            image != nil
        }
        set {
            image = newValue ? UIImage(named: "niccage") : nil
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

        let sizes: [(Avatar.Size, String)] = Avatar.Size.allSizes.map {
            ($0, $0.name)
        }
        let sizeProperty = DropdownInspectableProperty(
            inspectedView: self,
            property: \UserAvatar.size,
            values: sizes
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
}
