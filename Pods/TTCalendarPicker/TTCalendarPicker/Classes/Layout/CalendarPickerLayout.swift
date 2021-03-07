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

protocol CalendarPickerLayoutDataSource: AnyObject {
    func monthLayout(forSection section: CalendarPickerLayout.Section) -> MonthLayout
}

internal class CalendarPickerLayout: UICollectionViewLayout {
    private typealias DecorationType = CalendarPicker.DecorationType
    private typealias SupplementaryType = CalendarPicker.SupplementaryType

    // CalendarPickerLayout works with indexes starting at zero, but CalendarPicker uses indexes starting at -1
    enum Section: Int, CaseIterable {
        case previousMonth = 0
        case currentMonth = 1
        case nextMonth = 2

        // The offset of this section from the current month
        var offset: Int {
            return self.rawValue - 1
        }

        static func fromOffset(_ offset: Int) -> Section? {
            return Section(rawValue: offset + 1)
        }
    }

    /// CalendarPickerLayout's dataSource is responsible for providing it with monthLayout objects
    weak var dataSource: CalendarPickerLayoutDataSource?

    // Our layout depends only on the collectionView's width, so we track it to see when we need to invalidate
    private var lastCollectionViewWidth: CGFloat?
    private var monthLayouts: [MonthLayout] = []

    /// The calendar on which all date computations are based
    private  var calendar: Calendar = Calendar.current { didSet { invalidateLayout() } }

    internal var contentInsets: UIEdgeInsets = UIEdgeInsets(top: 12, left: 16, bottom: 16, right: 16) {
        didSet {
            invalidateLayout()
        }
    }

    /// The color of the border displayed between date cells and around the edge of the group of cells.
    internal var gridBorderColor: UIColor = .clear {
        didSet {
            let invalidationContext = UICollectionViewLayoutInvalidationContext()
            invalidationContext.invalidateDecorationElements(ofKind: DecorationType.gridBorder.kind,
                                                             at: monthLayouts.indices.map({ IndexPath(index: $0) }))
            invalidateLayout(with: invalidationContext)
        }
    }

    /// Returns a dayMonthYear object for the given indexPath, or nil if one cannot be found
    internal func dateForCell(at indexPath: IndexPath) -> Date? {
        guard indexPath.section >= 0 && indexPath.section < monthLayouts.count else { return nil }
        let monthLayout = monthLayouts[indexPath.section]
        return monthLayout.dateForCell(at: indexPath.item)
    }

    // MARK: - Initialization
    override init() {
        super.init()

        register(CalendarPickerBorderDecorationView.self,
                 forDecorationViewOfKind: DecorationType.gridBorder.kind)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - CollectionViewLayout overrides
    override internal func invalidateLayout() {
        lastCollectionViewWidth = nil
        monthLayouts = []
        super.invalidateLayout()
    }

    override internal func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        // Only invalidate on size change, not on scroll
        return newBounds.width != lastCollectionViewWidth
    }

    override internal func prepare() {
        lastCollectionViewWidth = collectionView?.frame.width ?? .zero
        guard let dataSource = self.dataSource else { return }
        monthLayouts = CalendarPickerLayout.Section.allCases.map({ section in
            dataSource.monthLayout(forSection: section)
        })
    }

    override internal var collectionViewContentSize: CGSize {
        guard let collectionView = self.collectionView else { return .zero }

        let width = (collectionView.frame.width) * CGFloat(collectionView.numberOfSections)
        let height = monthLayouts[0].preferredHeight

        return CGSize(width: width, height: height)
    }

    override internal func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var attributes: [UICollectionViewLayoutAttributes] = []

        var cellIndexPaths: [IndexPath] = []
        var gridIndexPaths: [IndexPath] = []
        var monthHeaderPaths: [IndexPath] = []

        for section in Section.allCases.map({ $0.rawValue }) {
            let itemCount = collectionView?.numberOfItems(inSection: section) ?? 0
            cellIndexPaths.append(contentsOf:
                Array(0 ..< itemCount).map({ IndexPath(item: $0, section: section) })
            )
            gridIndexPaths.append(IndexPath(index: section))
            monthHeaderPaths.append(IndexPath(item: 0, section: section))
        }
        attributes.append(contentsOf: cellIndexPaths.compactMap({
            layoutAttributesForItem(at: $0)
        }))
        attributes.append(contentsOf: gridIndexPaths.compactMap({
            layoutAttributesForDecorationView(ofKind: DecorationType.gridBorder.kind, at: $0)
        }))
        attributes.append(contentsOf: monthHeaderPaths.compactMap({
            layoutAttributesForSupplementaryView(ofKind: SupplementaryType.monthHeader.kind, at: $0)
        }))
        return attributes
    }

    override internal func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let monthLayout = monthLayouts[indexPath.section]
        let layoutAttributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        let monthOffset = offsetForSection(indexPath.section)
        layoutAttributes.frame = monthLayout.frameForCell(at: indexPath.item).offsetBy(dx: monthOffset, dy: 0)
        layoutAttributes.zIndex = 200
        return layoutAttributes
    }

    override internal func
        layoutAttributesForDecorationView(ofKind elementKind: String,
                                          at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        switch elementKind {
        case DecorationType.gridBorder.kind:
            return layoutAttributesForBorder(at: indexPath)
        default:
            return nil
        }
    }

    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        switch elementKind {
        case SupplementaryType.monthHeader.kind:
            return layoutAttributesForMonthHeader(at: indexPath)
        default:
            return nil
        }
    }
}

// MARK: View specific layout helpers
private extension CalendarPickerLayout {
    func layoutAttributesForBorder(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let section = indexPath.first else { return nil }
        let monthLayout = monthLayouts[section]
        let monthOffset = offsetForSection(section)
        let layoutAttributes = CalendarPickerViewLayoutAttributes(
            forDecorationViewOfKind: DecorationType.gridBorder.kind,
            with: indexPath
        )

        layoutAttributes.frame = monthLayout.backgroundFrame.offsetBy(dx: monthOffset, dy: 0)
        layoutAttributes.zIndex = 100
        layoutAttributes.backgroundColor = gridBorderColor
        return layoutAttributes
    }

    func layoutAttributesForMonthHeader(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let monthLayout = monthLayouts[indexPath.section]
        let monthOffset = offsetForSection(indexPath.section)
        let layoutAttributes = UICollectionViewLayoutAttributes(
            forSupplementaryViewOfKind: SupplementaryType.monthHeader.kind,
            with: indexPath
        )

        layoutAttributes.zIndex = 250
        layoutAttributes.frame = monthLayout
            .frameForMonthHeader()
            .offsetBy(dx: monthOffset, dy: 0)

        return layoutAttributes
    }
}

// MARK: - Private Helper Functions
private extension CalendarPickerLayout {
    func offsetForSection(_ section: Int) -> CGFloat {
        guard let collectionViewWidth = collectionView?.frame.width else { return 0 }
        return CGFloat(section) * collectionViewWidth
    }

    func sections(fromOffset: CGFloat, toOffset: CGFloat) -> [Section] {
        guard let collectionViewWidth = collectionView?.frame.width else { return [] }
        let range = fromOffset ..< toOffset
        var sections: [Section] = []
        for section in Section.allCases {
            let sectionStart = offsetForSection(section.rawValue)
            let sectionEnd = sectionStart + collectionViewWidth
            let sectionRange = sectionStart ... sectionEnd
            if sectionRange.overlaps(range) {
                sections.append(section)
            }
        }

        return sections
    }
}
