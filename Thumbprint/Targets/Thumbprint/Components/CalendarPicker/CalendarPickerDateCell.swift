import UIKit

class CalendarPickerDateCell: UICollectionViewCell {
    static let reuseIdentifier = "ThumbprintCalendarPickerDateCellReuseIdentifier"

    private let label = Label(textStyle: .title7, adjustsFontForContentSizeCategory: false)
    private let todayIndicator = CircleView()
    private let dotIndicator = CircleView()
    private let slashIndicator = UIView()

    public var isToday: Bool = false {
        didSet {
            todayIndicator.isHidden = !isToday
            updateLabelAndSlashColor()
        }
    }

    public var showDot: Bool = false {
        didSet {
            dotIndicator.isHidden = !showDot
        }
    }

    public var showSlash: Bool = false {
        didSet {
            slashIndicator.isHidden = !showSlash
        }
    }

    private var isInVisibleMonth: Bool = true {
        didSet {
            updateLabelAndSlashColor()
        }
    }

    override var isSelected: Bool {
        didSet {
            contentView.layer.borderWidth = isSelected ? 3 : 0
        }
    }

    public var isEnabled: Bool = true {
        didSet {
            updateLabelAndSlashColor()
        }
    }

    func updateLabelAndSlashColor() {
        if !isEnabled {
            label.textColor = Color.gray
            slashIndicator.backgroundColor = Color.gray
        } else if isToday {
            label.textColor = Color.white
            slashIndicator.backgroundColor = Color.black300
        } else if isInVisibleMonth {
            label.textColor = Color.black300
            slashIndicator.backgroundColor = Color.black300
        } else {
            label.textColor = Color.gray
            slashIndicator.backgroundColor = Color.gray
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        todayIndicator.backgroundColor = Color.blue
        dotIndicator.backgroundColor = Color.blue
        slashIndicator.backgroundColor = Color.black300

        contentView.addManagedSubview(todayIndicator)
        contentView.addManagedSubview(label)
        contentView.addManagedSubview(dotIndicator)
        contentView.addManagedSubview(slashIndicator)

        contentView.layer.borderColor = Color.blue.cgColor
        backgroundColor = .white

        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])

        NSLayoutConstraint.activate([
            slashIndicator.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 1.0 / 24.0),
            slashIndicator.widthAnchor.constraint(equalTo: todayIndicator.widthAnchor, multiplier: 1.3),
        ])
        slashIndicator.centerInSuperview(along: .both)

        NSLayoutConstraint.activate([
            dotIndicator.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 1.0 / 12.0),
            .init(item: dotIndicator, attribute: .bottom, relatedBy: .equal, toItem: contentView, attribute: .bottom, multiplier: CGFloat(7.0 / 8.0), constant: 0.0),
        ])
        dotIndicator.centerInSuperview(along: .horizontal)
        dotIndicator.enforce(aspectRatio: 1.0)

        NSLayoutConstraint.activate([
            todayIndicator.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 1.0 / 2.0),
        ])
        todayIndicator.centerInSuperview(along: .both)
        todayIndicator.enforce(aspectRatio: 1.0)

        slashIndicator.transform = CGAffineTransform(rotationAngle: -.pi / 4.0)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func configure(withDay day: Int, inVisibleMonth: Bool, isToday: Bool, showDot: Bool, showSlash: Bool, isEnabled: Bool) {
        label.text = String(day)
        isInVisibleMonth = inVisibleMonth
        self.isToday = isToday
        self.showDot = showDot
        self.showSlash = showSlash
        self.isEnabled = isEnabled
    }
}

private class CircleView: UIView {
    override var bounds: CGRect {
        didSet {
            layer.cornerRadius = bounds.width / 2.0
        }
    }
}
