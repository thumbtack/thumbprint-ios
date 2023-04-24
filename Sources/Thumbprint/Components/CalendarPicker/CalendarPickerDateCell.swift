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

        contentView.addSubview(todayIndicator)
        contentView.addSubview(label)
        contentView.addSubview(dotIndicator)
        contentView.addSubview(slashIndicator)

        contentView.layer.borderColor = Color.blue.cgColor
        backgroundColor = .white

        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

        slashIndicator.snp.makeConstraints { make in
            make.height.equalToSuperview().dividedBy(24)
            make.width.equalTo(todayIndicator).multipliedBy(1.3)
            make.center.equalToSuperview()
        }

        dotIndicator.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().dividedBy(12)
            make.height.equalTo(dotIndicator.snp.width)
            make.bottom.equalToSuperview().multipliedBy(7.0 / 8.0)
        }

        todayIndicator.snp.makeConstraints { make in
            make.width.equalToSuperview().dividedBy(2)
            make.height.equalTo(todayIndicator.snp.width)
            make.center.equalToSuperview()
        }

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
