//
//  MovieQuizViewControllerProtocol.swift
//  MovieQuiz
//
//  Created by Илья Волощик on 18.03.24.
//

import UIKit

protocol MovieQuizViewControllerProtocol: AnyObject {
    func didFailToLoadImageShow(alert: UIAlertController)
    func didFailToLoadDataInvalidApiKeyShow(alert: UIAlertController)
    func didShow(alert: UIAlertController?)
    func show(quiz step: QuizStepViewModel)
    func highlightImageBorder(isCorrectAnswer: Bool)
    func showLoadingIndicator()
    func hideLoadingIndicator()
    
    func showNetworkError(message: String)
    func buttonsIsEnabled()
    func showResult(alertModel: AlertModel)
}
