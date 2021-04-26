
import Foundation
import UIKit

class App {
    private init() {
        user = SRProvider.restoreUser()
        accessToken = SRProvider.restoreToken()
    }
    
    static let shared = App()
    
    let SRProvider = SaveRestoreProvider.shared
    
    var user:User? {
        willSet {
            SRProvider.saveUser(user: newValue)
        }
    }
    
    var accessToken:String? {
        willSet {
            SRProvider.saveToken(token: newValue)
        }
    }
    
    func logOut() {
        user = nil
        accessToken = nil
    }
    
    var isNeedReloadFeedData = false
    
    var currentQueueVC: QueuePageViewController?
}
