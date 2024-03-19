//
//  MovieQuizUITests.swift
//  MovieQuizUITests
//
//  Created by Илья Волощик on 13.03.24.
//
import UIKit
import XCTest
@testable import MovieQuiz

final class MovieQuizUITests: XCTestCase {

    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        app = XCUIApplication()
        app.launch()
        
        
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        
        
        app.terminate()
        app = nil
       
    }

    func testExample() throws {
        let app = XCUIApplication()
        app.launch()

    }
    
    
    
        func testScreenCast() throws {
            app.buttons["Нет"].tap()
        }
    
    func testYesButton() {
        
        sleep(3)
        
        let firstPoster = app.images["Poster"]
        let firstPosterData = firstPoster.screenshot().pngRepresentation

        app.buttons["Yes"].tap()
        sleep(3)
        
        let secondPoster = app.images["Poster"]
        let secondPosterData = secondPoster.screenshot().pngRepresentation
        let indexLabel = app.staticTexts["Index"]
        
        XCTAssertEqual(indexLabel.label, "2/10")
        XCTAssertFalse(firstPosterData == secondPosterData)
    }
    
    func testNoButton() {
        
        sleep(3)
        
        let firstPoster = app.images["Poster"]
        let firstPosterData = firstPoster.screenshot().pngRepresentation

        app.buttons["No"].tap()
        sleep(3)
        
        let secondPoster = app.images["Poster"]
        let secondPosterData = secondPoster.screenshot().pngRepresentation
        let indexLabel = app.staticTexts["Index"]
        
        XCTAssertEqual(indexLabel.label, "2/10")
        XCTAssertFalse(firstPosterData == secondPosterData)
    }
    
    func testFinishAlert() {
        sleep(3)
        for _ in 1...10 {
            app.buttons["Yes"].tap()
            sleep(3)
        }
        
        let finishAlert = app.alerts["Этот раунд окончен!"]
        XCTAssertTrue(finishAlert.exists)
        XCTAssertTrue(finishAlert.label == "Этот раунд окончен!")
        XCTAssertTrue(finishAlert.buttons.firstMatch.label == "Сыграть ещё раз")
    }
    
    func testAlertDismiss() {
        sleep(2)
        for _ in 1...10 {
            app.buttons["Yes"].tap()
            sleep(2)
        }
        
        let finishAlert = app.alerts["Этот раунд окончен!"]
        finishAlert.buttons.firstMatch.tap()
        
        sleep(2)
        
        let indexLabel = app.staticTexts["Index"]
        
        XCTAssertFalse(finishAlert.exists)
        XCTAssertTrue(indexLabel.label == "1/10")
    }
}
