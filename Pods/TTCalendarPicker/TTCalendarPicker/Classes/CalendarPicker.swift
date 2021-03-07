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
import SnapKit

public class CalendarPicker: UIView {
    /// The calendar that will be used to perform date calculations inside the picker
    public let calendar: Calendar

    /// The number of months before the visible month that the user should be able to navigate back to.  If nil, the
    /// user may navigate arbitrarily far into the past.  Default: nil
    public var previousMonthCount: Int?

    /// The number of months after the initial month that the user should be able to navigate forward to.  If nil, the
    /// user may navigate arbitrarily far into the future. Default: nil
    public var additionalMonthCount: Int?

    /// Optional delegate to provide additional styling elements, and to respond to user interaction
    public weak var delegate: CalendarPickerDelegate?

    /// DataSource provides configured date cells back to the calendar picker
    /// - Important
    ///     - Without the dataSource set, the calendar will appear blank
    public weak var dataSource: CalendarPickerDataSource?

    private let initialMonth: Int
    private let initialYear: Int
    private let layout: CalendarPickerLayout
    private let collectionView: UICollectionView
    private var heightConstraint: Constraint?
    private var calendarStyle: CalendarStyle
    private var offset = 0
    private var targetMonthDelta: Int?
    private var selectedDateSet: Set<Date> = Set<Date>() {
        didSet {
            reloadData()
        }
    }

    private var monthLayoutCache = NSCache<NSNumber, MonthLayout>()
    private var monthCacheNeedsUpdate = true
    private var pickerNeedsReload = false

    /// Initializes a new calendarPicker
    /// Parameters:
    ///  - date: A date within the month and year that calendar should initially display
    ///  - calendar: The calendar with which the picker will perform date computations.  Default is the users current
    ///              calendar.
    public convenience init(date: Date, calendar: Calendar = Calendar.current) {
        let components = calendar.dateComponents([.month, .year], from: date)
        self.init(month: components.month!, year: components.year!, calendar: calendar)
    }

    /// Initializes a new calendarPicker
    /// Parameters:
    ///  - month: The month that the calendar picker should initially display, where 1 represents January
    ///  - year: The year that the calendar picker should initially display
    ///  - calendar: The calendar with which the picker will perform date computations.  Default is the users current
    ///              calendar.
    public init(month: Int, year: Int, calendar: Calendar = Calendar.current) {
        self.initialMonth = month
        self.initialYear = year
        self.calendar = calendar
        self.layout = CalendarPickerLayout()
        self.collectionView = UICollectionView(frame: .null, collectionViewLayout: layout)
        self.calendarStyle = CalendarStyle()

        super.init(frame: .null)

        monthLayoutCache.countLimit = 5

        backgroundColor = .white

        collectionView.backgroundColor = .white
        collectionView.alwaysBounceVertical = false
        collectionView.isPagingEnabled = true
        collectionView.allowsSelection = true
        collectionView.allowsMultipleSelection = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self

        layout.dataSource = self

        addSubview(collectionView)
        SupplementaryType.allCases.forEach({
            collectionView.register(UICollectionReusableView.self,
                                    forSupplementaryViewOfKind: $0.kind,
                                    withReuseIdentifier: SupplementaryType.defaultIdentifier)
        })

        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            //  Higher than defaultHigh priority to avoid ambiguity with compression/hugging priority of contents.
            heightConstraint = make.height.equalTo(0).priority(ConstraintPriority(875.0)).constraint
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func layoutSubviews() {
        super.layoutSubviews()

        if monthCacheNeedsUpdate {
            monthCacheNeedsUpdate = false
            monthLayoutCache.removeAllObjects()
            layout.invalidateLayout()
            invalidateHeightAndNotifyDelegate()
        }

        if pickerNeedsReload {
            pickerNeedsReload = false
            reloadData()
        } else {
            recenterGrid()
        }
    }

    override public var bounds: CGRect {
        didSet {
            if bounds.size != oldValue.size {
                setMonthCacheNeedsUpdate()
            }
        }
    }
}

// MARK: - Additional Publicly Configurable Parameters
public extension CalendarPicker {
    /// The month that the calendarPicker is currently displaying. Index starts at 1.
    var visibleMonth: Int {
        return monthLayout(forSection: .currentMonth).month
    }

    /// The year of the month that the calendarPicker is currently displaying.
    var visibleYear: Int {
        return monthLayout(forSection: .currentMonth).year
    }

    /// The calendarHeightMode by which the picker computes its own height. Default: `fixed`
    /// - Value can be either:
    ///   - `fixed`, the picker always shows the maximum number of weeks possible ; or
    ///   - `dynamic` the picker adjusts its size to only show the number of weeks in the current month.
    var calendarHeightMode: CalendarHeightMode {
        get { return calendarStyle.calendarHeightMode }
        set {
            calendarStyle.calendarHeightMode = newValue
            setMonthCacheNeedsUpdate()
            setPickerNeedsReload()
        }
    }

    /// The CellHeightMode by which the picker computes it's cells' heights. Default: `.aspectRatio(0.88)`
    /// - Value can be either:
    ///   - `fixed`, for cells with a consistent cell height; or
    ///   - `aspectRatio` for cells whose height varies with the collection view width.
    var cellHeightMode: CalendarCellHeightMode {
        get { return  calendarStyle.cellHeightMode }
        set {
            calendarStyle.cellHeightMode = newValue
            setMonthCacheNeedsUpdate()
        }
    }

    /// The insets for the cell grid.
    /// Default: UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)
    var gridInsets: UIEdgeInsets {
        get { return calendarStyle.contentInsets }
        set {
            calendarStyle.contentInsets = newValue
            setMonthCacheNeedsUpdate()
        }
    }

    /// The spacing between each column of date cells, and before and after the first and last column of cells.
    /// Default: `1`
    var cellSpacingX: CGFloat {
        get { return calendarStyle.cellSpacingX }
        set {
            calendarStyle.cellSpacingX = newValue
            setMonthCacheNeedsUpdate()
        }
    }

    /// The spacing between each row of date cells, and before and after the first and last rows of cells.
    /// Default: `1`
    var cellSpacingY: CGFloat {
        get { return calendarStyle.cellSpacingY }
        set {
            calendarStyle.cellSpacingY = newValue
            setMonthCacheNeedsUpdate()
        }
    }

    /// The height of the month header.  If nil, no additional height will be allocated for a month header.
    /// Default: `nil`
    var monthHeaderHeight: CGFloat? {
        get { return calendarStyle.headerHeight }
        set {
            calendarStyle.headerHeight = newValue
            setMonthCacheNeedsUpdate()
        }
    }

    /// The currently selected dates, at midnight in the current calendar
    var selectedDates: [Date] {
        get { return Array(selectedDateSet) }
        set {
            let datesAtMidnight = newValue.map({ calendar.midnight(on: $0) })
            selectedDateSet = Set(datesAtMidnight)
        }
    }

    var allowsSelection: Bool {
        get { return collectionView.allowsSelection }
        set { collectionView.allowsSelection = newValue }
    }

    /// Returns whether multiple selections are allowed.  Default: false
    var allowsMultipleSelection: Bool {
        get { return collectionView.allowsMultipleSelection }
        set { collectionView.allowsMultipleSelection = newValue }
    }

    /// The color of the area defined by `cellSpacingX` and `cellSpacingY`.  Default `.clear`
    var gridColor: UIColor {
        get { return layout.gridBorderColor }
        set { layout.gridBorderColor = newValue }
    }

    /// Registers a date cell class with a given reuse identifier
    func registerDateCell(_ cellClass: UICollectionViewCell.Type, withReuseIdentifier identifier: String) {
        collectionView.register(cellClass, forCellWithReuseIdentifier: identifier)
    }

    /// Registers a date cell xib with a given reuse identifier
    func registerDateCell(_ nib: UINib?, withReuseIdentifier identifier: String) {
        collectionView.register(nib, forCellWithReuseIdentifier: identifier)
    }

    /// Registers a date month header class with a given reuse identifier
    func registerMonthHeaderView(_ viewClass: AnyClass?, withReuseIdentifier identifier: String) {
        collectionView.register(viewClass, forSupplementaryViewOfKind: SupplementaryType.monthHeader.kind, withReuseIdentifier: identifier)
    }

    /// Registers a date month header xib with a given reuse identifier
    func registerMonthHeaderView(_ nib: UINib?, withReuseIdentifier identifier: String) {
        collectionView.register(nib, forSupplementaryViewOfKind: SupplementaryType.monthHeader.kind, withReuseIdentifier: identifier)
    }

    /// Returns a date cell for an indexPath, located by a reuse identifier.
    func dequeReusableDateCell(withReuseIdentifier identifier: String, indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
    }

    /// Returns a month header for an indexPath, located by a reuse identifier.
    func dequeMonthHeaderView(withReuseIdentifier identifier: String, indexPath: IndexPath) -> UICollectionReusableView {
        return collectionView.dequeueReusableSupplementaryView(ofKind: SupplementaryType.monthHeader.kind, withReuseIdentifier: identifier, for: indexPath)
    }

    /// Deselects all of the currently selected cells
    func deselectAll() {
        selectedDateSet.removeAll()
        reloadData()
    }

    /// Forces a reload of the cell and date data.
    func reloadData() {
        // If we reloadData while the user is dragging, we might leave the collectionView in an off-page state.
        // Instead we defer reload to scrollViewDidStopMotion
        if !collectionView.isDragging {
            collectionView.reloadData()
            recenterGrid()
        }
    }

    /// Navigates to the today's month and year.
    /// - Parameters:
    ///    - animated: A Boolean value that determines whether the change is animated.
    ///      If animated, places the today's month next to the visible month (to the right if it is later than the
    ///      visible month; to the left if it occurs sooner), and scrolls to it.
    @objc
    func scrollToToday(animated: Bool = true) {
        let components = calendar.dateComponents([.year, .month], from: today)
        scrollTo(month: components.month!, year: components.year!)
    }

    /// Navigates to an arbitrary month and year.
    /// - Parameters:
    ///    - animated: A Boolean value that determines whether the change is animated.
    ///      If animated, places the new month next to the visible month (to the right if it is later than the
    ///      visible month; to the left if it occurs sooner), and scrolls to it.
    @objc
    func scrollTo(month: Int, year: Int, animated: Bool = true) {
        guard isUserInteractionEnabled else { return }

        let nextComponents = DateComponents(year: year, month: month)
        var visibleComponents = DateComponents(year: initialYear, month: initialMonth)
        visibleComponents.month = visibleComponents.month! + offset

        let monthDelta = calendar.dateComponents([.month], from: visibleComponents, to: nextComponents).month!
        guard monthDelta != 0 else {
            return
        }

        // Disable user interaction until scroll is complete
        isUserInteractionEnabled = false
        targetMonthDelta = monthDelta
        collectionView.reloadData()

        scroll(months: monthDelta > 0 ? 1 : -1, animated: animated)

        if !animated {
            scrollViewDidStopMotion()
        }

    }

    /// Moves the calendar one month into the future.
    /// - Parameters:
    ///    - animated: A Boolean value that determines whether the change is animated
    /// - Note:
    ///    If moving one month forward would exceed `additionalMonthCount`, the collectionView will spring back
    @objc
    func scrollToNext(animated: Bool = true) {
        // Disable user interaction until scroll is complete
        guard isUserInteractionEnabled, canScrollForwards else { return }
        isUserInteractionEnabled = false
        scroll(months: 1, animated: animated)

        if !animated {
            scrollViewDidStopMotion()
        }
    }

    /// Moves the calendar one month into the past.
    /// - Parameters:
    ///    - animated: A Boolean value that determines whether the change is animated
    /// - Note:
    ///    If moving one month backward would exceed `previousMonthCount`, the collectionView will spring back
    @objc
    func scrollToPrev(animated: Bool = true) {
        // Disable user interaction until scroll is complete
        guard isUserInteractionEnabled, canScrollBackwards else { return }
        isUserInteractionEnabled = false
        scroll(months: -1, animated: animated)

        if !animated {
            scrollViewDidStopMotion()
        }
    }

    /// Returns false if scrolling back another month would exceed `previousMonthCount`
    var canScrollBackwards: Bool {
        guard let previousMonthCount = previousMonthCount else {
            return true
        }
        return -offset < previousMonthCount
    }

    /// Returns false if scrolling forward another month would exceed `additionalMonthCount`
    var canScrollForwards: Bool {
        guard let additionalMonthCount = additionalMonthCount else {
            return true
        }
        return offset < additionalMonthCount
    }

    /// The current date at the moment the property is accessed.
    @objc
    var today: Date {
        return Date()
    }
}

// MARK: - CalendarPickerLayout DataSource Methods
extension CalendarPicker: CalendarPickerLayoutDataSource {
    internal func monthLayout(forSection section: CalendarPickerLayout.Section) -> MonthLayout {
        let sectionOffset: Int
        if targetMonthDelta != nil && section != .currentMonth {
            let initialComponents = DateComponents(year: initialYear, month: initialMonth)
            let todayComponents = calendar.dateComponents([.year, .month], from: today)
            sectionOffset = calendar.dateComponents([.month], from: initialComponents, to: todayComponents).month!
        } else {
            sectionOffset = (offset + section.offset)
        }

        if let cachedLayout = monthLayoutCache.object(forKey: sectionOffset as NSNumber) {
            return cachedLayout
        } else {
            let monthLayout = MonthLayout(month: initialMonth + sectionOffset,
                                          year: initialYear,
                                          calendar: calendar,
                                          layoutWidth: collectionView.frame.width,
                                          calendarStyle: calendarStyle)
            monthLayoutCache.setObject(monthLayout, forKey: sectionOffset as NSNumber)
            return monthLayout
        }
    }
}

// MARK: - CollectionView DataSource Methods
extension CalendarPicker: UICollectionViewDataSource {
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return CalendarPickerLayout.Section.allCases.count
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let section = CalendarPickerLayout.Section(rawValue: section) else { return 0 }
        let monthLayout = self.monthLayout(forSection: section)
        return monthLayout.numberOfCells
    }

    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cellDate = layout.dateForCell(at: indexPath) else { return }
        if selectedDateSet.contains(cellDate) {
            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
            cell.isSelected = true
        }
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let dataSource = dataSource else {
            fatalError("DataSource cannot be nil")
        }
        guard let section = CalendarPickerLayout.Section(rawValue: indexPath.section) else {
            fatalError("Tried to retrieve a section outside of previous, current, and next months")
        }

        let layout = monthLayout(forSection: section)
        let cellDate = layout.dateForCell(at: indexPath.item)

        let components = calendar.dateComponents([.year, .month, .day], from: cellDate)
        let inVisibleMonth = components.month! == layout.month && components.year! == layout.year
        return dataSource.calendarPicker(self, cellForDay: components.day!, month: components.month!,
                                         year: components.year!, inVisibleMonth: inVisibleMonth, at: indexPath)
    }

    public func collectionView(_ collectionView: UICollectionView,
                               viewForSupplementaryElementOfKind kind: String,
                               at indexPath: IndexPath) -> UICollectionReusableView {
        guard let delegate = delegate else {
            fatalError("Delegate cannot be nil")
        }
        guard let section = CalendarPickerLayout.Section(rawValue: indexPath.section) else {
            fatalError("CollectionView requested a view for an out of bounds section")
        }

        let monthLayout = self.monthLayout(forSection: section)
        let month = monthLayout.month
        let year = monthLayout.year

        // Don't crash if the user hasn't implemented the delegate method
        let defaultView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                          withReuseIdentifier: SupplementaryType.defaultIdentifier,
                                                                          for: indexPath)
        defaultView.backgroundColor = .clear

        switch kind {
        case SupplementaryType.monthHeader.kind:
            if let header = delegate.calendarPicker?(self, headerForMonth: month, year: year, indexPath: indexPath) {
                return header
            } else {
                return defaultView
            }
        default:
            return defaultView
        }
    }

    internal func dateForCell(at indexPath: IndexPath) -> Date {
        guard let section = CalendarPickerLayout.Section(rawValue: indexPath.section) else {
            fatalError("Cannot retreive cell for invalid section: \(indexPath.section)")
        }
        return monthLayout(forSection: section).dateForCell(at: indexPath.item)
    }
}

// MARK: - CollectionView Delegate Methods
extension CalendarPicker: UICollectionViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // When the calendarView's contentSize changes, it may become possible to scroll the calendar vertically
        // This prevents that.
        if scrollView.contentOffset.y != 0 {
            scrollView.contentOffset.y = 0
        }
    }

    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate { scrollViewDidStopMotion() }
    }

    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollViewDidStopMotion()
    }

    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        scrollViewDidStopMotion()
    }

    public func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        guard let delegate = delegate else { return true }

        let date = dateForCell(at: indexPath)
        return delegate.calendarPicker?(self, shouldSelectDate: date) ?? true
    }

    public func collectionView(_ collectionView: UICollectionView, shouldDeselectItemAt indexPath: IndexPath) -> Bool {
        guard let delegate = delegate else { return true }

        let date = dateForCell(at: indexPath)
        return delegate.calendarPicker?(self, shouldDeselectDate: date) ?? true
    }

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !collectionView.allowsMultipleSelection {
            selectedDateSet.removeAll()
        }

        let date = dateForCell(at: indexPath)
        selectedDateSet.insert(date)
        delegate?.calendarPicker?(self, didSelectDate: date)
    }

    public func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let date = dateForCell(at: indexPath)
        selectedDateSet.remove(date)
        delegate?.calendarPicker?(self, didDeselectDate: date)
    }
}

// MARK: - Private Implementation
private extension CalendarPicker {
    func setMonthCacheNeedsUpdate() {
        monthCacheNeedsUpdate = true
        setNeedsLayout()
    }

    func setPickerNeedsReload() {
        pickerNeedsReload = true
        setNeedsLayout()
    }

    var currentMonthOffset: Int {
        let currentLayout = monthLayout(forSection: .currentMonth)
        let currentComponents = DateComponents(year: currentLayout.year, month: currentLayout.month)
        let initialComponents = DateComponents(year: initialYear, month: initialMonth)

        return calendar.dateComponents([.month], from: initialComponents, to: currentComponents).month!
    }

    private func scroll(months: Int, animated: Bool) {
        var offset = collectionView.contentOffset
        offset.x += collectionView.frame.width * CGFloat(months)
        collectionView.setContentOffset(offset, animated: animated)
    }

    // Called when scrolling stops, regardless of the trigger
    func scrollViewDidStopMotion() {
        let oldVisibleMonth = visibleMonth
        let oldVisibleYear = visibleYear
        let visibleRect = CGRect(origin: collectionView.contentOffset, size: collectionView.frame.size)
        if let targetOffsetDelta = targetMonthDelta {
            offset += targetOffsetDelta
        } else if visibleRect.minX == 0 {
            guard previousMonthCount == nil || previousMonthCount! > -currentMonthOffset else {
                scrollToVisibleMonth(animated: true)
                return
            }

            offset -= 1
        } else if visibleRect.maxX == collectionView.contentSize.width {
            guard additionalMonthCount == nil || additionalMonthCount! > currentMonthOffset else {
                scrollToVisibleMonth(animated: true)
                return
            }

            offset += 1
        }

        reloadData()
        setMonthCacheNeedsUpdate()

        if visibleMonth != oldVisibleMonth || visibleYear != oldVisibleYear {
            delegate?.calendarPicker?(self, didScrollToMonth: visibleMonth, year: visibleYear)
        }

        // IMPORTANT: Programmatic scroll methods disable user interaction to prevent the user from setting the
        //            calendar offset to an non page-aligned value. We need to re-enable it here.
        isUserInteractionEnabled = true
        targetMonthDelta = nil
    }

    func scrollToVisibleMonth(animated: Bool) {
        let visibleMonthOffset = CGPoint(x: self.collectionView.frame.width, y: self.collectionView.frame.height)
        collectionView.setContentOffset(visibleMonthOffset, animated: animated)
    }

    func recenterGrid() {
        collectionView.contentOffset = CGPoint(x: collectionView.frame.width, y: 0)
    }

    func invalidateHeightAndNotifyDelegate() {
        let newHeight = monthLayout(forSection: .currentMonth).preferredHeight
        guard collectionView.frame.height != newHeight else { return }
        delegate?.calendarPickerHeightWillChange?(self)
        heightConstraint?.update(offset: newHeight)
        delegate?.calendarPickerHeightDidChange?(self)
    }
}
