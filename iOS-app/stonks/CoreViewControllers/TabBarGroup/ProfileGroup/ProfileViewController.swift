import Kingfisher
import UIKit

class ProfileViewController: TommyStackViewController {
    
    private lazy var loadingAlert = UIAlertController(style: .loading)
    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.snp.makeConstraints { (make) in
            make.width.equalTo(150)
            make.height.equalTo(150)
        }
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 75
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()

    init() {
        super.init(nibName: nil, bundle: nil)
        
        //view.backgroundColor = .whit
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stackView.layoutMargins = .allSides(20)
        stackView.isLayoutMarginsRelativeArrangement = true
        
        navigationItem.title = "Профиль"
        navigationItem.largeTitleDisplayMode = .always
        
        setupView()
        
        stackView.alignment = .center
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateMe()
    }
    
    func setupView() {
        guard let user = App.shared.user else {
            return
        }
        
        stackView.addArrangedSubview(avatarImageView)
        avatarImageView.kf.setImage(with: MixAppNetwork.getImageURL(with: user.profilePic))
//        avatarImageView.snp.makeConstraints { (make) in
//            make.center.equalToSuperview()
//        }
        

        let userName = UILabel(text: user.fullName, font: Fonts.standart.gilroyMedium(ofSize: 40), textColor: .white, textAlignment: .center, numberOfLines: 0)
        stackView.addArrangedSubview(userName)
        
        addInfo(title: user.mobile, sub: "Телефон")
        addInfo(title: user.birthday, sub: "Дата рождения")
        
        let exitButton = TommyButton(text: "Выйти")
        exitButton.addOnTapTarget {
            App.shared.logOut()
            RouteProvider.shared.switchToInitialViewController()
        }
        addWidthArrangedSubView(view: exitButton)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func updateMe() {
        AuthService.main.getMe { [weak self] _ in            
            self?.reload()
        }
    }
}

extension ProfileViewController: ReloadProtocol {
    func reload() {
        stackView.arrangedSubviews.forEach({$0.removeFromSuperview()})
        setupView()
    }
}
