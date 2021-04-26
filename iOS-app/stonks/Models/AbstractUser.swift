import SwiftyJSON

class User {
    var id:Int, mobile:String, birthday:String, firstName:String, lastName:String, profilePic: String
    
    
    init(data:JSON) {
        id = data["id"].intValue
        mobile = data["mobile"].stringValue
        birthday = data["birthday"].stringValue
        firstName = data["user"]["first_name"].stringValue
        lastName = data["user"]["last_name"].stringValue
        profilePic = data["profile_pic"].stringValue
    }
    
    init(id:Int, mobile:String, birthday:String, firstName:String, lastName:String, profilePic: String) {
        self.id = id
        self.mobile = mobile
        self.birthday = birthday
        self.firstName = firstName
        self.lastName = lastName
        self.profilePic = profilePic
    }
    
    var fullName: String {
        "\(firstName) \(lastName)"
    }
}

extension User: Equatable {
    static func == (lhs: User, rhs: User) -> Bool {
        lhs.id == rhs.id
    }
}

