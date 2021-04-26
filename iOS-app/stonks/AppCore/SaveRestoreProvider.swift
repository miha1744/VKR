
import Foundation

class SaveRestoreProvider {
    
    private static let accessTokenKey = "accessTokenKey"
    private static let baseUserKey = "userKey"
    private static let userPhoneKey = "\(baseUserKey)Phone"
    private static let userIDKey = "\(baseUserKey)ID"
    private static let userFirstNameKey = "\(baseUserKey)FirstName"
    private static let userLastNameKey = "\(baseUserKey)LastName"
    private static let userBirthDayKey = "\(baseUserKey)BirthDay"
    private static let userAvatarKey = "\(baseUserKey)Avatar"
        
    private init() {}
    
    static let shared = SaveRestoreProvider()
    
    func saveToken(token:String?) {
        UserDefaults.standard.set(token, forKey: Self.accessTokenKey)
    }
    
    func restoreToken() -> String? {
        print("access token - \(UserDefaults.standard.string(forKey: Self.accessTokenKey) ?? "undefined")")
        return UserDefaults.standard.string(forKey: Self.accessTokenKey)
    }
    
    func saveUser(user:User?) {
        UserDefaults.standard.set(user?.id, forKey: Self.userIDKey)
        UserDefaults.standard.set(user?.mobile, forKey: Self.userPhoneKey)
        UserDefaults.standard.set(user?.birthday, forKey: Self.userBirthDayKey)
        UserDefaults.standard.set(user?.firstName, forKey: Self.userFirstNameKey)
        UserDefaults.standard.set(user?.lastName, forKey: Self.userLastNameKey)
        UserDefaults.standard.set(user?.lastName, forKey: Self.userLastNameKey)
    }
    
    func restoreUser() -> User {
        let id = UserDefaults.standard.integer(forKey: Self.userIDKey)
        let mobile = UserDefaults.standard.string(forKey: Self.userPhoneKey) ?? ""
        let birthday = UserDefaults.standard.string(forKey: Self.userBirthDayKey) ?? ""
        let firstName = UserDefaults.standard.string(forKey: Self.userFirstNameKey) ?? ""
        let lastName = UserDefaults.standard.string(forKey: Self.userLastNameKey) ?? ""
        let avatar = UserDefaults.standard.string(forKey: Self.userAvatarKey) ?? ""

        return User(id: id, mobile: mobile, birthday: birthday, firstName: firstName, lastName: lastName, profilePic: avatar)
    }
}
