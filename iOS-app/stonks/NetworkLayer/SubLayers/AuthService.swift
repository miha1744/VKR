import SwiftyJSON
import Alamofire

class AuthService: MixAppNetwork {
    
    static let main = AuthService()
    
    override private init() {}
    
    func authWithCreditnails(login:String, password:String, complition: @escaping (Bool)->Void) {
        
        guard let headers = self.getHTTPHeaders(rawHeaders: [.accept]) else {
            complition(false)
            return
        }
        
        let parameters = ["username": login, "password": password]
        
        AF.request(MixAppNetwork.authUrl, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate(statusCode: 200..<300).responseJSON { response in
            print(response.debugDescription)
            
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                App.shared.accessToken = json["token"].stringValue
                complition(true)
            case .failure(let error):
                print(error.localizedDescription)
                complition(false)
            }
        }
    }
    
    func registerWithCreditnails(userData: UserData, complition: @escaping (Bool)->Void) {
        
        guard let headers = self.getHTTPHeaders(rawHeaders: [.accept]) else {
            complition(false)
            return
        }
        
        AF.request(MixAppNetwork.regUrl, method: .post, parameters: userData.asParameter, encoding: JSONEncoding.default, headers: headers).validate(statusCode: 200..<300).responseJSON { response in
            print(response.debugDescription)
            switch response.result {
            case .success( _):
                Self.main.authWithCreditnails(login: userData.username, password: userData.password) { complition($0) }
            case .failure(let error):
                print(error.localizedDescription)
                complition(false)
            }
        }
    }
    
    func getMe(complition: @escaping (Bool)->Void) {
        
        getToken {
            guard let headers = self.getHTTPHeaders(rawHeaders: self.basicHeaders) else {
                complition(false)
                return
            }
            AF.request(MixAppNetwork.meUrl, method: .get, headers: headers).validate(statusCode: 200..<300).responseJSON { response in
                print(response.debugDescription)
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    print(json)
                    App.shared.user = User(data: json)
                    complition(true)
                case .failure(let error):
                    print(error.localizedDescription)
                    complition(false)
                }
            }
        }
    }
    
    struct UserData {
        let mobile: String
        let birthday: String
        let firstName: String
        let lastName: String
        let username: String
        let password: String
        let avatarka: String
        
        var asParameter: Parameters {
            ["mobile" : mobile, "birthday" : birthday, "profile_pic" : avatarka, "user": ["first_name": firstName, "last_name": lastName, "username" : username, "password" : password]]
        }
    }
}
