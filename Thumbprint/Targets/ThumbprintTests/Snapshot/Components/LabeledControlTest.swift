@testable import Thumbprint
import UIKit

class MockMultilabel: UIStackView, UIContentSizeCategoryAdjusting {
    let titleLabel: Label = {
        let titleLabel = Label(textStyle: .title6)
        titleLabel.text = "Potatoes!"
        titleLabel.numberOfLines = 0
        titleLabel.textColor = Color.black
        return titleLabel
    }()

    let subtitleLabel: Label = {
        let subtitleLabel = Label(textStyle: .text2)
        subtitleLabel.text = "It's what's for dinner, lunch and breakfast!"
        subtitleLabel.numberOfLines = 0
        subtitleLabel.textColor = Color.black300
        return subtitleLabel
    }()

    var adjustsFontForContentSizeCategory: Bool = true {
        didSet {
            guard adjustsFontForContentSizeCategory != oldValue else {
                return
            }

            titleLabel.adjustsFontForContentSizeCategory = adjustsFontForContentSizeCategory
            subtitleLabel.adjustsFontForContentSizeCategory = adjustsFontForContentSizeCategory
        }
    }

    required override init(frame: CGRect) {
        super.init(frame: frame)
        axis = .vertical
        addArrangedSubview(titleLabel)
        addArrangedSubview(subtitleLabel)
    }

    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
