import UIKit

class TommyTextField: UITextField {
    
    var value: String {
        text ?? ""
    }
    
    init() {
        super.init(frame: .zero)
    }
    
    convenience init(placehldr:String, fontSize: CGFloat = 17) {
        self.init()
        placeholder = placehldr
        setup(size: fontSize)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup(size:CGFloat) {
        self.attributedPlaceholder = NSAttributedString(string: self.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray, NSAttributedString.Key.font: Fonts.standart.gilroyRegular(ofSize: size)])
        
        self.textColor = .white
        self.tintColor = .white
        self.font = Fonts.standart.gilroyMedium(ofSize: size)
    }
    
}
