import RxCocoa
import RxSwift
import Thumbprint
import UIKit

/// Border around an inspectable view to indicate when it
/// is being selected.
class InspectableBorderView: UIControl {
    override var isSelected: Bool {
        didSet {
            guard isSelected != oldValue else { return }

            updateBorder()
        }
    }

    override var isHighlighted: Bool {
        didSet {
            guard isHighlighted != oldValue else { return }

            updateBorder()
        }
    }

    private let border: CAShapeLayer
    private let borderInset: CGFloat = -4
    private let borderCornerRadius: CGFloat = 4

    override init(frame: CGRect) {
        self.border = CAShapeLayer()

        super.init(frame: frame)

        isUserInteractionEnabled = false

        border.frame = bounds.insetBy(dx: borderInset, dy: borderInset)
        border.fillColor = UIColor.clear.cgColor
        border.strokeColor = Color.indigo.cgColor
        border.lineWidth = 2
        border.lineDashPattern = [4, 4]
        border.path = UIBezierPath(roundedRect: border.bounds, cornerRadius: borderCornerRadius).cgPath
        updateBorder()
        layer.addSublayer(border)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        border.frame = bounds.insetBy(dx: borderInset, dy: borderInset)
        border.path = UIBezierPath(roundedRect: border.bounds, cornerRadius: borderCornerRadius).cgPath
    }

    private func updateBorder() {
        border.isHidden = !isSelected && !isHighlighted
        border.opacity = isSelected ? 1.0 : 0.3
    }
}
