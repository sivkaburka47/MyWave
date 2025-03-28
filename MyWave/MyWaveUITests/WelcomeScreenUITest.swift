//
//  MyWaveUITests.swift
//  MyWaveUITests
//
//  Created by Станислав Дейнекин on 05.03.2025.
//

import XCTest
@testable import MyWave

final class WelcomeScreenUITests: XCTestCase {
    var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()
        
        continueAfterFailure = false
        
        app = XCUIApplication()
        
        app.launchArguments = ["UITesting"]
        app.launch()
    }
    
    override func tearDown() {
        app = nil
        super.tearDown()
    }
    
    
    func testWelcomeScreenElementsAndButtonInteraction() {
        let welcomeLabel = app.staticTexts["welcomeLabel"]
        let loginButton = app.buttons["loginButton"]
        
        XCTAssertTrue(welcomeLabel.exists, "Метка приветствия должна существовать")
        XCTAssertTrue(welcomeLabel.isHittable, "Метка приветствия должна быть видима")
        XCTAssertEqual(welcomeLabel.label, "Добро пожаловать",
                      "Метка приветствия должна отображать правильный текст")
        
        XCTAssertTrue(loginButton.exists, "Кнопка входа должна существовать")
        XCTAssertTrue(loginButton.isHittable, "Кнопка входа должна быть видима")
        
        let buttonText = loginButton.staticTexts["Войти через Apple ID"]
        XCTAssertTrue(buttonText.exists, "Кнопка входа должна содержать правильный текст")
        
        let expectation = XCTestExpectation(description: "Обработчик нажатия кнопки входа")
        
        loginButton.tap()
        
        let journalScreen = app.otherElements["JournalScreen"]
        let journalScreenAppeared = journalScreen.waitForExistence(timeout: 5)
        
        XCTAssertTrue(journalScreenAppeared, "Экран с идентификатором 'JournalScreen' должен отобразиться после нажатия кнопки входа")
    }
    

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
