//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Илья Волощик on 17.03.24.
//

import UIKit

final class MovieQuizPresenter: QuestionFactoryDelegate {

    private var correctAnswers = 0
    private var currentQuestionIndex: Int = 0
    private let questionsAmount: Int = 10
    private var currentQuestion: QuizQuestion?
    
    private var questionFactory: QuestionFactoryProtocol?
    private weak var viewController: MovieQuizViewControllerProtocol?
    private let statisticService: StatisticService!

    init(viewController: MovieQuizViewControllerProtocol) {
            self.viewController = viewController
            
            statisticService = StatisticServiceImplementation()
        
            questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
            questionFactory?.loadData()
            viewController.showLoadingIndicator()
        }
    
     func convert(model: QuizQuestion) -> QuizStepViewModel {
       return QuizStepViewModel(
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
          questionFactory?.requestNextQuestion()
      }
      
    func switchToNextQuestion() {
          currentQuestionIndex += 1
      }
    
    func didCorrectAnswer(isCorrectAnswer: Bool) {
        if isCorrectAnswer {
            correctAnswers += 1
        }
    }
    
    func makeResultsAlert() -> AlertModel {
        
            statisticService.plusOneGameCount()
            let gamesCount = statisticService.gamesCount
            statisticService.store(correct: correctAnswers, total: questionsAmount)
            let bestGame = statisticService.bestGame
            statisticService.setTotalAccuracy(correctAnswers: correctAnswers, gamesCount: gamesCount)
            let totalAccuracy = statisticService.totalAccuracy
        
        
        let model = AlertModel(title: "Этот раунд окончен!",
                               message: """
                           Ваш результат: \(correctAnswers)/10
                           Количество сыгранных квизов \(gamesCount)
                           Рекорд: \(bestGame.correct)/\(bestGame.total) (\(bestGame.date.dateTimeString))
                           Средяя точность: \(String(format: "%.2f", totalAccuracy))%
                           """,
                               buttonText: "Сыграть ещё раз") {  [weak self]  in
            guard let self = self else { return }
            self.restartGame()
        }
        return model
    }
    
    func proceedToNextQuestionOrResults() {
       if isLastQuestion() {
           viewController?.showResult(alertModel: makeResultsAlert())
       } else {
           switchToNextQuestion()
           questionFactory?.requestNextQuestion()
       }
   }
    
    
    // MARK: - QuestionFactoryDelegate

    
    func didLoadDataFromServer() {
        viewController?.hideLoadingIndicator()
        questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: any Error) {
        let message = error.localizedDescription
        viewController?.showNetworkError(message: message)
    }
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else { return }
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.show(quiz: viewModel)
        }
    }
    
    func didFailToLoadImage() {
        let alert = UIAlertController(
                    title: "Ошибка!",
                    message: "Не удалось загрузить изображение",
                    preferredStyle: .alert
                )

                let action = UIAlertAction(
                    title: "Начать заново",
                    style: .default
                ) { [weak self] _ in
                    guard let self = self else {return}
                    self.viewController?.showLoadingIndicator()
                    self.questionFactory?.loadData()
                }
                alert.addAction(action)
        viewController?.didFailToLoadImageShow(alert: alert)
    }
    
    func didFailToLoadDataInvalidApiKey() {
        let alert = UIAlertController(title: "Не удалось загрузить данные!",
                                      message: """
                                      Причины по которым это могло произойти:
                                      
                                      API key неверный
                                      API key просрочен
                                      количество запросов в день превышено
                                      """,
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: "Начать заново", style: .default) { [weak self] _ in
            guard let self = self else {return}
            self.viewController?.showLoadingIndicator()
            self.questionFactory?.loadData()
        }
        alert.addAction(action)
        viewController?.didFailToLoadDataInvalidApiKeyShow(alert: alert)
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
            proceedWithAnswer(isCorrect: answer == currentQuestion.correctAnswer)
    }
    
    func proceedWithAnswer(isCorrect: Bool) {
            didCorrectAnswer(isCorrectAnswer: isCorrect)
            
            viewController?.highlightImageBorder(isCorrectAnswer: isCorrect)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
                guard let self = self else { return }
                self.proceedToNextQuestionOrResults()
                self.viewController?.buttonsIsEnabled()
            }
        }
}
