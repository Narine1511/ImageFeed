//
//  Constants.swift
//  ImageFeed
//
//  Created by Наринэ  Овсепян on 03.03.2026.
//
import Foundation

enum Constants {
    static let accessKey = "tXEGhZoOFw2HOkKmNYdydTpZ35b99DVV7SjY-xxZ6zA"
    static let secretKey = "3MzwOrCoqP-zZLE460kGLm7TeQ164leU9X0Ig5fLLEk"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"
    /*static let defaultBaseURLString: URL? = URL(string: "https://api.unsplash.com") // fource*/
    static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize" //https://ya.ru
    static let defaultBaseURLString = "https://api.unsplash.com"
}

struct AuthConfiguration {
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let defaultBaseURLString: String
    let authURLString: String
    
    init(accessKey: String, secretKey: String, redirectURI: String, accessScope: String, authURLString: String, defaultBaseURLString: String) {
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.redirectURI = redirectURI
        self.accessScope = accessScope
        self.defaultBaseURLString = defaultBaseURLString
        self.authURLString = authURLString
    }
    
    static var standart: AuthConfiguration {
        return AuthConfiguration(accessKey: Constants.accessKey,
                                 secretKey: Constants.secretKey,
                                 redirectURI: Constants.redirectURI,
                                 accessScope: Constants.accessScope,
                                 authURLString: Constants.unsplashAuthorizeURLString,
                                 defaultBaseURLString: Constants.defaultBaseURLString)
    }
}
