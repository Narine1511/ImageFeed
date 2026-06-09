//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Наринэ  Овсепян on 10.02.2026.
//

import UIKit

protocol ImagesListCellDelegate: AnyObject {
    func imageListCellDidTapLike(_ cell: ImagesListCell)
}

final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"
    weak var delegate: ImagesListCellDelegate?
    
    @IBOutlet var likeButton: UIButton?
    @IBOutlet var dateLabel: UILabel?
    @IBOutlet weak var cellImage: UIImageView?
    
    @IBAction func likeButtonClicked() {
        delegate?.imageListCellDidTapLike(self)
    }
    func setIsLiked(_ isLiked: Bool) {
        let image = isLiked ? UIImage(named: "like_button_on") : UIImage(named: "like_button_off")
        likeButton?.setImage(image, for: .normal)

    }
}

