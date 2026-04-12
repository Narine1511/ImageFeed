
import UIKit

final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"
    
    @IBOutlet var likeButton: UIButton?
    @IBOutlet var dateLabel: UILabel?
    @IBOutlet weak var cellImage: UIImageView?
}
