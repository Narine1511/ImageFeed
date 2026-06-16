//
//  ViewController.swift
//  ImageFeed
//
//  Created by Наринэ  Овсепян on 01.02.2026.
//

import UIKit
import Kingfisher

final class ImagesListViewController: UIViewController {
    var presenter: ImagesListPresenterProtocol?
    
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    
    
    @IBOutlet private var tableView: UITableView!
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("🔍 tableView класс = \(type(of: tableView))")
            print("🔍 tableView = \(tableView != nil ? "ЕСТЬ ✅" : "nil ❌")")
        tableView?.rowHeight = 200
        tableView?.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        
        presenter?.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showSingleImageSegueIdentifier {
            guard
                let viewController = segue.destination as? SingleImageViewController,
                let indexPath = sender as? IndexPath
            else {
                assertionFailure("Invalid segue destination")
                return
            }
            let photo = presenter?.photo(at: indexPath.row)
            viewController.photo = photo
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.photosCount ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        
        guard let photo = presenter?.photo(at: indexPath.row) else { return UITableViewCell()
        }
        configCell(for: imageListCell, with: photo)
        
        imageListCell.delegate = self
        return imageListCell
    }
}

extension ImagesListViewController {
    func configCell(for cell: ImagesListCell, with photo: Photo) {
        cell.cellImage?.kf.indicatorType = .activity
        cell.cellImage?.kf.setImage(with: URL(string: photo.thumbImageURL))
        
        if let createdAt = photo.createdAt {
            cell.dateLabel?.text = dateFormatter.string(from: createdAt)
        } else {
            cell.dateLabel?.text = ""
        }
        
        let likeImage = photo.isLiked ? UIImage(named: "like_button_on") : UIImage(named: "like_button_off")
        cell.likeButton?.setImage(likeImage, for: .normal)
        
        cell.likeButton?.accessibilityValue = photo.isLiked ? "like_button_on" : "like_button_off"
                cell.likeButton?.accessibilityLabel = photo.isLiked ? "like button on" : "like button off"
    }
}

extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: showSingleImageSegueIdentifier, sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let photo = presenter?.photo(at: indexPath.row) else { return 200 }
        
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = photo.size.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = photo.size.height * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        presenter?.willDisplay(at: indexPath.row)
           /* ImagesListService.shared.fetchPhotosNextPage()*/
        }
    }

extension ImagesListViewController: ImagesListCellDelegate {
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = tableView?.indexPath(for: cell) else { return }
        presenter?.didTapLike(at: indexPath.row)
    }
}
    
    // MARK: - ImagesListViewProtocol

    extension ImagesListViewController: ImagesListViewProtocol {
        
        func updateTableViewAnimated(oldCount: Int, newCount: Int) {
            // Эта команда приходит от презентера, когда появились новые фото
            guard oldCount != newCount else { return }
            
            let indexPaths = (oldCount..<newCount).map { IndexPath(row: $0, section: 0) }
            tableView.performBatchUpdates {
                tableView.insertRows(at: indexPaths, with: .automatic)
            }
        }
        
        func updateLikeStatus(at index: Int, isLiked: Bool) {
            // Эта команда придёт от презентера, когда успешно поставился/снялся лайк
            // Пока оставим заглушку, потом доделаем
            // добавила код 15 июня
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) as? ImagesListCell {
                let likeImage = isLiked ? UIImage(named: "like_button_on") : UIImage(named: "like_button_off")
                cell.likeButton?.setImage(likeImage, for: .normal)
                cell.likeButton?.accessibilityValue = isLiked ? "like_button_on" : "like_button_off"
                            cell.likeButton?.accessibilityLabel = isLiked ? "like button on" : "like button off"
            } else {
                tableView.reloadRows(at: [indexPath], with: .automatic)
            }
            print("🔄 Обновляем лайк в ячейке \(index), статус: \(isLiked)")
        }
        
        func showLikeError(at index: Int) {
            // Эта команда придёт от презентера, если лайк не поставился
            print("❌ Ошибка при лайке ячейки \(index)")
        }
    }
