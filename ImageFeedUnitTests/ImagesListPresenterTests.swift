//
//  ImagesListPresenterTests.swift
//  ImageFeed
//
//  Created by Наринэ  Овсепян on 30.05.2026.
//
import Testing
import UIKit
@testable import ImageFeed
import Foundation
import XCTest

// Тест 1: вызов презентера при загрузке
final class ImagesListViewControllerTests: XCTestCase {
    func testViewControllerCallsPresenterViewDidLoad() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(
            identifier: "ImagesListViewController") as! ImagesListViewController
        
        let presenterSpy = ImagesListPresenterSpy()
        
        viewController.presenter = presenterSpy
        presenterSpy.view = viewController
        
        
        _ = viewController.view
        
        XCTAssertTrue(presenterSpy.viewDidLoadCalled)
    }
// Тест 2: метод лайка не падает
    func testViewControllerDoesNotCrashWhenLikeTapped() {

        let viewController = ImagesListViewController()
        let presenterSpy = ImagesListPresenterSpy()
        
        viewController.presenter = presenterSpy
        presenterSpy.view = viewController
        
        let cell = ImagesListCell()
        
        viewController.imageListCellDidTapLike(cell)
        
        XCTAssertTrue(true)
    }
}
