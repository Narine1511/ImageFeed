//
//  ProfileSpy.swift
//  ImageFeed
//
//  Created by Наринэ  Овсепян on 24.05.2026.
//
import Testing
import XCTest
@testable import ImageFeed

final class ProfileViewSpy: ProfileViewProtocol {
    var presenter: ProfilePresenterProtocol?
    
    var displayProfileDataCalled = false
    var receivedName: String?
    var receivedLogin: String?
    var receiedDescription: String?
    
    func displayProfileData(name: String, login: String, description: String) {
        displayProfileDataCalled = true
        receivedName = name
        receivedLogin = login
        receiedDescription = description
    }
    
    func displayAvatar(with url: URL) {}
    func showLogoutAlert() {}
}

final class ProfilePresenterTests: XCTestCase {
    func testViewDidLoadCallsDisplayProfileData() {
        let presenter = ProfilePresenter()
        let spy = ProfileViewSpy()
        presenter.view = spy
        
        presenter.viewDidLoad()
        
        XCTAssertTrue(spy.displayProfileDataCalled)
    }
}
