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
    static let defaultBaseURLString: URL? = URL(string: "https://api.unsplash.com") // fource
}
