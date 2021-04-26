import UIKit
import UserNotifications

class MainTabBarViewController: UITabBarController {

    init() {
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .lightBlack
        //tabBar.isTranslucent = true
        
        if #available(iOS 13.0, *) {
            // ios 13.0 and above
            let appearance = tabBar.standardAppearance
            appearance.shadowImage = nil
            appearance.shadowColor = nil
            appearance.backgroundColor = .lightBlack
            tabBar.standardAppearance = appearance;
        } else {
            // below ios 13.0
            tabBar.shadowImage = UIImage()
            tabBar.barTintColor = .lightBlack
            //tabBar.backgroundImage = UIImage()
        }
        tabBar.tintColor = .coreBlue
        
        buildTabs()
        registerForPushNotifications()
    }
    
    func buildTabs() {
        
        viewControllers = [
            createTab(vc: FeedViewController(), imageName: "feed", tag: 0),
            createTab(vc: ScannerViewController(), imageName: "add", tag: 1, isInNavigationController: false),
            createTab(vc: ProfileViewController(), imageName: "profile", tag: 2)
        ]
        
    }
    
    func createTab(vc:UIViewController, imageName:String, tag:Int, isInNavigationController: Bool = true) -> UIViewController {
        vc.tabBarItem = .init(title: nil, image: UIImage(imageLiteralResourceName: imageName), tag: tag)
        vc.tabBarItem.imageInsets = .init(top: 6, left: 0, bottom: -6, right: 0)
        
        if isInNavigationController {
            return ToomyNavigationController(rootViewController: vc)
        }
        return vc
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func registerForPushNotifications() {
      UNUserNotificationCenter.current()
        .requestAuthorization(options: [.alert, .sound, .badge]) {
          [weak self] granted, error in
            
          print("Permission granted: \(granted)")
          guard granted else { return }
          self?.getNotificationSettings()
      }
    }
    
    func getNotificationSettings() {
      UNUserNotificationCenter.current().getNotificationSettings { settings in
        //print("Notification settings: \(settings)")
        guard settings.authorizationStatus == .authorized else { return }
        DispatchQueue.main.async {
          UIApplication.shared.registerForRemoteNotifications()
        }
      }
        
    }
}
