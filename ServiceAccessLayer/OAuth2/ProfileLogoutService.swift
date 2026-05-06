//
//  ProfileLogoutService.swift
//  ImageFeed
//
//  Created by Наринэ  Овсепян on 06.05.2026.
//
import Foundation
import WebKit

final class ProfileLogoutService {
    static let shared = ProfileLogoutService()
    private init() {}
    
    func logout() {
        cleanCookies()
        cleanToken()
        cleanProfileData()
        cleanImagesData()
        switchToAuthScreen()
    }
    
    private func cleanCookies() {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
            }
        }
    }
    private func cleanToken() {
        OAuth2TokenStorage.shared.removeToken()
    }
    
    private func cleanProfileData() {
        ProfileService.shared.resetProfile()
    }
    
    private func cleanImagesData() {
        ProfileService.shared.resetProfile()
        ProfileImageService.shared.resetAvatar()
    }
    
    private func switchToAuthScreen() {
        ImagesListService.shared.resetPhotos()
        DispatchQueue.main.async {
            guard let sceneDelegate = UIApplication.shared.connectedScenes
                .first?.delegate as? SceneDelegate else { return }
            sceneDelegate.switchToAuthViewController()
        }
    }
}

