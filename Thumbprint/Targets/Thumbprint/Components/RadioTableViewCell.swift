import UIKit

open class RadioTableViewCell: UITableViewCell, UIContentSizeCategoryAdjusting {
    public static let reuseIdentifier = "RadioTableViewCell"
    public let radio: LabeledRadio
    public var radioGroup: RadioTableViewCellGroup?
    private let radioLabel = Label(textStyle: .text1)

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
            radioLabel.textStyle
        }

        set {
            radioLabel.textStyle = newValue
        }
    }

    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        self.radio = LabeledRadio(label: radioLabel, adjustsFontForContentSizeCategory: adjustsFontForContentSizeCategory)

        super.init(style: .default, reuseIdentifier: reuseIdentifier)

        self.selectionStyle = .none

        radio.numberOfLines = 0
        radio.isUserInteractionEnabled = false
        radio.sizeToFit()

        contentView.addSubview(radio)
        radio.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(Space.four)
            make.top.bottom.equalToSuperview().inset(Space.three)
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
