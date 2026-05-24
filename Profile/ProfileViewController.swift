//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Наринэ  Овсепян on 20.02.2026.
//

import UIKit
import Kingfisher

final class ProfileViewController: UIViewController, ProfileViewProtocol {
    
    var presenter: ProfilePresenterProtocol?
    
    /* private var profileImageServiceObserver: NSObjectProtocol?
     private let profileService = ProfileService.shared*/
    
    private var descriptionLabel: UILabel?
    private var loginNameLabel: UILabel?
    private var nameLabel: UILabel?
    private var avatarImageView: UIImageView?
    
    func configure(_ presenter: ProfilePresenterProtocol) {
        self.presenter = presenter
        presenter.view = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .ypBlack
        setupAvatarImages()
        presenter?.viewDidLoad()
    }
    
    func setupAvatarImages() {
        let profileImage = UIImage(named: "Photo")
        let imageView = UIImageView(image: profileImage)
        imageView.tintColor = .gray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 35
        view.addSubview(imageView)
        imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        avatarImageView = imageView
        
        
        let nameLabel = UILabel()
        nameLabel.text = "Екатерина Новикова"
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameLabel)
        nameLabel.textColor = .ypWhite
        nameLabel.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        nameLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor).isActive = true
        nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8).isActive = true
        self.nameLabel = nameLabel
        
        
        let loginNameLabel = UILabel()
        loginNameLabel.text = "@ekaterina_now"
        loginNameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loginNameLabel)
        loginNameLabel.textColor = .ypGray
        loginNameLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        loginNameLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor).isActive = true
        loginNameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8).isActive = true
        self.loginNameLabel = loginNameLabel
        
        
        let descriptionLabel = UILabel()
        descriptionLabel.text = "Hello, world!"
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(descriptionLabel)
        descriptionLabel.textColor = .ypWhite
        descriptionLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        descriptionLabel.leadingAnchor.constraint(equalTo: loginNameLabel.leadingAnchor).isActive = true
        descriptionLabel.topAnchor.constraint(equalTo: loginNameLabel.bottomAnchor, constant: 8).isActive = true
        self.descriptionLabel = descriptionLabel
        
        let exitImage = UIImage(resource: .exit) as UIImage?
        guard let exitImage else {return}
        let button = UIButton.systemButton(with: exitImage,
                                           target: self,
                                           action: #selector(self.didTapButton)
        )
        button.tintColor = .ypRed
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        button.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        button.centerYAnchor.constraint(equalTo: imageView.centerYAnchor).isActive = true
        /*updateProfileDetails()*/
    }
    
    @objc
    private func didTapButton() {
        presenter?.didTapLogout()
    }
    
    func displayProfileData(name: String, login: String, description: String) {
        
        nameLabel?.text = name
        loginNameLabel?.text = login
        descriptionLabel?.text = description
    }
    
    func displayAvatar(with url: URL) {
        /*let placeholder = UIImage(systemName: "person.circle.fill")?
         .withTintColor(.lightGray, renderingMode: .alwaysOriginal)
         let processor = RoundCornerImageProcessor(cornerRadius: 35)
         avatarImageView?.kf.setImage(
         with: url,
         placeholder: placeholder,
         options: [.processor(processor)]
         )*/
        let placeholderImage = UIImage(systemName: "person.circle.fill")?
            .withTintColor(.lightGray, renderingMode: .alwaysOriginal)
            .withConfiguration(UIImage.SymbolConfiguration(pointSize: 70, weight: .regular, scale: .large))
        
        let processor = RoundCornerImageProcessor(cornerRadius: 35)
        avatarImageView?.kf.indicatorType = .activity
        avatarImageView?.kf.setImage(
            with: url,
            placeholder: placeholderImage,
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .cacheOriginalImage,
                .forceRefresh
            ]) { result in
                
                switch result {
                case .success(let value):
                    print(value.image)
                    print(value.cacheType)
                    print(value.source)
                    
                case .failure(let error):
                    print(error)
                }
            }
    }
    
    func showLogoutAlert() {
        let alert = UIAlertController(
            title: "Выход",
            message: "Уверены, что хотите выйти?",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Нет", style: .cancel))
        alert.addAction(UIAlertAction(title: "Да", style: .destructive) { [weak self] _ in
            self?.presenter?.didConfirmLogout()
        })
        
        present(alert, animated: true)
    }
}


