//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Илья Волощик on 17.03.24.
//

import UIKit

final class MovieQuizPresenter {
    
    private var currentQuestionIndex: Int = 0
    let questionsAmount: Int = 10
    var currentQuestion: QuizQuestion?
    weak var viewController: MovieQuizViewController?

     func convert(model: QuizQuestion) -> QuizStepViewModel {
        QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
    
    func isLastQuestion() -> Bool {
          currentQuestionIndex == questionsAmount - 1
      }
      
      func resetQuestionIndex() {
          currentQuestionIndex = 0
      }
      
      func switchToNextQuestion() {
          currentQuestionIndex += 1
      }
    
    // MARK: - Actions
    func yesButtonClicked() {
        let answer = true
        guard let currentQuestion = currentQuestion else {
            return
        }
            viewController?.showAnswerResult(isCorrect: answer == currentQuestion.correctAnswer)
    }
    
    func noButtonClicked() {
        let answer = false
        guard let currentQuestion = currentQuestion else {
            return
        }
            viewController?.showAnswerResult(isCorrect: answer == currentQuestion.correctAnswer)
    }
}
