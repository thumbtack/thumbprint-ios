import UIKit

class DayOfWeekHeaderView: UIView {
    private let stackView: UIStackView

    init(calendar: Calendar) {
        let weekdaySymbols: [String]
        if calendar.locale?.languageCode == "en" {
            weekdaySymbols = calendar.weekdaySymbols.map({ String($0.prefix(2)) })
        } else {
            weekdaySymbols = calendar.veryShortWeekdaySymbols
        }

        let labels = weekdaySymbols.map({ (weekday: String) -> Label in
            let label = Label(textStyle: .title8, adjustsFontForContentSizeCategory: false)
            label.text = weekday
            label.textAlignment = .center
            return label
        })

        stackView = UIStackView(arrangedSubviews: labels)
        stackView.axis = .horizontal
        stackView.spacing = .zero
        stackView.alignment = .fill
        stackView.distribution = .fillEqually

        super.init(frame: .null)

        addSubview(stackView)

        stackView.snp.makeConstraints { make in
            make.edges.equalTo(self.snp.margins)
        }
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
