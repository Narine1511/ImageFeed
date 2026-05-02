//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Наринэ  Овсепян on 29.04.2026.
//

import Foundation
import UIKit

// MARK: - UI Model
struct Photo {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: String
    let largeImageURL: String
    let isLiked: Bool
}

// MARK: - Network Models
struct PhotoResult: Codable {
    let id: String
    let createdAt: String
    let width: Int
    let height: Int
    let likedByUser: Bool
    let description: String?
    let urls: UrlsResult
    
    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case width
        case height
        case likedByUser = "liked_by_user"
        case description
        case urls
    }
}

struct UrlsResult: Codable {
    let thumb: String
    let full: String
}

// MARK: - Service
final class ImagesListService {
    static let shared = ImagesListService()
    
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    
    private(set) var photos: [Photo] = []
    private var lastLoadedPage: Int?
    
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private var isFetching = false
    
    private lazy var dateFormatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        return formatter
    }()
    
    private init() {}
    
    func fetchPhotosNextPage() {
        guard !isFetching else {
            print("[fetchPhotosNextPage]: Ошибка: уже выполняется загрузка")
            return
        }
        
        let nextPage = (lastLoadedPage ?? 0) + 1
        print("[fetchPhotosNextPage]: Загружаем страницу \(nextPage)")
        
        guard let request = makePhotosRequest(page: nextPage) else {
            print("[fetchPhotosNextPage]: Ошибка: не удалось создать запрос")
            return
        }
        isFetching = true
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<[PhotoResult], Error>) in
            guard let self = self else {return}
            
            defer {
                self.isFetching = false
            }
            
            switch result {
            case .success(let photoResults):
                let newPhotos = photoResults.map { photoResult in
                    Photo(
                        id: photoResult.id,
                        size: CGSize(width: photoResult.width, height: photoResult.height),
                        createdAt: self.dateFormatter.date(from: photoResult.createdAt),
                        welcomeDescription: photoResult.description,
                        thumbImageURL: photoResult.urls.thumb,
                        largeImageURL: photoResult.urls.full,
                        isLiked: photoResult.likedByUser
                    )
                }
                    
                DispatchQueue.main.async {
                    
                    self.photos.append(contentsOf: newPhotos)
                    self.lastLoadedPage = nextPage
                    
                    NotificationCenter.defaultpost(name: ImagesListService.didChangeNotification, object: nil)
                    
                case .failure(let error):
                    print("[fetchPhotosNextPage]: Ошибка: \(error)")
                }
            }
            self.task = task
            task.resume()
        }
    }
    
    private func makePhotosRequest(page: Int) -> URLRequest? {
        guard let url = URL(string: "https://api.unsplash.com/photos") else {
            print("[makePhotosRequest]: Ошибка: не удалось создать URL")
            return nil
        }
        guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            print("[makePhotosRequest]: Ошибка: не удалось создать URLComponents")
            return nil
        }
        urlComponents.queryItems = [
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "per_page", value: "10")
        ]
        
        guard let finalURL = urlComponents.url else {
            print("[makePhotosRequest]: Ошибка: не удалось собрать URL")
            return nil
        }
        
        var request = URLRequest(url: finalURL)
        request.httpMethod = "GET"
        
        if let token = OAuth2TokenStorage.shared.token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        } else {
            print("[makePhotosRequest]: Ошибка: отсутствует токен")
            return nil
        }
        return request
    }
}
