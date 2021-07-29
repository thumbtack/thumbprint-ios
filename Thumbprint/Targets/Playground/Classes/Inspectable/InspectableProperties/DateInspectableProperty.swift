import RxSwift
import Thumbprint
import UIKit

/// Setup information for configuring a Date property in the Playground Inspector.
class DateInspectableProperty<T>: InspectableProperty {
    private let dateFormatter: DateFormatter
    var inspectedView: T
    var property: WritableKeyPath<T, Date>? {
        didSet {
            guard let property = property else { return }
            datePicker.date = inspectedView[keyPath: property]
            textInput.text = dateFormatter.string(from: datePicker.date)
        }
    }

    var title: String?
    var controlView: UIView {
        textInput
    }

    var calendar: Calendar {
        get { dateFormatter.calendar }
        set { dateFormatter.calendar = newValue }
    }

    var dateFormat: String {
        get { dateFormatter.dateFormat }
        set { dateFormatter.dateFormat = newValue }
    }

    private let datePicker = UIDatePicker()
    private let textInput: TextInput
    private let disposeBag = DisposeBag()

    init(inspectedView: T) {
        self.inspectedView = inspectedView

        datePicker.datePickerMode = .date
        if #available(iOS 14.0, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }

        self.textInput = TextInput(adjustsFontForContentSizeCategory: false)
        textInput.inputView = datePicker

        self.dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar.current
        dateFormatter.dateFormat = "MMM d, yyyy"

        datePicker.rx.controlEvent([.valueChanged])
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.textInput.text = self.dateFormatter.string(from: self.datePicker.date)
            })
            .disposed(by: disposeBag)

        datePicker.rx.controlEvent([.valueChanged])
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .bind { [weak self] in
                guard let self = self, let property = self.property else { return }
                self.inspectedView[keyPath: property] = self.datePicker.date
            }
            .disposed(by: disposeBag)
    }
}
