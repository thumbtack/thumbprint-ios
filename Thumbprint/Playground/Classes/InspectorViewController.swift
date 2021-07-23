import Thumbprint
import UIKit

/// Sidebar allowing properties of the currently selected
/// component to be configured in real-time.
class InspectorViewController: UIViewController {
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
    class Cell: UITableViewCell {
        static let reuseIdentifier = "\(Cell.self)"

        let propertyView = InspectablePropertyView()

        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)

            backgroundColor = Color.white

            contentView.addSubview(propertyView)
            propertyView.snp.makeConstraints { make in
                make.top.bottom.equalToSuperview().inset(Space.two)
                make.leading.trailing.equalToSuperview().inset(Space.three)
            }
        }

        @available(*, unavailable)
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }

    private let tableView: UITableView = {
        let tableView = UITableView(frame: .null, style: .grouped)
        tableView.backgroundColor = Color.white
        tableView.separatorColor = .clear
        tableView.allowsSelection = false
        tableView.delaysContentTouches = false
        tableView.estimatedRowHeight = 70
        tableView.estimatedSectionHeaderHeight = 68
        tableView.tableHeaderView = UIView()
        tableView.tableFooterView = UIView()
        tableView.register(Cell.self, forCellReuseIdentifier: Cell.reuseIdentifier)
        return tableView
    }()

    var inspectedView: InspectableView? {
        didSet {
            UIView.transition(with: tableView, duration: 0.3, options: .transitionCrossDissolve, animations: {
                self.tableView.reloadData()
            })
        }
    }
}

// MARK: - UITableViewDataSource
extension InspectorViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        inspectedView?.inspectableProperties.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Cell.reuseIdentifier, for: indexPath) as! Cell

        cell.propertyView.property = inspectedView?.inspectableProperties[indexPath.row]

        return cell
    }
}
