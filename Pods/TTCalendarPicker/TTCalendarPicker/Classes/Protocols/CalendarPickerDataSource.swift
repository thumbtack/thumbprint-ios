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

public protocol CalendarPickerDataSource: AnyObject {
    /**
     Required. Asks the data source for a date cell for the given day

     - Parameter calendarPicker: The calendar picker that will display the date cell
     - Parameter day: The day of the month of the cell to be displayed, starting at 1
     - Parameter month: The month of the year of the cell to be displayed, starting at 1
     - Parameter year: The year of the cell to be displayed
     - Parameter inVisbileMonth: True if the date belongs to the visible month.  False if the day is an "in date" or an
       "out date", days in the first and last weeks that belong to the previous and next months.
     - Parameter indexPath: The indexPath needed to deque a reusable date cell from the calendar picker

     - Returns: A `UICollectionViewCell` representing the given day
    */
    func calendarPicker(_ calendarPicker: CalendarPicker,
                      cellForDay day: Int,
                      month: Int,
                      year: Int,
                      inVisibleMonth: Bool,
                      at indexPath: IndexPath) -> UICollectionViewCell
}
