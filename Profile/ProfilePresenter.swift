//
//  ProfilePresenter.swift
//  ImageFeed
//
//  Created by Наринэ  Овсепян on 24.05.2026.
//
import Foundation
import Kingfisher

protocol ProfilePresenterProtocol: AnyObject {
    var view: ProfileViewProtocol? { get set }
    
    func viewDidLoad()
    func didTapLogout()
    func didConfirmLogout()
    
}

protocol ProfileViewProtocol: AnyObject {
    var presenter: ProfilePresenterProtocol? { get set }
    
    func displayProfileData(name: String, login: String, description: String)
    func displayAvatar(with url: URL)
    func showLogoutAlert()
}

final class ProfilePresenter: ProfilePresenterProtocol {
    weak var view: ProfileViewProtocol?
    
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    
    private func setupNotificationOnObserver() {
        NotificationCenter.default.addObserver(
            forName: ProfileImageService.didChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.updateAvatar()
        }
    }
    
    func viewDidLoad() {
        updateProfileDetails()
        updateAvatar()
        setupNotificationOnObserver()
    }
    
    func didTapLogout() {
        print("🔵 [Presenter] didTapLogout вызван")
        view?.showLogoutAlert()
    }
    
    func didConfirmLogout() {
        ProfileLogoutService.shared.logout()
    }
    
    private func updateProfileDetails() {
        guard let profile = profileService.profile else {
            print("Профиль не загружен")
            return
        }
        
        let name = profile.name.isEmpty ? "Имя не указано" : profile.name
        let login = profile.loginName.isEmpty ? "@неизвестный_пользователь" : profile.loginName
        let description: String
        if let bio = profile.bio, !bio.isEmpty {
            description = bio
        } else {
            description = "Профиль не заполнен"
        }
        
        view?.displayProfileData(name: name, login: login, description: description)
    }
    
    private func updateAvatar() {
        guard
            let profileImageURL = ProfileImageService.shared.avatarURL,
            let imageUrl = URL(string: profileImageURL)
        else { return }
        view?.displayAvatar(with: imageUrl)
    }
}


