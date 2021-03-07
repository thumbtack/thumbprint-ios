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

import Foundation

@objc public protocol CalendarPickerDelegate: AnyObject {
    /**
     Tells the delegate that calendar picker's height is about to change.

     If animating the change, this is a good place to call `layoutIfNeeded()` to ensure that the layout is
     clean before the animation begins.

     - parameter CalendarPicker: A calendar picker informing the delegate about the height change
    */
    @objc optional func calendarPickerHeightWillChange(_ calendarPicker: CalendarPicker)

    /**
     Tells the delegate that calendar height has changed

     Callback occurs before the the new layout has been recomputed and applied.

     - Note: The new height can be animated simply by calling `layoutIfNeeded()` inside an animation block
     - Parameter calendarPicker: A calendar picker informing the delegate about the height change
    */
    @objc optional func calendarPickerHeightDidChange(_ calendarPicker: CalendarPicker)

    /**
     Tells the delegate the the visible month has changed

     - parameter calendarPicker: A calendar picker informing the delegate about the visible month change
     - parameter month: The index of the newly visible month, starting at 1
     - parameter year: The year of the newly visible month
    */
    @objc optional func calendarPicker(_ calendarPicker: CalendarPicker, didScrollToMonth month: Int, year: Int)

    /**
     Tells the delegate that the passed date has been selected by the user.

     - Note: Setting `selectedDates` will not trigger this callback
     - Parameter calendarPicker: A calendar picker informing the delegate about date selection
     - Parameter date: The date selected by the user
    */
    @objc optional func calendarPicker(_ calendarPicker: CalendarPicker, didSelectDate date: Date)

    /**
     Tells the delegate that the passed date has been deselected by the user.

     - Note: Setting `selectedDates` will not trigger this callback
     - Parameter calendarPicker: A calendar picker informing the delegate about date deselection
     - Parameter date: The date deselected by the user
    */
    @objc optional func calendarPicker(_ calendarPicker: CalendarPicker, didDeselectDate date: Date)

    /**
     Asks the delegate that the passed date should be selected.

     Implement this method if you want to conditional check if a selection should be allowed. It not implemented,
     selection will occur by default.

     - Parameter calendarPicker: A calendar picker informing the delegate about date selection
     - Parameter date: The date selected by the user
     - Returns: Whether the passed date should be selected
    */
    @objc optional func calendarPicker(_ calendarPicker: CalendarPicker, shouldSelectDate date: Date) -> Bool

    /**
     Asks the delegate that the passed date should be deselected.

     Implement this method if you want to conditional check if a deselection should be allowed. It not implemented,
     deselection will occur by default.

     - Parameter calendarPicker: A calendar picker informing the delegate about date deselection
     - Parameter date: The date deselected by the user
     - Returns: Whether the passed date should be deselected
     */
    @objc optional func calendarPicker(_ calendarPicker: CalendarPicker, shouldDeselectDate date: Date) -> Bool

    /**
     Asks the delegate for the month header view to display for a given month

     Implement this method if you want to display a header view above each month.

     Note: You will also need to set headerHeight on the on the calendarPicker. Dynamic height with autolayout is
     not supported.

     - Parameter calendarPicker: A calendar picker requesting a header view
     - Parameter month: The month index of the header view, starting at 1
     - Parameter year: The year index of the header view
     - Parameter indexPath: The index path needed to deque a reusable header view from the calendar picker
     - Returns: A reusable header view for the given month and year
    */
    @objc optional func calendarPicker(_ calendarPicker: CalendarPicker,
                                       headerForMonth month: Int,
                                       year: Int,
                                       indexPath: IndexPath) -> UICollectionReusableView
}
