import Thumbprint
import UIKit

extension RadioTableViewCell: InspectableView {
    var inspectableProperties: [InspectableProperty] {
        []
    }

    static func makeInspectable() -> UIView & InspectableView {
        DemoRadioCellTableView.makeInspectable()
    }
}

class DemoRadioCellTableView: UITableView, UITableViewDataSource, UITableViewDelegate, InspectableView {
    var radioGroup1: RadioTableViewCellGroup?
    var radioGroup2: RadioTableViewCellGroup?

    var disableDrag: Bool { true }
    static var name: String { "" }
    var inspectableProperties: [InspectableProperty] { [] }

    static func makeInspectable() -> UIView & InspectableView {
        let demoTableView = DemoRadioCellTableView(frame: .null, style: .grouped)
        demoTableView.allowsMultipleSelection = true
        demoTableView.snp.makeConstraints { make in
            make.width.equalTo(375)
            make.height.equalTo(250)
        }
        return demoTableView
    }

    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)

        dataSource = self
        self.radioGroup1 = newRadioGroup()
        self.radioGroup2 = newRadioGroup()

        register(RadioTableViewCell.self, forCellReuseIdentifier: "RadioCell")
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        20
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let radioCell = tableView.dequeueReusableCell(withIdentifier: "RadioCell", for: indexPath) as! RadioTableViewCell
        if indexPath.section == 0 {
            radioGroup1?.register(indexPath: indexPath)
            radioCell.radioGroup = radioGroup1
        } else {
            radioGroup2?.register(indexPath: indexPath)
            radioCell.radioGroup = radioGroup2
        }

        radioCell.setText("Cell \(indexPath.row)")
        return radioCell
    }
}
