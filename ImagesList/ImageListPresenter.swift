//
//  ImageListPresenter.swift
//  ImageFeed
//
//  Created by Наринэ  Овсепян on 24.05.2026.
//

/*import Foundation
import UIKit

protocol ImagesListPresenterProtocol: AnyObject {
    var view: ImagesListViewProtocol? { get set }
    
    func viewDidLoad()
    func didTapLike(at index: Int)
    func willDisplay(at index: Int)
}

protocol ImagesListViewProtocol: AnyObject {
    var presenter: ImagesListPresenterProtocol? { get set }
    
    func updateTableViewAnimated(oldCount: Int, newCount: Int)
    func updateLikeStatus(at index: Int, isLiked: Bool)
    func showLikeError(at index: Int)
}

final class ImageListPresenter: ImagesListPresenterProtocol {
    weak var view: ImagesListViewProtocol?
    
    private let imageListService: ImagesListService
    var photos: [Photo] = []
    
    init(imageListService: ImagesListService = .shared) {
        self.imageListService = imageListService
    }
    
    func viewDidLoad() {
        setupObserver()
        imageListService.fetchPhotosNextPage()
    }
    
    func didTapLike(at index: Int) {
        
        guard index < photos.count else { return }
        let photo = photos[index]
        let newLikeStatus = !photo.isLiked
        
        /* UIBlockingProgressHUD.show()*/
        
        imageListService.changeLike(photoId: photo.id, isLike: !photo.isLiked) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success:
                
                self.photos[index].isLiked = newLikeStatus
                self.view?.updateLikeStatus(at: index, isLiked: newLikeStatus)
                
            case .failure(let error):
                print("Ошибка лайка: \(error)")
            }
        }
    }
    
    func willDisplay(at index: Int) {
        if index + 1 == photos.count {
            print("tableView:willDisplay]: Загружаем следующую страницу")
            imageListService.fetchPhotosNextPage()
        }
    }
    
    private func setupObserver() {
        NotificationCenter.default.addObserver(
            forName: ImagesListService.didChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            guard let self = self else { return }
            let oldCount = self.photos.count
            self.photos = self.imageListService.photos
            let newCount = self.photos.count
            self.view?.updateTableViewAnimated(oldCount: oldCount, newCount: newCount)
        }
    }
}*/
