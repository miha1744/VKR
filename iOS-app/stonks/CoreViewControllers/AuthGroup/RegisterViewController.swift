import UIKit

class RegisterViewController: TommyStackViewController {
    
    let imagePicker = UIImagePickerController()
    
    private lazy var loadingAlert = UIAlertController(style: .loading)
    
    private lazy var textLabel = UILabel(text: "Doctor App", font: Fonts.standart.gilroySemiBoldName(ofSize: 40), textColor: .white, textAlignment: .center, numberOfLines: 0)
    private lazy var textLabel2 = UILabel(text: "Регистрация", font: Fonts.standart.gilroySemiBoldName(ofSize: 20), textColor: .white, textAlignment: .center, numberOfLines: 0)
    
    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.snp.makeConstraints { (make) in
            make.width.equalTo(150)
            make.height.equalTo(150)
        }
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 75
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(imageLiteralResourceName: "man")
        imageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(tappedSelectAva))
        imageView.addGestureRecognizer(tap)
        
        return imageView
    }()
    private lazy var firstNameInput = TommyTextField(placehldr: "Ваше имя")
    private lazy var lastNameInput = TommyTextField(placehldr: "Ваша фамилия")
    private lazy var usernameInput: TommyTextField = {
        let input = TommyTextField(placehldr: "Логин")
        input.autocapitalizationType = .none
        
        return input
    }()
    private lazy var passInput: TommyTextField = {
        let input = TommyTextField(placehldr: "Пароль")
        input.isSecureTextEntry = true
        
        return input
    }()
    private lazy var mobileInput = TommyPhoneNumberTextField(placehldr: "", fontSize: 16)
    private lazy var regButton: TommyButton = {
        let button = TommyButton(text: "Продолжить")
        button.setOnTapAction { [weak self] in
            guard let self = self else { return }
            let userData = AuthService.UserData(
                mobile: self.mobileInput.text ?? "",
                birthday: Date().toFormat("yyyy-MM-dd"),
                firstName: self.firstNameInput.value,
                lastName: self.lastNameInput.value,
                username: self.usernameInput.value,
                password: self.passInput.value,
                avatarka: self.avatarImageView.image?.jpegData(compressionQuality: 0.8)?.base64EncodedString() ?? ""
            )
            self.started()
            AuthService.main.registerWithCreditnails(userData: userData) { result in
                self.complete(isSuccess: result)
            }
        }
        
        return button
    }()

    init() {
        super.init(nibName: nil, bundle: nil)
        
        scrollView.contentInset = .init(top: 30, left: 0, bottom: 50, right: 0)
        stackView.spacing = 80
        stackView.isLayoutMarginsRelativeArrangement = true
        
        initView()
    }

    
    func initView() {
        addWidthArrangedSubView(view: textLabel)
        addWidthArrangedSubView(view: textLabel2)
        stackView.addArrangedSubview(avatarImageView)
        addWidthArrangedSubView(view: firstNameInput, spacing: 30)
        addWidthArrangedSubView(view: lastNameInput, spacing: 30)
        addWidthArrangedSubView(view: usernameInput, spacing: 30)
        addWidthArrangedSubView(view: passInput, spacing: 30)
        addWidthArrangedSubView(view: mobileInput, spacing: 30)
        addWidthArrangedSubView(view: regButton, spacing: 30)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        imagePicker.sourceType = .savedPhotosAlbum
        imagePicker.allowsEditing = false
        
        stackView.alignment = .center
    }
    
    @objc func tappedSelectAva() {
        present(imagePicker, animated: true, completion: nil)
    }
}

extension RegisterViewController: AuthResultDelegate {
    func complete(isSuccess: Bool) {
        loadingAlert.dismiss(animated: true) {
            if !isSuccess {
                let errorAlert = UIAlertController(style: .errorMessage)
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

extension RegisterViewController: ReloadProtocol {
    func reload() {
        stackView.arrangedSubviews.forEach({$0.removeFromSuperview()})
        initView()
    }
}

extension RegisterViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var newImage: UIImage

        if let possibleImage = info[.editedImage] as? UIImage {
            avatarImageView.image = possibleImage
        } else if let possibleImage = info[.originalImage] as? UIImage {
            avatarImageView.image = possibleImage
        } else {
            return
        }

        // do something interesting here!
        //print(newImage.size)

        dismiss(animated: true)
    }
}
