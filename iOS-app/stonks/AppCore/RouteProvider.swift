
import UIKit

class RouteProvider {
    private init() {}
    
    static let shared = RouteProvider()
    
    func initViewController() -> UIViewController {
        if SaveRestoreProvider.shared.restoreToken() != nil {
            return MainTabBarViewController()
        }
        return AuthViewController()
    }
    
    func switchToInitialViewController() {
        switchRootViewController(rootViewController: initViewController(), animated: true, completion: nil)
    }
    
    func switchRootViewController(rootViewController: UIViewController, animated: Bool, completion: (() -> Void)?) {
        UIApplication.shared.keyWindow?.switchRootViewController(initViewController(), animated: true, completion: nil)
    }
}
