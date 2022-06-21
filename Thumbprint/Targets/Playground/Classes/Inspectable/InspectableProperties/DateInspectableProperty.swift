import Combine
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
    private let dateSubject: CurrentValueSubject<Date, Never> = CurrentValueSubject(Date())
    private var subscriptions: Set<AnyCancellable> = Set()

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
        datePicker.addTarget(self, action: #selector(valueChanged(sender:)), for: .valueChanged)

        dateSubject
            .dropFirst()
            .throttle(for: 1.0, scheduler: DispatchQueue.main, latest: true)
            .eraseToAnyPublisher()
            .sink { [weak self] date in
                guard let self = self, let property = self.property else { return }
                self.inspectedView[keyPath: property] = date
            }.store(in: &subscriptions)
    }

    @objc private func valueChanged(sender: AnyObject) {
        textInput.text = dateFormatter.string(from: datePicker.date)
        dateSubject.send(datePicker.date)
    }
}
