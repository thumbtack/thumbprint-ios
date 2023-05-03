import UIKit

open class Slider: UISlider {
    public override init(frame: CGRect) {
        super.init(frame: frame)
        addThumbprintStyle()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        addThumbprintStyle()
    }

    func addThumbprintStyle() {
        minimumTrackTintColor = Color.blue
        maximumTrackTintColor = Color.gray300
    }
}
