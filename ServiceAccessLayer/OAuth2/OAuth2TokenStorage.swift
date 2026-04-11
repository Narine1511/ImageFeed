
import Foundation

final class OAuth2TokenStorage {
    static let shared = OAuth2TokenStorage()
    private init() {}
    
    
    
    private let tokenKey = "authToken"
    var token: String? {
        get { UserDefaults.standard.string(forKey: tokenKey)}
        set { UserDefaults.standard.set(newValue, forKey: tokenKey)}
    }
}
