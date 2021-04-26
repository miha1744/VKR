import UIKit

protocol ScrollDelegate: AnyObject {
    func scrollToView(view: UIView)
}

extension ScrollDelegate {
    func scrollToView(view: UIView) {}
}
