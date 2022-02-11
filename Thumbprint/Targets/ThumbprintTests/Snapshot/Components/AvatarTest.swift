import TestsHostApp
@testable import Thumbprint
import UIKit

// Used for snapshot tests
protocol AvatarView: UIView {
    var size: Avatar.Size { get }
}

extension UserAvatar: AvatarView {}

extension EntityAvatar: AvatarView {}

class AvatarTest: SnapshotTestCase {
    private static let allSizes: [Avatar.Size] = [
        .xSmall,
        .small,
        .medium,
        .large,
        .xLarge,
    ]

    func testInitialsUser() {
        let initials = [
            "AYYYY",
            "BOOOOOOO",
            "CAAA",
            "Dooooo",
            "Eh!",
            "FA",
            "🥰😅",
            "汉字汉",
        ]
        let views: [UserAvatar] = initials.enumerated().map {
            let avatar = UserAvatar(size: .medium)
            avatar.initials = $0.element
            return avatar
        }
        verifyViews(views: views)
    }

    func testImageUser() {
        let image = UIImage(named: "eric",
                            in: Bundle.testing,
                            compatibleWith: nil)
        let views: [UserAvatar] = Self.allSizes.map {
            let avatar = UserAvatar(size: $0)
            avatar.image = image
            return avatar
        }

        verifyViews(views: views)
    }

    func testInitialsEntity() {
        let initials = [
            "AYYYY",
            "BOOOOOOO",
            "CAAA",
            "Dooooo",
            "Eh!",
            "FA",
            "🥰😅",
            "汉字汉",
        ]
        let views: [EntityAvatar] = initials.enumerated().map {
            let avatar = EntityAvatar(size: .medium)
            avatar.initials = $0.element
            return avatar
        }
        verifyViews(views: views)
    }

    func testImageEntity() {
        let image = UIImage(named: "eric",
                            in: Bundle.testing,
                            compatibleWith: nil)
        let views: [EntityAvatar] = Self.allSizes.map {
            let avatar = EntityAvatar(size: $0)
            avatar.image = image
            return avatar
        }

        verifyViews(views: views)
    }

    func testOnlineEntity() {
        let image = UIImage(named: "eric",
                            in: Bundle.testing,
                            compatibleWith: nil)
        let views: [EntityAvatar] = Self.allSizes.map {
            let avatar = EntityAvatar(size: $0)
            avatar.image = image
            avatar.isOnline = true
            return avatar
        }

        verifyViews(views: views)
    }

    func testOnlineUser() {
        let image = UIImage(named: "eric",
                            in: Bundle.testing,
                            compatibleWith: nil)
        let views: [UserAvatar] = Self.allSizes.map {
            let avatar = UserAvatar(size: $0)
            avatar.image = image
            avatar.isOnline = true
            return avatar
        }

        verifyViews(views: views)
    }

    func testInitialization() {
        let userAvatar = UserAvatar(size: .medium, initials: "DR", name: "Daniel Roth", isOnline: false)
        let entityAvatar = EntityAvatar(size: .medium, initials: "DR", name: "Daniel Roth", isOnline: true)
        verifyViews(views: [userAvatar, entityAvatar])
    }

    func verifyViews(views: [AvatarView]) {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 8

        views.forEach { stackView.addArrangedSubview($0) }

        verify(view: stackView, contentSizeCategories: [.unspecified])
    }
}
