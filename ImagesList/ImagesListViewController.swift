//
//  ViewController.swift
//  ImageFeed
//
//  Created by Наринэ  Овсепян on 01.02.2026.
//

import UIKit
import Kingfisher

final class ImagesListViewController: UIViewController, ImagesListViewProtocol {
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    var presenter: ImagesListPresenterProtocol?
    
    var photos: [Photo] = []
    
    func configure(_ presenter: ImagesListPresenterProtocol) {
        print("🔧 configure вызван с presenter = \(presenter)")
        self.presenter = presenter
        presenter.view = self
        print("✅ self.presenter = \(self.presenter != nil ? "есть" : "nil")")
    }
   /* @IBOutlet private var tableView: UITableView?*/
    
    @IBOutlet var tableView: UITableView!
    
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    } ()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("🔍 tableView = \(tableView != nil ? "подключен ✅" : "nil ❌")")
        tableView?.rowHeight = 200
        tableView?.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        print("🔍 presenter = \(presenter != nil ? "ЕСТЬ ✅" : "nil ❌")")
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
            let photo = photos[indexPath.row]
            viewController.photo = photo
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

extension ImagesListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("📊 numberOfRowsInSection = \(photos.count)")
        return photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("🎨 cellForRowAt вызван для строки \(indexPath.row)")
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        
        guard let imageListCell = cell as? ImagesListCell else {
           
            return UITableViewCell()
        }
        
        let photo = photos[indexPath.row]
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
    }
}
extension ImagesListViewController: UITableViewDelegate {
    // метод отвечает за действия, которые будут выполены при тапе по ячейке таблицы
    func tableView(_ tableView: UITableView, didSelectRowAt
                   indexPath: IndexPath) {
        performSegue(withIdentifier: showSingleImageSegueIdentifier, sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let photo = photos[indexPath.row]
        
        let imageInests = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidt = tableView.bounds.width - imageInests.left - imageInests.right
        let imageWidth = photo.size.width
        let scale = imageViewWidt / imageWidth
        let cellHeight = photo.size.height * scale + imageInests.top + imageInests.bottom
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        presenter?.willDisplay(at: indexPath.row)
    }
}

extension ImagesListViewController: ImagesListCellDelegate {
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = tableView?.indexPath(for: cell) else { return }
        presenter?.didTapLike(at: indexPath.row)
        }
    }

extension ImagesListViewController {
    func updateTableViewAnimated(oldCount: Int, newCount: Int) {
        print("🟢 updateTableViewAnimated: old=\(oldCount), new=\(newCount)")
        self.photos = (presenter as? ImageListPresenter)?.photos ?? []
        
        if oldCount != newCount {
            tableView?.performBatchUpdates {
                let indexPaths = (oldCount..<newCount).map { i in IndexPath(row: i, section: 0)
                }
                tableView?.insertRows(at: indexPaths, with: .automatic)
            } completion: { _ in }
        }
    }
    
    func updateLikeStatus(at index: Int, isLiked: Bool) {
        let indexPath = IndexPath(row: index, section: 0)
        guard let cell = tableView?.cellForRow(at: indexPath) as? ImagesListCell else { return }
        
        let imageName = isLiked ? "like_button_on" : "like_button_off"
        cell.likeButton?.setImage(UIImage(named: imageName), for: .normal)
        
        photos[index].isLiked = isLiked
    }
    
    func showLikeError(at index: Int) {
        let alert = UIAlertController(
            title: "Ошибка",
            message: "Не удалось поставить лайк",
            preferredStyle: .alert
            )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
