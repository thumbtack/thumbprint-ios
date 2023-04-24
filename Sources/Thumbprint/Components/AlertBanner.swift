import Foundation
import SnapKit
import UIKit

/**
 * Themed banner for alerts with a message and a trailing action link
 *
 * Thumbprint Documentation - https://thumbprint.design/components/alert-banner/ios/
 * Thumbtack Documentation - https://thumbtack.atlassian.net/wiki/spaces/P/pages/983631135/Using+Alert+Banner+on+Thumbtack+Global+Banner
 */

public protocol AlertBannerDelegate: AnyObject {
    func alertBannerDidTapAction(_ alertBanner: AlertBanner, link: String)
}

public final class AlertBanner: UIView {
    /**
     *  Themes
     */
    public struct Theme: Equatable {
        public let icon: UIImage
        public let textColor: UIColor
        public let backgroundColor: UIColor

        public static let info = Theme(
            icon: Icon.notificationAlertsInfoFilledMedium.image,
            textColor: Color.blue600,
            backgroundColor: Color.blue100
        )
        public static let warning = Theme(
            icon: Icon.notificationAlertsBlockedFilledMedium.image,
            textColor: Color.red600,
            backgroundColor: Color.red100
        )
        public static let caution = Theme(
            icon: Icon.notificationAlertsWarningFilledMedium.image,
            textColor: Color.yellow600,
            backgroundColor: Color.yellow100
        )
    }

    let textView: UITextView

    // MARK: - Private Properties
    private var theme: Theme
    private var message: String?
    private var action: String?
    private var actionLink: String?
    private let imageView: UIImageView
    private var noImageConstraint: Constraint?
    private var imageConstraint: Constraint?
    public weak var delegate: AlertBannerDelegate?

    public init(theme: Theme,
                message: String? = nil,
                action: String? = nil,
                actionLink: String? = nil,
                delegate: AlertBannerDelegate? = nil) {
        self.theme = theme
        self.message = message
        self.action = action
        self.actionLink = actionLink

        self.textView = UITextView()
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.backgroundColor = .clear
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = 0

        // fallback so that the action link is always visible ( guidelines should avoid this situation )
        textView.textContainer.lineBreakMode = .byTruncatingHead

        self.imageView = UIImageView(image: theme.icon)
        imageView.tintColor = theme.textColor

        self.delegate = delegate

        super.init(frame: .zero)

        textView.delegate = self

        updateAttributedText()

        backgroundColor = theme.backgroundColor

        addSubview(textView)
        addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.size.equalTo(theme.icon.size)
            make.left.equalToSuperview().inset(Thumbprint.Space.three)
            imageConstraint = make.right.equalTo(textView.snp.left).offset(-Thumbprint.Space.three).constraint
            make.centerY.equalToSuperview()
        }

        textView.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(Thumbprint.Space.three)
            make.top.bottom.equalToSuperview().inset(Thumbprint.Space.four)
        }
        textView.snp.prepareConstraints { make in
            noImageConstraint = make.left.equalTo(imageView.snp.right).inset(Thumbprint.Space.three).constraint
        }
    }

    public func update(theme: Theme, message: String, action: String, actionLink: String) {
        self.theme = theme
        self.message = message
        self.action = action
        self.actionLink = actionLink

        imageView.image = theme.icon
        imageView.tintColor = theme.textColor
        imageView.snp.updateConstraints { make in
            make.size.equalTo(theme.icon.size)
        }

        backgroundColor = theme.backgroundColor

        updateAttributedText()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        let prevContentSizeCategory = previousTraitCollection?.preferredContentSizeCategory
        let contentSizeCategory = traitCollection.preferredContentSizeCategory
        if prevContentSizeCategory != contentSizeCategory {
            updateAttributedText()

            if contentSizeCategory >= .extraExtraExtraLarge {
                imageView.isHidden = true
                imageConstraint?.deactivate()
                noImageConstraint?.activate()
            } else {
                imageView.isHidden = false
                noImageConstraint?.deactivate()
                imageConstraint?.activate()
            }
        }
    }

    func updateAttributedText() {
        guard let message = message,
              let action = action,
              let actionLink = actionLink else { return }

        let textDynamicFont = Font.TextStyle.text2.scaledFont(compatibleWith: traitCollection)
        let linkDynamicFont = Font.TextStyle.title7.scaledFont(compatibleWith: traitCollection)
        let attributedString = NSMutableAttributedString()
        attributedString.append(NSAttributedString(string: message,
                                                   attributes: [
                                                       .font: textDynamicFont,
                                                       .foregroundColor: theme.textColor,
                                                   ]))
        attributedString.append(NSAttributedString(string: " ",
                                                   attributes: [
                                                       .font: textDynamicFont,
                                                   ]))
        attributedString.append(NSAttributedString(string: action,
                                                   attributes: [
                                                       .font: linkDynamicFont,
                                                       .link: actionLink,
                                                   ]))
        textView.linkTextAttributes = [
            .foregroundColor: theme.textColor,
            .underlineStyle: NSUnderlineStyle.single.rawValue,
        ]
        textView.attributedText = attributedString
    }
}

extension AlertBanner: UITextViewDelegate {
    public func textView(
        _ textView: UITextView,
        shouldInteractWith url: URL,
        in characterRange: NSRange,
        interaction: UITextItemInteraction
    ) -> Bool {
        delegate?.alertBannerDidTapAction(self, link: url.absoluteString)
        return false
    }
}
