//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Наринэ  Овсепян on 20.02.2026.
//

import UIKit

final class ProfileViewController: UIViewController {
    
    /* @IBOutlet weak var avatarImageView: UIImageView!
     @IBOutlet weak var nameLabel: UILabel!
     @IBOutlet weak var loginNameLabel: UILabel!
     
     @IBOutlet weak var descriptionLabel: UILabel!
     
     @IBOutlet weak var logoutButton: UIButton!
     
     @IBAction func didTapLogoutButton() {
     }*/
    private var label: UILabel?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let profileImage = UIImage(named: "Photo")
        let imageView = UIImageView(image: profileImage)
        imageView.tintColor = .gray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        let label = UILabel()
        label.text = "Екатерина Новикова"
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        label.textColor = .ypWhite
        label.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        label.leadingAnchor.constraint(equalTo: imageView.leadingAnchor).isActive = true
        label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8).isActive = true
        self.label = label
        
        
        let loginNameLabel = UILabel()
        loginNameLabel.text = "@ekaterina_now"
        loginNameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loginNameLabel)
        loginNameLabel.textColor = .ypGray
        loginNameLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        loginNameLabel.leadingAnchor.constraint(equalTo: label.leadingAnchor).isActive = true
        loginNameLabel.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 8).isActive = true
        
        
        let descriptionLabel = UILabel()
        descriptionLabel.text = "Hello, world!"
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(descriptionLabel)
        descriptionLabel.textColor = .ypWhite
        descriptionLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        descriptionLabel.leadingAnchor.constraint(equalTo: loginNameLabel.leadingAnchor).isActive = true
        descriptionLabel.topAnchor.constraint(equalTo: loginNameLabel.bottomAnchor, constant: 8).isActive = true
        
        
        let button = UIButton.systemButton(with: UIImage(named: "Exit")!,
                                           target: self,
                                           action: #selector(self.didTapButton)
        )
        button.tintColor = .red
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        button.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        button.centerYAnchor.constraint(equalTo: imageView.centerYAnchor).isActive = true
    }
    
    @objc
    private func didTapButton() {
        label?.removeFromSuperview()
        label = nil
    }
}

