import UIKit

class AuthViewController: TommyStackViewController {
    
    private lazy var loadingAlert = UIAlertController(style: .loading)

    init() {
        super.init(nibName: nil, bundle: nil)
        
        //view.backgroundColor = .white
        stackView.layoutMargins = .allSides(20)
        stackView.isLayoutMarginsRelativeArrangement = true
        
        initView()
    }
    
    func initView() {
        let authWaysView = AuthWaysView()
        authWaysView.authDelegate = self
        authWaysView.registerButtonHandler = { [weak self] in
            self?.present(RegisterViewController(), animated: true, completion: nil)
        }
        addWidthArrangedSubView(view: authWaysView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension AuthViewController: AuthResultDelegate {
    func complete(isSuccess: Bool) {
        loadingAlert.dismiss(animated: true) {
            if !isSuccess {
                let errorAlert = UIAlertController(style: .errorMessage, message: "Error")
                self.present(errorAlert, animated: true, completion: nil)
            } else {
                RouteProvider.shared.switchToInitialViewController()
            }
        }
    }
    
    func started() {
        self.present(loadingAlert, animated: true, completion: nil)
    }
}

extension AuthViewController: ReloadProtocol {
    func reload() {
        stackView.arrangedSubviews.forEach({$0.removeFromSuperview()})
        initView()
    }
}
