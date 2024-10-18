@testable import Thumbprint
import UIKit
import XCTest

class CalendarPickerViewTest: SnapshotTestCase {
    private var calendarPicker: TestCalendarPickerView!
    private var today: Date!
    private var calendar: Calendar!

    override func setUp() {
        super.setUp()
        calendar = Calendar.current
        today = calendar.date(from: DateComponents(year: 2020, month: 1, day: 1))!
        calendarPicker = TestCalendarPickerView(visibleDate: today, calendar: calendar)
        calendarPicker._today = today
    }

    override func tearDown() {
        calendarPicker = nil
        today = nil
        calendar = nil
        super.tearDown()
    }

    @MainActor func testNoPreviousMonths() {
        calendarPicker.previousMonthCount = 0
        calendarPicker.additionalMonthCount = 1
        verify()
    }

    @MainActor func testNoAdditionalMonths() {
        calendarPicker.previousMonthCount = 1
        calendarPicker.additionalMonthCount = 0
        verify()
    }

    @MainActor func testFixedCellHeight() {
        calendarPicker.cellHeightMode = .fixed(70)
        verify()
    }

    @MainActor func testGoToDate() {
        calendarPicker.goToDate(Calendar.current.date(from: DateComponents(year: 2021, month: 1, day: 20))!, animated: false)
        verify()
    }

    @MainActor func testRecreateFigmaMock() {
        calendarPicker.selectedDates = [
            calendar.date(from: DateComponents(year: 2020, month: 1, day: 10))!,
        ]

        calendarPicker.dottedDates = [
            calendar.date(from: DateComponents(year: 2020, month: 1, day: 13))!,
            calendar.date(from: DateComponents(year: 2020, month: 1, day: 14))!,
            calendar.date(from: DateComponents(year: 2020, month: 1, day: 17))!,
        ]

        calendarPicker.slashedDates = [
            calendar.date(from: DateComponents(year: 2020, month: 1, day: 15))!,
            calendar.date(from: DateComponents(year: 2020, month: 1, day: 16))!,
        ]

        verify()
    }

    @MainActor func testMultipleSelection() {
        calendarPicker.allowsMultipleSelection = true
        calendarPicker.selectedDates = [
            calendar.date(from: DateComponents(year: 2020, month: 1, day: 4))!,
            calendar.date(from: DateComponents(year: 2020, month: 1, day: 9))!,
            calendar.date(from: DateComponents(year: 2020, month: 1, day: 13))!,
            calendar.date(from: DateComponents(year: 2020, month: 1, day: 30))!,
        ]

        verify()
    }

    @MainActor func testFixedHeight() {
        calendarPicker.calendarHeightMode = .fixed
        verify()
    }

    @MainActor func testNonGregorianCalendar() {
        calendar = Calendar(identifier: .hebrew)
        calendar.locale = Locale(identifier: "he_IL")
        calendarPicker = TestCalendarPickerView(visibleDate: today, calendar: calendar)
        verify(identifier: "hebrew")

        calendar = Calendar(identifier: .indian)
        calendar.locale = Locale(identifier: "bn_IN")
        calendarPicker = TestCalendarPickerView(visibleDate: today, calendar: calendar)
        verify(identifier: "indian")
    }

    @MainActor private func verify(identifier: String? = nil) {
        verify(view: calendarPicker,
               identifier: identifier,
               contentSizeCategories: [.unspecified])
    }
}

private class TestCalendarPickerView: CalendarPickerView, CalendarPickerViewDelegate {
    var slashedDates: Set<Date> = Set()
    var dottedDates: Set<Date> = Set()

    var _today = Date()
    override var today: Date {
        _today
    }

    override init(visibleDate: Date = Date(), calendar: Calendar = Calendar.current, adjustsFontForContentSizeCategory: Bool = true) {
        super.init(visibleDate: visibleDate, calendar: calendar, adjustsFontForContentSizeCategory: adjustsFontForContentSizeCategory)
        delegate = self
    }

    func calendarPicker(_ calendarPicker: CalendarPickerView, cellHasSlashForDate date: Date) -> Bool {
        slashedDates.contains(date)
    }

    func calendarPicker(_ calendarPicker: CalendarPickerView, cellHasDotForDate date: Date) -> Bool {
        dottedDates.contains(date)
    }
}
