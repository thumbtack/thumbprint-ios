// Copyright 2019 Thumbtack, Inc.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import UIKit

public enum CalendarHeightMode {
    case dynamic
    case fixed
}

public enum CalendarCellHeightMode {
    case aspectRatio(_: CGFloat)
    case fixed(_: CGFloat)
}

struct CalendarStyle {
    var calendarHeightMode: CalendarHeightMode = .fixed
    var cellHeightMode: CalendarCellHeightMode = .aspectRatio(0.88)
    var contentInsets: UIEdgeInsets = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)
    var cellSpacingX: CGFloat = 1
    var cellSpacingY: CGFloat = 1
    var headerHeight: CGFloat?
}

class MonthLayout {
    let month: Int
    let year: Int
    let calendar: Calendar
    let layoutWidth: CGFloat
    let style: CalendarStyle

    private var headerHeight: CGFloat { return style.headerHeight ?? 0 }

    var numberOfWeeks: Int {
        switch style.calendarHeightMode {
        case .dynamic:
            return weeksInMonth
        case .fixed:
            return maxWeeks
        }
    }

    var numberOfCells: Int {
        return numberOfWeeks * weekLength
    }

    func frameForMonthHeader() -> CGRect {
        return CGRect(
            x: style.contentInsets.left,
            y: style.contentInsets.top,
            width: layoutWidth - style.contentInsets.left - style.contentInsets.right,
            height: headerHeight
        )
    }

    func frameForCell(at index: Int) -> CGRect {
        return frame(
            forRow: index / weekLength,
            column: index % weekLength
        )
    }

    var backgroundFrame: CGRect {
        let cellAreaHeight = CGFloat(numberOfWeeks) * cellHeight
        let spacingAreaHeight = CGFloat(numberOfWeeks + 1) * style.cellSpacingY
        let cellAreaWidth = CGFloat(weekLength) * cellWidth
        let spacingAreaWidth = CGFloat(weekLength + 1) * style.cellSpacingX
        return CGRect(
            x: style.contentInsets.left,
            y: style.contentInsets.top + headerHeight,
            width: cellAreaWidth + spacingAreaWidth,
            height: cellAreaHeight + spacingAreaHeight
        )
    }

    func dateForCell(at index: Int) -> Date {
        return calendar.date(byAdding: DateComponents(day: index), to: dateOfIndexZero)!
    }

    var preferredHeight: CGFloat {
        let cellArea: CGFloat = cellHeight * CGFloat(numberOfWeeks)
        let borderArea: CGFloat = style.cellSpacingY * CGFloat(numberOfWeeks + 1)
        return cellArea + borderArea + headerHeight + style.contentInsets.top + style.contentInsets.bottom
    }

    init(month: Int, year: Int, calendar: Calendar, layoutWidth: CGFloat, calendarStyle: CalendarStyle) {
        self.calendar = calendar
        self.layoutWidth = layoutWidth
        self.style = calendarStyle

        // Normalize month and year
        let date = DateComponents(calendar: calendar, year: year, month: month).date!
        let components = calendar.dateComponents([.year, .month], from: date)
        self.month = components.month!
        self.year = components.year!
    }

    // MARK: - Private Implementation
    private func frame(forRow row: Int, column: Int) -> CGRect {
        return CGRect(
            x: offset(forColumn: column),
            y: offset(forRow: row),
            width: cellWidth,
            height: cellHeight
        )
    }

    private var cellHeight: CGFloat {
        switch style.cellHeightMode {
        case let .aspectRatio(aspectRatio):
            return (aspectRatio * (cellWidth))
        case let .fixed(fixedHeight):
            return (fixedHeight)
        }
    }

    private var cellWidth: CGFloat {
        let monthWidth = layoutWidth - style.contentInsets.left - style.contentInsets.right
        let backgroundAreaWidth = style.cellSpacingX * CGFloat(weekLength + 1)
        return ((monthWidth - backgroundAreaWidth) / CGFloat(weekLength))
    }

    private func offset(forRow row: Int) -> CGFloat {
        let heightOfPreviousCells = cellHeight * CGFloat(row)
        let heightOfPreviousSpacing = style.cellSpacingY * CGFloat(row + 1)
        return style.contentInsets.top + headerHeight + heightOfPreviousCells + heightOfPreviousSpacing
    }

    private func offset(forColumn column: Int) -> CGFloat {
        let widthOfPreviousCells = cellWidth * CGFloat(column)
        let widthOfPreviousSpacing = CGFloat(column + 1) * style.cellSpacingX
        return style.contentInsets.left + widthOfPreviousCells + widthOfPreviousSpacing
    }

    private lazy var dateOfTheFirst: Date = {
        calendar.date(from: DateComponents(year: year, month: month, day: 1))!
    }()

    private lazy var dateOfIndexZero: Date = {
        let components = DateComponents(day: -firstWeekday + 1)
        return calendar.date(byAdding: components, to: dateOfTheFirst)!
    }()

    private lazy var firstWeekday: Int = {
        calendar.component(.weekday, from: dateOfTheFirst)
    }()

    private lazy var weekLength: Int = {
        calendar.maximumRange(of: .weekday)!.last!
    }()

    private lazy var weeksInMonth: Int = {
        calendar.range(of: .weekOfMonth, in: .month, for: dateOfTheFirst)!.count
    }()

    private lazy var maxWeeks: Int = {
        calendar.maximumRange(of: .weekOfMonth)!.last!
    }()

}
