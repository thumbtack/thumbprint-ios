import Thumbprint
import UIKit

public class CalendarPickerInspectableView: UIView, InspectableView, CalendarPickerViewDelegate {
    enum SelectionMode {
        case normal
        case slash
        case dot
    }

    let calendarPicker = TodayAdjustableCalendarPicker()
    static var name: String {
        "Calendar Picker"
    }

    var disableDrag: Bool = true
    var selectionMode: SelectionMode = .normal
    var slashedDates: Set<Date> = Set()
    var dottedDates: Set<Date> = Set()

    var inspectableProperties: [InspectableProperty] {
        let hideBorderProperty = BoolInspectableProperty(inspectedView: inspectableBorderView)
        hideBorderProperty.title = "Hide playground border?"
        hideBorderProperty.property = \InspectableBorderView.isHidden

        let hideHeadersProperty = BoolInspectableProperty(inspectedView: calendarPicker)
        hideHeadersProperty.title = "Hide headers"
        hideHeadersProperty.property = \TodayAdjustableCalendarPicker.hideHeader

        let todayProperty = DateInspectableProperty(inspectedView: calendarPicker)
        todayProperty.title = "Today's Date"
        todayProperty.property = \TodayAdjustableCalendarPicker._today

        let previousMonthCountProperty = OptionalIntInspectableProperty(inspectedView: calendarPicker)
        previousMonthCountProperty.title = "Previous Month Count"
        previousMonthCountProperty.property = \TodayAdjustableCalendarPicker.previousMonthCount

        let additionalMonthCountProperty = OptionalIntInspectableProperty(inspectedView: calendarPicker)
        additionalMonthCountProperty.title = "Addtl Month Count"
        additionalMonthCountProperty.property = \TodayAdjustableCalendarPicker.additionalMonthCount

        let allowsSelectionProperty = BoolInspectableProperty(inspectedView: calendarPicker)
        allowsSelectionProperty.title = "Allows Selection"
        allowsSelectionProperty.property = \TodayAdjustableCalendarPicker.allowsSelection

        let allowsMultipleSelectionProperty = BoolInspectableProperty(inspectedView: calendarPicker)
        allowsMultipleSelectionProperty.title = "Mutiple Selection"
        allowsMultipleSelectionProperty.property = \TodayAdjustableCalendarPicker.allowsMultipleSelection

        let calendarHeightModeProperty =
            DropdownInspectableProperty(inspectedView: calendarPicker,
                                        property: \CalendarPickerView.calendarHeightMode,
                                        values: [
                                            (.fixed, "fixed"),
                                            (.dynamic, "dynamic"),
                                        ])
        calendarHeightModeProperty.title = "Height mode"

        let selectionModeProperty =
            DropdownInspectableProperty(inspectedView: self,
                                        property: \CalendarPickerInspectableView.selectionMode,
                                        values: [
                                            (.normal, "normal"),
                                            (.slash, "slash"),
                                            (.dot, "dot"),
                                        ])
        selectionModeProperty.title = "Selection Override (Testing)"

        return [
            hideBorderProperty,
            hideHeadersProperty,
            todayProperty,
            previousMonthCountProperty,
            additionalMonthCountProperty,
            allowsSelectionProperty,
            allowsMultipleSelectionProperty,
            calendarHeightModeProperty,
            selectionModeProperty,
        ]
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        calendarPicker.delegate = self

        addSubview(calendarPicker)
        calendarPicker.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func calendarPicker(_ calendarPicker: CalendarPickerView, cellHasDotForDate date: Date) -> Bool {
        dottedDates.contains(date)
    }

    public func calendarPicker(_ calendarPicker: CalendarPickerView, cellHasSlashForDate date: Date) -> Bool {
        slashedDates.contains(date)
    }

    public func calendarPicker(_ calendarPicker: CalendarPickerView, shouldSelectDate date: Date) -> Bool {
        handleTapOn(date: date)
    }

    public func calendarPicker(_ calendarPicker: CalendarPickerView, shouldDeselectDate date: Date) -> Bool {
        handleTapOn(date: date)
    }

    private func handleTapOn(date: Date) -> Bool {
        switch selectionMode {
        case .normal:
            return true
        case .dot:
            if dottedDates.contains(date) {
                dottedDates.remove(date)
            } else {
                dottedDates.insert(date)
            }
        case .slash:
            if slashedDates.contains(date) {
                slashedDates.remove(date)
            } else {
                slashedDates.insert(date)
            }
        }

        calendarPicker.reloadData()
        return false
    }

    static func makeInspectable() -> UIView & InspectableView {
        let inspectable = CalendarPickerInspectableView()
        inspectable.snp.makeConstraints { make in
            make.width.equalTo(375)
        }
        return inspectable
    }
}

class TodayAdjustableCalendarPicker: CalendarPickerView {
    var _today = Date() { // swiftlint:disable:this identifier_name
        didSet {
            reloadData()
        }
    }

    override var today: Date {
        _today
    }
}
