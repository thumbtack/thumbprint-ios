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
            guard oldValue != initials else { return }
            if let initials = initials {
                avatar.label.text = String(initials.uppercased().prefix(2))
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
        updateEmptyTheme()
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
    private var avatarHeightConstraint: Constraint?

    private func setupViews() {
        avatar.label.text = initials
        avatar.clipsToBounds = true

        addSubview(avatar)
        avatar.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            avatarHeightConstraint = make.height.equalTo(size.dimension).constraint
            make.width.equalTo(avatar.snp.height)
        }

        badgeView.isHidden = !isOnline
        addSubview(badgeView)
    }

    private func updateSize() {
        avatar.size = size

        avatarHeightConstraint?.update(offset: size.dimension)
        badgeView.snp.remakeConstraints { make in
            make.top.equalToSuperview().offset(size.badgeOffsets.dy)
            make.right.equalToSuperview().offset(size.badgeOffsets.dx)
            make.height.equalTo(size.badgeSize)
            make.width.equalTo(badgeView.snp.height)
        }

        invalidateIntrinsicContentSize()

        setNeedsLayout()
    }

    private func updateEmptyTheme() {
        avatar.emptyTheme = Avatar.backgroundColor(initials: initials)
    }

    public override func layoutSubviews() {
        super.layoutSubviews()

        avatar.layer.cornerRadius = avatar.frame.size.width / 2
    }
}
