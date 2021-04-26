import SwiftyJSON
import Alamofire

class QueueService: MixAppNetwork {
    
    static let main = QueueService()
    
    override private init() {}
    
    func getMyQueues(complition: @escaping (Result<[Queue], NetworkError>)->Void) {
        
        guard let headers = self.getHTTPHeaders(rawHeaders: self.basicHeaders) else {
            complition(.failure(.tokenError))
            return
        }
                
        AF.request(MixAppNetwork.myQueues, method: .get, headers: headers).validate(statusCode: 200..<300).responseJSON { response in
            
            print(response.debugDescription)
            
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                var queues: [Queue] = []
                for item in json.arrayValue {
                    queues.append(Queue(data: item))
                }
                complition(.success(queues.reversed()))
            case .failure(let error):
                print(error.localizedDescription)
                complition(.failure(.primaryError))
            }
        }
    }
    
    func stayQueue(doctorQueue: String, complition: @escaping (Result<StayQueueStatus, NetworkError>)->Void) {
        
        getToken {
            guard let headers = self.getHTTPHeaders(rawHeaders: self.basicHeaders) else {
                complition(.failure(.tokenError))
                return
            }
            
            let parameters = ["Doctorqueue": doctorQueue]
            
            AF.request(MixAppNetwork.stayQueue, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate(statusCode: 200..<300).responseJSON { response in
                print(response.debugDescription)
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    print(json)
                    if json["pk"].int != nil {
                        complition(.success(.success))
                    } else {
                        if let error = json.arrayValue.first?["error"].string, error == "203" {
                            complition(.success(.alreadyAtQueue))
                        } else {
                            complition(.failure(.primaryError))
                        }
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    complition(.failure(.primaryError))
                }
            }
        }
    }
    
    func quitQueue(doctorQueue: String, complition: @escaping (Result<Bool, NetworkError>)->Void) {
        
        getToken {
            guard let headers = self.getHTTPHeaders(rawHeaders: self.basicHeaders) else {
                complition(.failure(.tokenError))
                return
            }
            
            AF.request("\(MixAppNetwork.quitQueue)\(doctorQueue)", headers: headers).validate(statusCode: 200..<300).response { response in
                print(response.debugDescription)
                switch response.result {
                case .success( _):
                    complition(.success(true))
                case .failure(let error):
                    print(error.localizedDescription)
                    complition(.failure(.primaryError))
                }
            }
        }
    }
    
    enum StayQueueStatus {
        case success
        case alreadyAtQueue
    }
}
