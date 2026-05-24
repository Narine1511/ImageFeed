//
//  WebViewViewControllerSpy.swift
//  ImageFeed
//
//  Created by Наринэ  Овсепян on 17.05.2026.
//
import Testing
@testable import ImageFeed
import Foundation

final class WebViewViewControllerSpy: WebViewViewControllerProtocol {
    var presenter: ImageFeed.WebViewPresenterProtocol?
    
    var loadRequestCalled: Bool = false
    
    func load(request: URLRequest) {
        loadRequestCalled = true
    }
    
    func setProgressValue(_ newValue: Float) {}
    
    func setProgressHidden(_ isHidden: Bool) {}
}
