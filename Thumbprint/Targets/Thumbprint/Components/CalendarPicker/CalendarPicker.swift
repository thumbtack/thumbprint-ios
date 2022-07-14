import TTCalendarPicker
import UIKit

@objc
public protocol CalendarPickerViewDelegate: AnyObject {
    /// Called when a dynamic height calendar scrolls to a month with a different number of weeks
    @objc optional func calendarPickerHeightDidChange(_ calendarPicker: CalendarPickerView)

    /// Called immediately after a calendar scrolls to a new month, before any height adjustments occur
    @objc optional func calendarPicker(_ calendarPicker: CalendarPickerView, didShowMonth month: Int, year: Int)

    /// Return false to disable the cell for the given date
    @objc optional func calendarPicker(_ calendarPicker: CalendarPickerView, cellIsEnabledForDate date: Date) -> Bool

    /// Return true to add a dot to the cell with the given date
    @objc optional func calendarPicker(_ calendarPicker: CalendarPickerView, cellHasDotForDate date: Date) -> Bool

    /// Return true to add a slash to the cell with the given date
    @objc optional func calendarPicker(_ calendarPicker: CalendarPickerView, cellHasSlashForDate date: Date) -> Bool

    /// Implement this method and return false to prevent selection of the given date
    @objc optional func calendarPicker(_ calendarPicker: CalendarPickerView, shouldSelectDate date: Date) -> Bool

    /// Implement this method and return false to prevent deselection of the given date
    @objc optional func calendarPicker(_ calendarPicker: CalendarPickerView, shouldDeselectDate date: Date) -> Bool

    /// Called in response to a date being selected
    @objc optional func calendarPicker(_ calendarPicker: CalendarPickerView, didSelectDate date: Date)

    /// Called in response to a date being deselected
    @objc optional func calendarPicker(_ calendarPicker: CalendarPickerView, didDeselectDate date: Date)
}

// MARK: Public Interface
public extension CalendarPickerView {
    /// The default content insets set on an unmodified CalendarPickerView instance
    static let defaultContentInsets = UIEdgeInsets(top: 0, left: Space.three, bottom: Space.three, right: Space.three)

    /// The default cellHeightMode set on an unmodified CalendarPickerView instance
    static let defaultCellHeightMode: CalendarCellHeightMode = .aspectRatio(1)

    /// The number of months, before today's month, to which the user should be allowed to scroll backwards.
    /// If nil, the user may scroll back indefinitely
    /// Default: nil
    var previousMonthCount: Int? {
        get { picker.previousMonthCount }
        set {
            picker.previousMonthCount = newValue
            updatePrevNextButtonState()
        }
    }

    /// The nubmer of months, after today's month, to which the user should be allowed to scroll.
    /// If nil, the user may scroll forward indefinitely
    /// Default: nil
    var additionalMonthCount: Int? {
        get { picker.additionalMonthCount }
        set {
            picker.additionalMonthCount = newValue
            updatePrevNextButtonState()
        }
    }

    /// A boolean value specifying whether a user should be able to select dates on the calendar
    /// Default: true
    var allowsSelection: Bool {
        get { picker.allowsSelection }
        set { picker.allowsSelection = newValue }
    }

    /// A boolean value specifying whether a user should be able to select multiple dates at once
    /// Default: false
    var allowsMultipleSelection: Bool {
        get { picker.allowsMultipleSelection }
        set { picker.allowsMultipleSelection = newValue }
    }

    /// Selected dates, at midnight in the timezone of the calendarPicker's calendar
    var selectedDates: [Date] {
        get { picker.selectedDates }
        set {
            picker.selectedDates = newValue
            picker.reloadData()
        }
    }

    /// Either .fixed with a constant cell height, or .aspectRatio with a height that depends on the cells width
    /// Default: .aspectRatio(1)
    var cellHeightMode: CalendarCellHeightMode {
        get { picker.cellHeightMode }
        set { picker.cellHeightMode = newValue }
    }

    /// Either .fixed to the maximum number of weeks that can appear in a month, or .dynamic, adjusting the calendar's
    /// height to just encapsulate the nubmer of weeks in the given month
    /// Default: .dynamic
    var calendarHeightMode: CalendarHeightMode {
        get { picker.calendarHeightMode }
        set {
            guard picker.calendarHeightMode != newValue else { return }
            picker.calendarHeightMode = newValue
            picker.reloadData()
        }
    }

    /// The insets within the calendarPicker's frame in which the picker contents are rendered.
    /// Note: Adjusting these insets will have a slightly different effect on the grid that just making the frame
    /// smaller.  In particular, when scrolling the calendar, cells will still appear from the edges of the frame.
    var contentInsets: UIEdgeInsets {
        get { _contentInsets }
        set { _contentInsets = newValue }
    }

    /// True if the component should hide the month header, and the prev/next month buttons
    var hideHeader: Bool {
        get { headerContent.isHidden }
        set { headerContent.isHidden = newValue }
    }

    /// The month currently visible on the calendar (not including in and out dates)
    var visibleMonth: Int { picker.visibleMonth }

    /// The year currently visible on the calendar (not including in and out dates)
    var visibleYear: Int { picker.visibleYear }

    /// The calendar the picker is using for date computations
    var calendar: Calendar { picker.calendar }

    /// Scrolls the calendar to the selected date, optionally animated
    func goToDate(_ date: Date, animated: Bool) {
        let components = picker.calendar.dateComponents([.month, .year], from: date)
        picker.scrollTo(month: components.month!, year: components.year!, animated: animated) // swiftlint:disable:this force_unwrapping
    }

    /// Scrolls the calendar to the month immediately after the visible month, optionally animated
    func goToNextMonth(animated: Bool) {
        picker.scrollToNext(animated: animated)
    }

    /// Scrolls the calendar to the month immediately preceeding the visible month, optionally animated
    func goToPreviousMonth(animated: Bool) {
        picker.scrollToPrev(animated: animated)
    }

    /// Reloads the calendarPicker
    func reloadData() {
        picker.reloadData()
    }
}

open class CalendarPickerView: UIView, UIContentSizeCategoryAdjusting {
    public weak var delegate: CalendarPickerViewDelegate?

    public var adjustsFontForContentSizeCategory: Bool {
        didSet {
            guard adjustsFontForContentSizeCategory != oldValue else { return }

            monthHeader.adjustsFontForContentSizeCategory = adjustsFontForContentSizeCategory
        }
    }

    private let stack: UIStackView
    private let headerContent = UIStackView()
    private let picker: CalendarPicker
    private let dayOfWeekHeaderView: DayOfWeekHeaderView
    private let monthHeader: Label

    private let leftButton = IconButton(icon: Icon.navigationCaretLeftMedium.image,
                                        accessibilityLabel: "Previous Month")

    private let rightButton = IconButton(icon: Icon.navigationCaretRightMedium.image,
                                         accessibilityLabel: "Next Month")

    private lazy var monthFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = picker.calendar
        formatter.dateFormat = "MMMM yyyy"
        return formatter
    }()

    open var today: Date { Date() }

    private var todayComponents: DateComponents {
        picker.calendar.dateComponents([.year, .month, .day], from: today)
    }

    private var _contentInsets: UIEdgeInsets {
        didSet { updateInsets() }
    }

    public init(visibleDate: Date = Date(), calendar: Calendar = Calendar.current, adjustsFontForContentSizeCategory: Bool = true) {
        self.adjustsFontForContentSizeCategory = adjustsFontForContentSizeCategory

        self.dayOfWeekHeaderView = DayOfWeekHeaderView(calendar: calendar)
        dayOfWeekHeaderView.layoutMargins = UIEdgeInsets(top: 0, left: Space.three, bottom: 0, right: Space.three)
        self.picker = CalendarPicker(date: visibleDate, calendar: calendar)

        self.monthHeader = Label(textStyle: .title3, adjustsFontForContentSizeCategory: adjustsFontForContentSizeCategory)
        monthHeader.setContentHuggingPriority(.defaultHigh, for: .vertical)
        monthHeader.setContentHuggingPriority(.defaultLow, for: .horizontal)
        headerContent.alignment = .center
        headerContent.spacing = Space.two
        headerContent.isLayoutMarginsRelativeArrangement = true
        headerContent.addArrangedSubview(monthHeader)
        headerContent.addArrangedSubview(leftButton)
        headerContent.addArrangedSubview(rightButton)
        headerContent.setCustomSpacing(Space.five, after: leftButton)

        self.stack = UIStackView(arrangedSubviews: [headerContent, dayOfWeekHeaderView, picker])
        stack.setCustomSpacing(Space.three, after: headerContent)
        stack.setCustomSpacing(Space.one, after: dayOfWeekHeaderView)
        stack.axis = .vertical

        self._contentInsets = Self.defaultContentInsets

        super.init(frame: .null)

        backgroundColor = Color.white

        picker.registerDateCell(CalendarPickerDateCell.self,
                                withReuseIdentifier: CalendarPickerDateCell.reuseIdentifier)

        picker.gridInsets = .zero
        picker.cellSpacingX = 0
        picker.cellSpacingY = 0
        picker.cellHeightMode = Self.defaultCellHeightMode
        picker.calendarHeightMode = .dynamic
        picker.dataSource = self
        picker.delegate = self

        picker.gridInsets = UIEdgeInsets(
            top: 0,
            left: Space.three,
            bottom: Space.three,
            right: Space.three
        )

        leftButton.addTarget(self, action: #selector(scrollToPreviousMonth), for: .touchUpInside)
        rightButton.addTarget(self, action: #selector(scrollToNextMonth), for: .touchUpInside)

        addSubview(stack)

        stack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        updateInsets()
        updateMonthHeader()
        updatePrevNextButtonState()
    }

    @objc private func scrollToPreviousMonth() {
        picker.scrollToPrev()
    }

    @objc private func scrollToNextMonth() {
        picker.scrollToNext()
    }

    private func updateMonthHeader() {
        let year = picker.visibleYear
        let month = picker.visibleMonth
        let date = picker.calendar.date(from: DateComponents(year: year, month: month, day: 1))! // swiftlint:disable:this force_unwrapping
        let text = monthFormatter.string(from: date)

        UIView.transition(with: monthHeader,
                          duration: Duration.three,
                          options: .transitionCrossDissolve,
                          animations: {
                              self.monthHeader.text = text
                          },
                          completion: nil)
    }

    private func updatePrevNextButtonState() {
        leftButton.isEnabled = picker.canScrollBackwards
        rightButton.isEnabled = picker.canScrollForwards
    }

    private func updateInsets() {
        let t = _contentInsets.top
        let l = _contentInsets.left
        let b = _contentInsets.bottom
        let r = _contentInsets.right

        picker.gridInsets = UIEdgeInsets(top: 0, left: l, bottom: b, right: r)
        dayOfWeekHeaderView.layoutMargins = UIEdgeInsets(top: 0, left: l, bottom: 0, right: r)
        headerContent.layoutMargins = UIEdgeInsets(top: t, left: l, bottom: 0, right: r)
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CalendarPickerView: CalendarPickerDataSource {
    public func calendarPicker(_ calendarPicker: CalendarPicker,
                               cellForDay day: Int,
                               month: Int,
                               year: Int,
                               inVisibleMonth: Bool,
                               at indexPath: IndexPath) -> UICollectionViewCell {
        let cell = picker.dequeReusableDateCell(withReuseIdentifier: CalendarPickerDateCell.reuseIdentifier,
                                                indexPath: indexPath) as! CalendarPickerDateCell

        let components = DateComponents(year: year, month: month, day: day)
        let date = picker.calendar.date(from: components)! // swiftlint:disable:this force_unwrapping
        let isToday = todayComponents == components
        cell.configure(withDay: day,
                       inVisibleMonth: inVisibleMonth,
                       isToday: isToday,
                       showDot: delegate?.calendarPicker?(self, cellHasDotForDate: date) ?? false,
                       showSlash: delegate?.calendarPicker?(self, cellHasSlashForDate: date) ?? false,
                       isEnabled: delegate?.calendarPicker?(self, cellIsEnabledForDate: date) ?? true)
        return cell
    }
}

extension CalendarPickerView: TTCalendarPicker.CalendarPickerDelegate {
    public func calendarPickerHeightWillChange(_ calendarPicker: CalendarPicker) {
        layoutIfNeeded()
    }

    public func calendarPickerHeightDidChange(_ calendarPicker: CalendarPicker) {
        UIView.animate(withDuration: Duration.five) {
            self.layoutIfNeeded()
        }
        nonSelfDelegate?.calendarPickerHeightDidChange?(self)
    }

    public func calendarPicker(_ calendarPicker: CalendarPicker, didScrollToMonth month: Int, year: Int) {
        updateMonthHeader()
        updatePrevNextButtonState()
        nonSelfDelegate?.calendarPicker?(self, didShowMonth: month, year: year)
    }

    public func calendarPicker(_ calendarPicker: CalendarPicker, didSelectDate date: Date) {
        nonSelfDelegate?.calendarPicker?(self, didSelectDate: date)
    }

    public func calendarPicker(_ calendarPicker: CalendarPicker, didDeselectDate date: Date) {
        nonSelfDelegate?.calendarPicker?(self, didDeselectDate: date)
    }

    public func calendarPicker(_ calendarPicker: CalendarPicker, shouldSelectDate date: Date) -> Bool {
        guard nonSelfDelegate?.calendarPicker?(self, cellIsEnabledForDate: date) ?? true else {
            return false
        }
        return nonSelfDelegate?.calendarPicker?(self, shouldSelectDate: date) ?? true
    }

    public func calendarPicker(_ calendarPicker: CalendarPicker, shouldDeselectDate date: Date) -> Bool {
        nonSelfDelegate?.calendarPicker?(self, shouldDeselectDate: date) ?? true
    }

    // Prevents infinite loops when delegate == self (e.g. testing subclass)
    private var nonSelfDelegate: CalendarPickerViewDelegate? {
        if delegate === self {
            return nil
        } else {
            return delegate
        }
    }
}
