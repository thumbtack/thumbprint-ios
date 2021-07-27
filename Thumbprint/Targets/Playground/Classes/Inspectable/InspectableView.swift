import RxSwift
import UIKit

/// Protocol indicating that a view supports being configured
/// through the Playground Inspector.
protocol InspectableView: AnyObject {
    /// Name of the component, to be displayed in the components list.
    static var name: String { get }

    /// All the view's properties that can be controlled in the inspector.
    var inspectableProperties: [InspectableProperty] { get }

    /// Set to true to pin this view to its random original position
    var disableDrag: Bool { get }

    /// Returns an inspectable instance of the view.
    static func makeInspectable() -> UIView & InspectableView

    // MARK: - Generic Properties
    var disposeBag: DisposeBag { get }
    var inspectableBorderView: InspectableBorderView { get }
}

extension InspectableView {
    var showBorderViewOnSelection: Bool { true }

    // E.g., return "Button Row" for a class named ButtonRow.
    static var name: String {
        "\(Self.self)".unicodeScalars
            .reduce(into: "", { accumulatingResult, unicodeScalar in
                accumulatingResult += CharacterSet.uppercaseLetters.contains(unicodeScalar) ? " " : ""
                accumulatingResult += String(unicodeScalar)
            })
            .trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }

    var disableDrag: Bool { false }

    var disposeBag: DisposeBag {
        guard let associatedDisposeBag = objc_getAssociatedObject(self, &AssociatedObjectKeys.disposeBag) as? DisposeBag else {
            let disposeBag = DisposeBag()
            objc_setAssociatedObject(self, &AssociatedObjectKeys.disposeBag, disposeBag, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return disposeBag
        }

        return associatedDisposeBag
    }
}

extension InspectableView where Self: UIView {
    var inspectableBorderView: InspectableBorderView {
        guard let associatedBorderView = objc_getAssociatedObject(self, &AssociatedObjectKeys.inspectableBorderView) as? InspectableBorderView else {
            let inspectableBorderView = InspectableBorderView()
            addSubview(inspectableBorderView)
            inspectableBorderView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }

            objc_setAssociatedObject(self, &AssociatedObjectKeys.inspectableBorderView, inspectableBorderView, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return inspectableBorderView
        }

        return associatedBorderView
    }
}

private enum AssociatedObjectKeys {
    static var disposeBag = "InspectableViewDisposeBagAssociatedKey"
    static var inspectableBorderView = "InspectableViewInspectableBorderViewKey"
}
