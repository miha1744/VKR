import LBTATools
import UIKit

class AuthWaysView: UIView {
    
    var authDelegate:AuthResultDelegate?
    var isNeedReload = true
    
    var registerButtonHandler: (() -> Void)?
    
    private lazy var textLabel = UILabel(text: "QRQUEUE", font: Fonts.standart.gilroySemiBoldName(ofSize: 40), textColor: .white, textAlignment: .center, numberOfLines: 0)
    private lazy var loginInput: TommyTextField = {
        let input = TommyTextField(placehldr: "Логин")
        input.autocapitalizationType = .none
        
        return input
    }()
    private lazy var passInput: TommyTextField = {
        let input = TommyTextField(placehldr: "Пароль")
        input.isSecureTextEntry = true
        
        return input
    }()
    private lazy var authButton: TommyButton = {
        let button = TommyButton(text: "Авторизоваться")
        button.setOnTapAction { [weak self] in
            if let login = self?.loginInput.text, let pass = self?.passInput.text {
                self?.authDelegate?.started()
                AuthService.main.authWithCreditnails(login: login, password: pass) { result in
                    self?.authDelegate?.complete(isSuccess: result)
                }
            }
        }
        
        return button
    }()
    private lazy var regButton: TommyButton = {
        let button = TommyButton(text: "Зарегистрироваться", style: .secondary)
        button.setOnTapAction { [weak self] in
            self?.registerButtonHandler?()
        }
        
        return button
    }()
    
    init() {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        let core = stack(textLabel,  spacing: 15, alignment: .fill, distribution: .fill)
        core.setCustomSpacing(130, after: textLabel)
        addSubview(core)
        core.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        core.addArrangedSubview(loginInput)
        core.setCustomSpacing(30, after: loginInput)
        core.addArrangedSubview(passInput)
        
        core.addArrangedSubview(authButton)
        core.addArrangedSubview(regButton)
    }
}
