import SnapKit
import UIKit

/**
 * User Avatar
 * Intended for use when displaying user accounts, or customers.
 *
 * See Thumbprint Documentation on [Avatar]( https://thumbprint.design/components/avatar/react/ ).
 */
public final class UserAvatar: UIView {
    /**
     The image displayed in the avatar image view
     */
    public var image: UIImage? {
        get {
            avatar.image
        }
        set {
            avatar.image = newValue
        }
    }

    /**
     Avatar Size
     */
    public var size: Avatar.Size {
        didSet {
            updateSize()
        }
    }

    /**
     Boolean value that controls whether the online badge is shown or not
     */
    public var isOnline: Bool {
        didSet {
            badgeView.isHidden = !isOnline
        }
    }

    /**
     Any string longer that one character will be truncated for display.
     */
    public var initials: String? {
        didSet {
            if let initials = initials {
                avatar.label.text = String(initials.uppercased().prefix(2))
            } else {
                avatar.label.text = nil
            }
            avatar.emptyTheme = Avatar.backgroundColor(initials: initials)
        }
    }

    /**
     Used for accessibility label for the avatar.
     */
    public var name: String? {
        get {
            accessibilityLabel
        }
        set {
            accessibilityLabel = newValue
        }
    }

    /**
     Initializes a UserAvatar used for displaying user accounts, or customers.

     - parameters:
        - size: The initial `Avatar.Size` class for the component.
        - initials: Any string longer that two characters will be truncated for display.
        - name: Used for accessibility label for the avatar.

     This follows a similar structure to EntityAvatar
     */
    public init(size: Avatar.Size, initials: String? = nil, name: String? = nil, isOnline: Bool = false) {
        self.size = size
        self.avatar = Avatar(size: size)
        self.badgeView = OnlineBadgeView()
        self.isOnline = isOnline

        super.init(frame: .zero)

        self.initials = initials
        self.name = name

        accessibilityLabel = self.name

        setupViews()
        updateSize()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // User Avatar - private

    private let avatar: Avatar

    public override var intrinsicContentSize: CGSize {
        CGSize(width: size.dimension, height: size.dimension)
    }

    private let badgeView: OnlineBadgeView
    private var avatarHeightConstraint: NSLayoutConstraint?

    // Hardcoded top and right offsets for the online now badge.
    let badgeEdges = [
        "xSmall": (0.0, 2.0),
        "small": (1.0, 2.0),
        "medium": (2.0, -2.0),
        "large": (4.0, -5.0),
        "xLarge": (0.0, -14.0),
    ]

    private func setupViews() {
        avatar.label.text = initials
        avatar.clipsToBounds = true

        addManagedSubview(avatar)
        avatar.snapToSuperviewEdges([.top, .leading])
        avatarHeightConstraint = avatar.heightAnchor.constraint(equalToConstant: size.dimension)
        avatarHeightConstraint?.isActive = true
        avatar.enforce(aspectRatio: 1.0)

        badgeView.isHidden = !isOnline
        addManagedSubview(badgeView)
    }

    private func updateSize() {
        avatar.size = size

        avatarHeightConstraint?.constant = size.dimension
        badgeView.snp.remakeConstraints { make in
            let (top, right) = badgeEdges[size.name] ?? (0.0, 0.0)
            make.top.equalToSuperview().offset(top)
            make.right.equalToSuperview().offset(right)
            make.height.equalTo(size.badgeSize)
            make.width.equalTo(badgeView.snp.height)
        }

        invalidateIntrinsicContentSize()

        setNeedsLayout()
    }

    public override func layoutSubviews() {
        super.layoutSubviews()

        avatar.layer.cornerRadius = avatar.frame.size.width / 2
    }
}
