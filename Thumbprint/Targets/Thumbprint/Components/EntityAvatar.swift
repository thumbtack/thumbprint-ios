import SnapKit
import UIKit

/**
 * Entity Avatar
 * Intended for use when displaying business, or service profiles.
 *
 * See Thumbprint Documentation on [Avatar]( https://thumbprint.design/components/avatar/react/ ).
 */
public final class EntityAvatar: UIView {
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
            guard oldValue != initials else { return }
            if let initials = initials {
                avatar.label.text = String(initials.uppercased().prefix(1))
            } else {
                avatar.label.text = nil
            }
            updateEmptyTheme()
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
     Initializes an EntityAvatar used for displaying businesses, or service profiles.

     - parameters:
        - size: The initial `Avatar.Size` class for the component.
        - initials: Any string longer that one character will be truncated for display.
        - name: Used for accessibility label for the avatar.

     This follows a similar structure to UserAvatar
     */
    public init(size: Avatar.Size, initials: String? = nil, name: String? = nil, isOnline: Bool = false) {
        self.size = size
        self.avatar = Avatar(size: size)
        self.badgeView = OnlineBadgeView()
        self.isOnline = isOnline

        super.init(frame: .zero)

        self.initials = initials
        self.name = name

        setupViews()
        updateSize()
        updateEmptyTheme()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // Enity Avatar - private
    private let avatar: Avatar
    private let badgeView: OnlineBadgeView
    private var avatarHeightConstraint: Constraint?

    public override var intrinsicContentSize: CGSize {
        CGSize(width: size.dimension, height: size.dimension)
    }

    private func setupViews() {
        avatar.layer.cornerRadius = 4.0
        avatar.clipsToBounds = true
        avatar.label.text = initials

        addSubview(avatar)
        avatar.snp.makeConstraints { make in
            make.top.left.equalToSuperview()
            avatarHeightConstraint = make.height.equalTo(size.dimension).constraint
            make.width.equalTo(avatar.snp.height)
        }

        badgeView.isHidden = !isOnline
        addSubview(badgeView)
    }

    private func updateEmptyTheme() {
        avatar.emptyTheme = Avatar.backgroundColor(initials: initials)
    }

    private func updateSize() {
        avatar.size = size

        avatarHeightConstraint?.update(offset: size.dimension)
        badgeView.snp.remakeConstraints { make in
            let offset = ceil(size.badgeSize / 3)
            make.top.equalToSuperview().offset(-offset)
            make.right.equalToSuperview().offset(offset)
            make.height.equalTo(size.badgeSize)
            make.width.equalTo(badgeView.snp.height)
        }

        invalidateIntrinsicContentSize()
    }
}
