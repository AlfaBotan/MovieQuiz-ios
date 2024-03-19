//
//  MovieQuizPresenterTests.swift
//  MovieQuizPresenterTests
//
//  Created by Илья Волощик on 18.03.24.
//

import UIKit
import XCTest

@testable import MovieQuiz

final class MovieQuizViewControllerMock: MovieQuizViewControllerProtocol {
    func didShow(alert: UIAlertController?) {
    
    }
    
    
    func didFailToLoadImageShow(alert: UIAlertController) {
        
    }
    
    func didFailToLoadDataInvalidApiKeyShow(alert: UIAlertController) {
        
    }
    
    func buttonsIsEnabled() {
        
    }
    
    func showResult(alertModel: MovieQuiz.AlertModel) {
        
    }
    
    
    func show(quiz step: QuizStepViewModel) {
    
    }
    
    func highlightImageBorder(isCorrectAnswer: Bool) {
    
    }
    
    func showLoadingIndicator() {
    
    }
    
    func hideLoadingIndicator() {
    
    }
    
    func showNetworkError(message: String) {
    
    }
}

//final class MovieQuizPresenterTests: XCTestCase {
//    
//    func testPresenterConvertModel() throws {
//        let viewControllerMock = MovieQuizViewControllerMock()
//        let sut = MovieQuizPresenter(viewController: viewControllerMock)
//        
//        let emptyData = Data()
//        let question = QuizQuestion(image: emptyData, text: "Question Text", correctAnswer: true)
//        let viewModel = sut.convert(model: question)
//        
//        XCTAssertNotNil(viewModel.image)
//        XCTAssertEqual(viewModel.question, "Question Text")
//        XCTAssertEqual(viewModel.questionNumber, "1/10")
//    }
//}

final class MovieQuizPresenterTests: XCTestCase {
    func testPresenterConvertModel() throws {
        let viewControllerMock = MovieQuizViewControllerMock()
        let sut = MovieQuizPresenter(viewController: viewControllerMock)
        
        let emptyData = Data()
        let question = QuizQuestion(image: emptyData, text: "Question Text", correctAnswer: true)
        let viewModel = sut.convert(model: question)
        
         XCTAssertNotNil(viewModel.image)
        XCTAssertEqual(viewModel.question, "Question Text")
        XCTAssertEqual(viewModel.questionNumber, "1/10")
    }
}


