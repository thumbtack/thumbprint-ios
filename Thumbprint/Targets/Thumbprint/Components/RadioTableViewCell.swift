import UIKit

open class RadioTableViewCell: UITableViewCell, UIContentSizeCategoryAdjusting {
    public static let reuseIdentifier = "RadioTableViewCell"
    public let radio: Radio
    public var radioGroup: RadioTableViewCellGroup?

    open var adjustsFontForContentSizeCategory: Bool = true {
        didSet {
            guard adjustsFontForContentSizeCategory != oldValue else { return }

            radio.adjustsFontForContentSizeCategory = adjustsFontForContentSizeCategory
            radio.sizeToFit()
            contentView.setNeedsLayout()
        }
    }

    open override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        radio.isSelected = selected
        if selected { radioGroup?.didSelectCell(self) }
    }

    public override func prepareForReuse() {
        super.prepareForReuse()
        radio.isSelected = radioGroup?.shouldReusedCellBeSelected(cell: self) ?? false
    }

    public var textStyle: Font.TextStyle {
        get {
            radio.textStyle
        }

        set {
            radio.textStyle = newValue
        }
    }

    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        self.radio = Radio(text: "", adjustsFontForContentSizeCategory: adjustsFontForContentSizeCategory)

        super.init(style: .default, reuseIdentifier: reuseIdentifier)

        self.selectionStyle = .none

        radio.numberOfLines = 0
        radio.isUserInteractionEnabled = false
        radio.sizeToFit()

        contentView.addSubview(radio)
        radio.snp.makeConstraints { make in
            // enforce a minimum cell height with larger bottom padding for single lines
            make.height.greaterThanOrEqualTo(radio.radioImage.intrinsicContentSize.height + Space.two)
            make.right.lessThanOrEqualToSuperview().inset(Space.four)
            make.top.equalToSuperview().inset(Space.three)
            make.left.equalToSuperview().inset(Space.four)
            make.bottom.lessThanOrEqualToSuperview().inset(Space.two)
        }
    }

    public func setText(_ text: String?) {
        radio.text = text
        radio.sizeToFit()
        contentView.setNeedsLayout()
    }

    @available(*, unavailable)
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private var bottomBorderView: UIView?

    public var showsBottomBorder = false {
        didSet {
            if let borderView = bottomBorderView {
                borderView.isHidden = !showsBottomBorder
            } else if showsBottomBorder {
                let borderView = UIView()
                borderView.backgroundColor = Color.gray
                contentView.addSubview(borderView)
                borderView.snp.makeConstraints { make in
                    make.height.equalTo(1)
                    make.left.right.equalToSuperview().inset(Space.three)
                    make.bottom.equalToSuperview()
                }
                bottomBorderView = borderView
            }
        }
    }
}

public final class RadioTableViewCellGroup {
    public weak var tableView: UITableView?
    var radioTableViewCellsPaths: Set<IndexPath> = Set()
    public var selectedIndexPath: IndexPath?

    public init(tableView: UITableView? = nil, selectedIndexPath: IndexPath? = nil) {
        self.tableView = tableView
        self.selectedIndexPath = selectedIndexPath
    }

    public func register(indexPath: IndexPath) {
        radioTableViewCellsPaths.insert(indexPath)
        if tableView?.cellForRow(at: indexPath)?.isSelected == true {
            selectedIndexPath = indexPath
        }
    }

    public func unregister(indexPath: IndexPath) {
        if selectedIndexPath == indexPath {
            selectedIndexPath = nil
        }

        radioTableViewCellsPaths.remove(indexPath)
    }

    public func isRegistered(indexPath: IndexPath) -> Bool {
        radioTableViewCellsPaths.contains(indexPath)
    }

    fileprivate func shouldReusedCellBeSelected(cell: RadioTableViewCell) -> Bool {
        guard let indexPath = tableView?.indexPath(for: cell) else { return false }
        return indexPath == selectedIndexPath
    }

    fileprivate func didSelectCell(_ cell: RadioTableViewCell) {
        guard let indexPath = tableView?.indexPath(for: cell), indexPath != selectedIndexPath else { return }
        if let selectedIndexPath = selectedIndexPath {
            tableView?.deselectRow(at: selectedIndexPath, animated: true)
        }

        selectedIndexPath = indexPath
    }
}

public extension UITableView {
    func newRadioGroup() -> RadioTableViewCellGroup {
        RadioTableViewCellGroup(tableView: self)
    }
}
