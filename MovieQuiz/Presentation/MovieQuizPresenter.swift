//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Илья Волощик on 17.03.24.
//

import UIKit

final class MovieQuizPresenter {
    
     var questionFactory: QuestionFactoryProtocol?
     var correctAnswers = 0

    
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
      
      func restartGame() {
          currentQuestionIndex = 0
          correctAnswers = 0
      }
      
      func switchToNextQuestion() {
          currentQuestionIndex += 1
      }
    
    func didCorrectAnswer() {
            correctAnswers += 1
    }
    
    // MARK: - Actions
    func yesButtonClicked() {
        didAnswer(isYes: true)
    }
    
    func noButtonClicked() {
        didAnswer(isYes: false)
    }
    
    private func didAnswer(isYes: Bool) {
        let answer = isYes
        guard let currentQuestion = currentQuestion else {
            return
        }
            viewController?.showAnswerResult(isCorrect: answer == currentQuestion.correctAnswer)       
    }
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else { return }
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.show(quiz: viewModel)
        }
    }
    
     func showNextQuestionOrResults() {
        if isLastQuestion() {
            viewController?.showResult(correctAnswers: correctAnswers)
        } else {
            switchToNextQuestion()
            questionFactory?.requestNextQuestion()
        }
    }
}
