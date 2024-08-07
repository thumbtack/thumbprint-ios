import Thumbprint
import UIKit

protocol ComponentsListViewControllerDelegate: AnyObject {
    func componentsListViewController(_: ComponentsListViewController, addViewForComponent: InspectableView.Type)
}

/// Sidebar displaying a list of components that
/// can be added to the playground.
class ComponentsListViewController: UIViewController {
    weak var delegate: ComponentsListViewControllerDelegate?

    init() {
        super.init(nibName: nil, bundle: nil)

        tableView.dataSource = self
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.safeAreaLayoutGuide).priority(999)
        }
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private
    private class Cell: UITableViewCell {
        static let reuseIdentifier = "\(Cell.self)"

        var buttonCallback: (() -> Void)?

        let button: Button = {
            let button = Button(theme: .secondary)
            button.isHapticFeedbackEnabled = true
            return button
        }()

        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)

            backgroundColor = Color.white

            contentView.addSubview(button)
            button.snp.makeConstraints { make in
                make.edges.equalToSuperview().inset(Space.three)
            }

            button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        }

        @available(*, unavailable)
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        @objc private func buttonAction() {
            buttonCallback?()
        }
    }

    private class SectionHeaderView: UITableViewHeaderFooterView {
        static let reuseIdentifier = "\(SectionHeaderView.self)"

        var title: String? {
            get {
                titleLabel.text
            }
            set {
                titleLabel.text = newValue
            }
        }

        private let titleLabel: Label = {
            let titleLabel = Label(textStyle: .title2)
            titleLabel.adjustsFontSizeToFitWidth = true
            return titleLabel
        }()

        override init(reuseIdentifier: String?) {
            super.init(reuseIdentifier: reuseIdentifier)

            backgroundColor = Color.white

            addSubview(titleLabel)
            titleLabel.snp.makeConstraints { make in
                make.top.equalToSuperview()
                make.leading.trailing.equalToSuperview().inset(Space.three)
                make.bottom.equalToSuperview().priority(999)
            }
        }

        @available(*, unavailable)
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }

    private static let componentTypes: [InspectableView.Type] = [
        PlaygroundColorView.self,
        Button.self,
        ButtonRow.self,
        ButtonStack.self,
        Dropdown.self,
        LabeledCheckbox.self,
        Footer.self,
        IconButton.self,
        Label.self,
        LoaderDots.self,
        Radio.self,
        RadioStack.self,
        RadioTableViewCell.self,
        ShadowCard.self,
        TextInput.self,
        TextArea.self,
        UITabBar.self,
        Toast.self,
        CalendarPickerInspectableView.self,
        EntityAvatar.self,
        FilterChip.self,
        Pill.self,
        ToggleChip.self,
        UserAvatar.self,
        TextFloatingActionButton.self,
        IconFloatingActionButton.self,
    ].sorted(by: { $0.name < $1.name })

    private let tableView: UITableView = {
        let tableView = UITableView(frame: .null, style: .grouped)
        tableView.backgroundColor = Color.white
        tableView.separatorColor = .clear
        tableView.allowsSelection = false
        tableView.delaysContentTouches = false
        tableView.estimatedRowHeight = 77
        tableView.estimatedSectionHeaderHeight = 68
        tableView.tableHeaderView = UIView()
        tableView.tableFooterView = UIView()
        tableView.register(Cell.self, forCellReuseIdentifier: Cell.reuseIdentifier)
        tableView.register(SectionHeaderView.self, forHeaderFooterViewReuseIdentifier: SectionHeaderView.reuseIdentifier)
        return tableView
    }()
}

// MARK: - UITableViewDataSource
extension ComponentsListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        Self.componentTypes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Cell.reuseIdentifier, for: indexPath) as! Cell

        let inspectableType = Self.componentTypes[indexPath.row]
        cell.button.title = inspectableType.name
        cell.button.theme = .secondary

        cell.buttonCallback = { [weak self] in
            guard let self else { return }
            delegate?.componentsListViewController(self, addViewForComponent: inspectableType)
        }

        return cell
    }
}
