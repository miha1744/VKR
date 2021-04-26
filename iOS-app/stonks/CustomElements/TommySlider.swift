import UIKit

class TommySlider: UISlider {

    init() {
        super.init(frame: .zero)
        tintColor = .coreBlue
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
