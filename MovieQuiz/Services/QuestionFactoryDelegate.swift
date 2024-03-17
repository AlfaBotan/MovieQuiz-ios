//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Илья Волощик on 14.02.24.
//

import UIKit

protocol QuestionFactoryDelegate: AnyObject {
    
    func didReceiveNextQuestion(question: QuizQuestion?)
    func didLoadDataFromServer()
    func didFailToLoadData(with error: Error)
    func didFailToLoadImage()
    func didFailToLoadDataInvalidApiKey()
}
