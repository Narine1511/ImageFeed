//
//  ViewController.swift
//  ImageFeed
//
//  Created by Наринэ  Овсепян on 01.02.2026.
//

import UIKit
import Kingfisher

final class ImagesListViewController: UIViewController {
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    
    private let imageListService = ImagesListService.shared
    private var photos: [Photo] = []
    
    @IBOutlet private var tableView: UITableView?
    
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    } ()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView?.rowHeight = 200
        tableView?.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        
        NotificationCenter.default.addObserver(
            forName: ImagesListService.didChangeNotification,
            object: nil,
            queue: .main
        ) {[weak self] _ in
            self?.updateTableViewAnimated()
        }
        imageListService.fetchPhotosNextPage()
    }
    
    /*private func updateTableView() {
     let oldCount = photos.count
     photos = imageListService.photos
     
     if oldCount != photos.count {
     tableView?.reloadData()
     }
     }*/
    
    
    private func updateTableViewAnimated()  {
        let oldCount = photos.count
        let newCount = imageListService.photos.count
        
        photos = imageListService.photos
        
        if oldCount != newCount {
            tableView?.performBatchUpdates {
                let indexPaths = (oldCount..<newCount).map { i in
                    IndexPath(row: i, section: 0)
                }
                tableView?.insertRows(at: indexPaths, with: .automatic)
            } completion: { _ in }
        }
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
        return photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
        if indexPath.row + 1 == photos.count {
            print("tableView:willDisplay]: Загружаем следующую страницу")
            ImagesListService.shared.fetchPhotosNextPage()
        }
    }
}

extension ImagesListViewController: ImagesListCellDelegate {
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = tableView?.indexPath(for: cell) else { return }
        let photo = photos[indexPath.row]
        
        UIBlockingProgressHUD.show()
        
        imageListService.changeLike(photoId: photo.id, isLike: !photo.isLiked) { [weak self] result in
            guard let self = self else { return }
            
            UIBlockingProgressHUD.dismiss()
            
            switch result {
            case .success:
                self.photos = self.imageListService.photos
                
                if let updatedCell = self.tableView?.cellForRow(at: indexPath) as? ImagesListCell {
                    let updatedPhoto = self.photos[indexPath.row]
                    updatedCell.setIsLiked(updatedPhoto.isLiked)
                }
            case .failure(let error):
                print("Ошибка лайка: \(error)")
            }
        }
    }
}
