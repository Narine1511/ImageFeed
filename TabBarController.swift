//
//  TabBarController.swift
//  ImageFeed
//
//  Created by Наринэ  Овсепян on 19.04.2026.
//

import UIKit

final class TabBarController: UITabBarController {
    override func awakeFromNib() {
        super.awakeFromNib()
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let imagesListViewController = storyboard.instantiateViewController(withIdentifier: "ImagesListViewController") as! ImagesListViewController
       // добавляем презентер
        let presenter = ImageListPresenter()
        imagesListViewController.presenter = presenter
        presenter.view = imagesListViewController as? any ImagesListViewProtocol

        
        let profileViewController = ProfileViewController()
        profileViewController.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(named: "tab_profile_active"),
            selectedImage: nil)
        
        self.viewControllers = [imagesListViewController, profileViewController]
    }
}
