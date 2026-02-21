//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Наринэ  Овсепян on 20.02.2026.
//

import UIKit

final class ProfileViewController: UIViewController {
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var loginNameLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var logoutButton: UIButton!
    
    @IBAction func didTapLogoutButton() {
    }
}
