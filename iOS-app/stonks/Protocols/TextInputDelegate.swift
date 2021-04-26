import Foundation

protocol TextInputDelegate: class {
    func textChanged(text:String)
    func textBeginEditing()
    func rightImageClicked()
}

extension TextInputDelegate {
    func textChanged(text:String) {}
    func textBeginEditing() {}
    func rightImageClicked() {}
}
