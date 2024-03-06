import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate, AlertPresenterDelegate {
    
    
    
    private var currentQuestionIndex = 0
    private var correctAnswers = 0
    private let questionsAmount: Int = 10
    
    private var questionFactory: QuestionFactoryProtocol?
    private var alertPresenter: AlertPresenterProtocol?
    private var statisticService: StatisticService?
    private var currentQuestion: QuizQuestion?
    private var moviesLoader: MoviesLoader?
    
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var yesButton: UIButton!
    @IBOutlet private weak var noButton: UIButton!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        showLoadingIndicator()
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        statisticService = StatisticServiceImplementation()
        
        questionFactory?.loadData()
        
        alertPresenter = AlertPresenter()
        alertPresenter?.delegate = self
        
    }
    
    // MARK: - QuestionFactoryDelegate
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else { return }
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }
    }
    
    func didLoadDataFromServer() {
        activityIndicator.isHidden = true
        questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Error) {
        showNetworkError(message: error.localizedDescription)
    }
    
    // MARK: - AlertPresenterDelegate
    func didShow(alert: UIAlertController?) {
        guard let alert = alert else { return }
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Private Functions
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        let quizStepViewModel = QuizStepViewModel(image: UIImage(data: model.image) ?? UIImage(),
                                                  question: model.text,
                                                  questionNumber: "\(currentQuestionIndex+1)/\(questionsAmount)")
        
        return quizStepViewModel
    }
    
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        counterLabel.text = step.questionNumber
        textLabel.text = step.question
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        if isCorrect {
            imageView.layer.borderColor = UIColor.ypGreen.cgColor
            correctAnswers+=1
        } else {
            imageView.layer.borderColor = UIColor.ypRed.cgColor
        }
        yesButton.isEnabled = false
        noButton.isEnabled = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.imageView.layer.borderWidth = 0
            self.showNextQuestionOrResults()
            self.yesButton.isEnabled = true
            self.noButton.isEnabled = true
        }
    }
    
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questionsAmount - 1 {
            statisticService?.plusOneGameCount()
            guard let gamesCount = statisticService?.gamesCount else {return}
            statisticService?.store(correct: correctAnswers, total: questionsAmount)
            guard let bestGame = statisticService?.bestGame else {return}
            statisticService?.setTotalAccuracy(correctAnswers: correctAnswers, gamesCount: gamesCount)
            guard let totalAccuracy = statisticService?.totalAccuracy else {return}
            alertPresenter?.createAlert(model: AlertModel(title: "Этот раунд окончен!",
                                                          message: """
                                                      Ваш результат: \(correctAnswers)/10
                                                      Количество сыгранных квизов \(gamesCount)
                                                      Рекорд: \(bestGame.correct)/\(bestGame.total) (\(bestGame.date.dateTimeString))
                                                      Средяя точность: \(String(format: "%.2f", totalAccuracy))%
                                                      """,
                                                          buttonText: "Сыграть ещё раз",
                                                          completionClosure: {  [weak self]  in
                guard let self = self else { return }
                self.currentQuestionIndex = 0
                self.correctAnswers = 0
                
                questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
                questionFactory?.loadData()
            }))
        } else {
            currentQuestionIndex += 1
            questionFactory?.requestNextQuestion()
        }
    }
    
    private func showLoadingIndicator() {
        
        activityIndicator.startAnimating()
    }
    
    private func hideLoadingIndicator() {
        
        activityIndicator.stopAnimating()
    }
    
    private func showNetworkError(message: String) {
        
        
        let model = AlertModel(title: "Ошибка",
                               message: message,
                               buttonText: "Попробовать еще раз") {  [weak self]  in
            guard let self = self else { return }
            self.currentQuestionIndex = 0
            self.correctAnswers = 0
            
            questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
            questionFactory?.loadData()
            
        }
        alertPresenter?.createAlert(model: model)
        
        
    }
    
    // MARK: - Actions
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        let answer = true
        guard let currentQuestion = currentQuestion else {
            return
        }
        showAnswerResult(isCorrect: answer == currentQuestion.correctAnswer)
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        let answer = false
        guard let currentQuestion = currentQuestion else {
            return
        }
        showAnswerResult(isCorrect: answer == currentQuestion.correctAnswer)
    }
}
