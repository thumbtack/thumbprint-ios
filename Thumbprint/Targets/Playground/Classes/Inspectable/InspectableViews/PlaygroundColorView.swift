import Thumbprint
import UIKit

/// A simple view for previewing a color preset.
class PlaygroundColorView: UIView, InspectableView {
    static var name: String {
        "Color"
    }

    var color: UIColor {
        didSet {
            backgroundColor = color
        }
    }

    var inspectableProperties: [InspectableProperty] {
        let colorProperty = DropdownInspectableProperty(
            inspectedView: self,
            property: \PlaygroundColorView.color,
            values: PlaygroundColorView.allColors
        )
        colorProperty.title = "Color"

        let hideBorderProperty = BoolInspectableProperty(inspectedView: inspectableBorderView)
        hideBorderProperty.title = "Hide playground border?"
        hideBorderProperty.property = \InspectableBorderView.isHidden

        return [
            colorProperty,
            hideBorderProperty,
        ]
    }

    private static let viewSize = CGSize(width: 128, height: 128)

    static func makeInspectable() -> UIView & InspectableView {
        self.init()
    }

    required init() {
        self.color = PlaygroundColorView.allColors.randomElement()!.0 // swiftlint:disable:this force_unwrapping

        super.init(frame: CGRect(origin: .zero, size: PlaygroundColorView.viewSize))

        backgroundColor = color
        layer.cornerRadius = CornerRadius.base
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var intrinsicContentSize: CGSize {
        PlaygroundColorView.viewSize
    }

    static let allColors: [(UIColor, String)] = [
        (Color.blue100, "Blue 100"),
        (Color.blue200, "Blue 200"),
        (Color.blue300, "Blue 300"),
        (Color.blue, "Blue"),
        (Color.blue500, "Blue 500"),
        (Color.blue600, "Blue 600"),
        (Color.indigo100, "Indigo 100"),
        (Color.indigo200, "Indigo 200"),
        (Color.indigo300, "Indigo 300"),
        (Color.indigo, "Indigo"),
        (Color.indigo500, "Indigo 500"),
        (Color.indigo600, "Indigo 600"),
        (Color.purple100, "Purple 100"),
        (Color.purple200, "Purple 200"),
        (Color.purple300, "Purple 300"),
        (Color.purple, "Purple"),
        (Color.purple500, "Purple 500"),
        (Color.purple600, "Purple 600"),
        (Color.green100, "Green 100"),
        (Color.green200, "Green 200"),
        (Color.green300, "Green 300"),
        (Color.green, "Green"),
        (Color.green500, "Green 500"),
        (Color.green600, "Green 600"),
        (Color.yellow100, "Yellow 100"),
        (Color.yellow200, "Yellow 200"),
        (Color.yellow300, "Yellow 300"),
        (Color.yellow, "Yellow"),
        (Color.yellow500, "Yellow 500"),
        (Color.yellow600, "Yellow 600"),
        (Color.red100, "Red 100"),
        (Color.red200, "Red 200"),
        (Color.red300, "Red 300"),
        (Color.red, "Red"),
        (Color.red500, "Red 500"),
        (Color.red600, "Red 600"),
        (Color.black300, "Black 300"),
        (Color.black, "Black"),
        (Color.gray200, "Gray 200"),
        (Color.gray300, "Gray 300"),
        (Color.gray, "Gray"),
        (Color.white, "White"),
    ]
}
