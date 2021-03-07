import UIKit

public class Slider: UISlider {
    override init(frame: CGRect) {
        super.init(frame: frame)
        addThumbprintStyle()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        addThumbprintStyle()
    }

    func addThumbprintStyle() {
        minimumTrackTintColor = Color.blue
        maximumTrackTintColor = Color.gray300
    }
}
