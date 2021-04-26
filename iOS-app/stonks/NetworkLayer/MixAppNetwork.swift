import Alamofire
import SwiftyJSON

class MixAppNetwork {
        
    internal static let baseurlWithoutDash = "https://peaceful-spire-57562.herokuapp.com"
    internal static let baseurl = "\(baseurlWithoutDash)/"
    internal static let baseApiUrl = "\(baseurl)api/v1/"
    
    internal static let authUrl = "\(baseurl)api-token-auth"
    internal static let regUrl = "\(baseApiUrl)register"
    internal static let meUrl = "\(baseApiUrl)current_user_info"
    
    internal static let myQueues = "\(baseApiUrl)current_user_queue"
    internal static let stayQueue = "\(baseApiUrl)stay_queue"
    internal static let quitQueue = "\(baseApiUrl)quit_queue/"
        
    func getToken(complition:@escaping()->Void) {
        
        switch isNeedIssueNewToken() {
        case .byAuth:
            //getTokenWithParams(url: MixAppNetwork.loginUrl, parameters: [:]) {
                print("Getted by auth")
                complition()
            //}
        case .byRefresh( _):
            print("Getted by refresh")
            complition()
        case .doNothing:
            print("Getted by doNothing")
            complition()
        }
    }
    
    func onFailure(error:AFError, on403: ()->Void, repatCode:@escaping()->Void) {
        if let errorCode = error.responseCode, errorCode == 403 {
            on403()
        } else {
          DispatchQueue.main.asyncAfter(deadline: .now() + 20) {
                repatCode()
            }
        }
    }
    
    func isNeedIssueNewToken() -> TokenGettingType {
        App.shared.accessToken != nil ? .doNothing : .byAuth
    }
    
    func getHTTPHeaders(rawHeaders:[HTTPHeaderType]) -> HTTPHeaders? {
        
        var headers = HTTPHeaders()
        
        for rawHeader in rawHeaders {
            if let header = rawHeader.initHeader() {
                headers.add(header)
            } else {
                return nil
            }
        }

        return headers
    }
    
    static func getImageURL(with string: String) -> URL? {
        URL(string: "\(Self.baseurlWithoutDash)\(string)")
    }

    let basicHeaders:[HTTPHeaderType] = [.accessToken, .accept]

    enum HTTPHeaderType {
        case accessToken, accept

        func initHeader() -> HTTPHeader? {
            switch self {
            case .accept:
                return HTTPHeader.accept("application/json")
            case .accessToken:
                guard let token = App.shared.accessToken else {return nil}
                return HTTPHeader.authorization("Token \(token)")
            }
        }
    }
    
    enum TokenGettingType {
        case byAuth, byRefresh(refreshToken:String), doNothing
    }
}

