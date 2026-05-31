//
//  ImagesListViewControllerSpy.swift
//  ImageFeed
//
//  Created by Наринэ  Овсепян on 30.05.2026.
//
import Testing
@testable import ImageFeed
import Foundation

final class ImagesListPresenterSpy: ImagesListPresenterProtocol {
    weak var view: ImagesListViewProtocol?
    
    var viewDidLoadCalled = false
    var didTapLikeCalled = false
    var willDisplayCalled = false
    
    var lastLikeIndex = 0
    var lastWillDisplayIndex = 0
    
    var photosCount: Int = 0
    
    func photo(at index: Int) -> Photo {
        return Photo(id: "", size: .zero, createdAt: Date(), welcomeDescription: nil, thumbImageURL: "", largeImageURL: "", isLiked: false)
    }
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func didTapLike(at index: Int) {
        didTapLikeCalled = true
        lastLikeIndex = index
    }
    
    func willDisplay(at index: Int) {
        willDisplayCalled = true
        lastLikeIndex = index
    }
}
