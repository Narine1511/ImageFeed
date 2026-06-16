//
//  ImageFeedUITests.swift
//  ImageFeedUITests
//
//  Created by Наринэ  Овсепян on 01.02.2026.
//

import XCTest
@testable import ImageFeed
import Foundation

final class ImageFeedUITests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    @MainActor
    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    @MainActor
    func testLaunchPerformance() throws {
        // This measures how long it takes to launch your application.
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            XCUIApplication().launch()
        }
    }
    func testAuth() throws {
        let app = XCUIApplication()
        app.launch()
        sleep(8)
        app.buttons["Authenticate"].tap()
        
        let webView = app.webViews["UnsplashWebView"]
        
        XCTAssertTrue(webView.waitForExistence(timeout: 5))
        
        let loginTextField = webView.descendants(matching: .textField).element
        XCTAssertTrue(loginTextField.waitForExistence(timeout: 5))
        
        loginTextField.tap()
        loginTextField.typeText("")
        webView.swipeUp()
        
        let passwordTextField = webView.descendants(matching: .secureTextField).element
        XCTAssertTrue(passwordTextField.waitForExistence(timeout: 5))
        
        passwordTextField.tap()
        passwordTextField.typeText("")
        webView.swipeUp()
        
        app.buttons["Done"].firstMatch.tap()
        
        webView.buttons["Login"].tap()
        
        let tableQuery = app.tables
        let cell = tableQuery.children(matching: .cell).element(boundBy: 0)
        
        XCTAssertTrue(cell.waitForExistence(timeout: 5))
    }
    
    func testFeed() throws {
        let app = XCUIApplication()
        app.launch()
        
        let table = app.tables.firstMatch
        XCTAssertTrue(table.waitForExistence(timeout: 10))
        
        table.swipeUp()
        sleep(5)
    
        let cellToLike = app.tables.cells.element(boundBy: 0)
           /* XCTAssertTrue(cellToLike.waitForExistence(timeout: 5), "Ячейка не появилась")*/
        let likeButton = cellToLike.buttons["like_button"]
            XCTAssertTrue(likeButton.waitForExistence(timeout: 3))
        
        let initialValue = likeButton.value as? String
        
        likeButton.tap()
        sleep(5)
        
        let afterFirstTap = likeButton.value as? String
        XCTAssertNotEqual(initialValue, afterFirstTap)
        
        likeButton.tap()
        sleep(3)
        
        let final = likeButton.value as? String
        XCTAssertEqual(initialValue, final)
        
        cellToLike.tap()
        sleep(3)
        
        let image = app.scrollViews.images.element(boundBy: 0)
        XCTAssertTrue(image.waitForExistence(timeout: 5))
        
        image.pinch(withScale: 3, velocity: 1)
        image.pinch(withScale: 0.5, velocity: -1)
        
        let navBackButtonWhiteButton = app.buttons["nav_back_button"]
        XCTAssertTrue(navBackButtonWhiteButton.waitForExistence(timeout: 3))
        navBackButtonWhiteButton.tap()
        
    }
    
    func testProfile() throws {
        
        let app = XCUIApplication()
        app.launch()
        
        let table = app.tables.firstMatch
        XCTAssertTrue(table.waitForExistence(timeout: 5))
        
        let tablesQuery = app.tables.firstMatch
        XCTAssertTrue(tablesQuery.waitForExistence(timeout: 5))
        
        let tabBar = app.tabBars.firstMatch
        sleep(4)
        app.tabBars.buttons.element(boundBy: 1).tap()
        
        XCTAssertTrue(app.staticTexts[""].exists)
        XCTAssertTrue(app.staticTexts[""].exists)
        
        let logoutButton = app.buttons["exitImage"]
        app.buttons["exitImage"].tap()
        XCTAssertTrue(logoutButton.waitForExistence(timeout: 3))
        
        let alert = app.alerts.firstMatch
        XCTAssertTrue(alert.waitForExistence(timeout: 3))
        
        let confirmButton = app.buttons["Да"]
        XCTAssertTrue(confirmButton.waitForExistence(timeout: 3))
        confirmButton.tap()
        
        let authButton = app.buttons["Войти"]
        XCTAssertTrue(authButton.waitForExistence(timeout: 5))
    }
    
}
