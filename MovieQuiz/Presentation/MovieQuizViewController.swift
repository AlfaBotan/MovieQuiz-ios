import UIKit

final class MovieQuizViewController: UIViewController, AlertPresenterDelegate {

    
    private var alertPresenter: AlertPresenterProtocol?
    private var statisticService: StatisticService?
    private var moviesLoader: MoviesLoader?
    
    private var presenter: MovieQuizPresenter!

    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var yesButton: UIButton!
    @IBOutlet private weak var noButton: UIButton!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = MovieQuizPresenter(viewController: self)

        showLoadingIndicator()
        statisticService = StatisticServiceImplementation()
        
        
        alertPresenter = AlertPresenter()
        alertPresenter?.delegate = self
        
    }
    
    // MARK: - QuestionFactoryDelegate
    
    
//    func didFailToLoadImage() {
//        let alert = UIAlertController(
//                    title: "Ошибка!",
//                    message: "Не удалось загрузить изображение",
//                    preferredStyle: .alert
//                )
//
//                let action = UIAlertAction(
//                    title: "Начать заново",
//                    style: .default
//                ) { [weak self] _ in
//                    guard let self = self else {return}
//                    self.showLoadingIndicator()
//                    questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
//                    questionFactory?.loadData()
//                }
//                alert.addAction(action)
//                self.present(alert, animated: true, completion: nil)
//    }
//    
//    func didFailToLoadDataInvalidApiKey() {
//        let alert = UIAlertController(title: "Не удалось загрузить данные!",
//                                      message: """
//                                      Причины по которым это могло произойти:
//                                      
//                                      API key неверный
//                                      API key просрочен
//                                      количество запросов в день превышено
//                                      """,
//                                      preferredStyle: .alert)
//        let action = UIAlertAction(title: "Начать заново", style: .default) { [weak self] _ in
//            guard let self = self else {return}
//            self.showLoadingIndicator()
//                self.presenter.questionFactory?.loadData()
//        }
//        alert.addAction(action)
//        self.present(alert, animated: true, completion: nil)
//    }
    
    // MARK: - AlertPresenterDelegate
    func didShow(alert: UIAlertController?) {
        guard let alert = alert else { return }
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Private Functions
    
     func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        counterLabel.text = step.questionNumber
        textLabel.text = step.question
    }
    
     func showAnswerResult(isCorrect: Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        if isCorrect {
            imageView.layer.borderColor = UIColor.ypGreen.cgColor
            presenter.didCorrectAnswer()
        } else {
            imageView.layer.borderColor = UIColor.ypRed.cgColor
        }
        yesButton.isEnabled = false
        noButton.isEnabled = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.imageView.layer.borderWidth = 0
            
            self.presenter.showNextQuestionOrResults()
            
            self.yesButton.isEnabled = true
            self.noButton.isEnabled = true
        }
    }
    
    func showResult(correctAnswers: Int) {
        statisticService?.plusOneGameCount()
        guard let gamesCount = statisticService?.gamesCount else {return}
        statisticService?.store(correct: correctAnswers, total: presenter.questionsAmount)
        guard let bestGame = statisticService?.bestGame else {return}
        statisticService?.setTotalAccuracy(correctAnswers: correctAnswers, gamesCount: gamesCount)
        guard let totalAccuracy = statisticService?.totalAccuracy else {return}
        let model = AlertModel(title: "Этот раунд окончен!",
                               message: """
                           Ваш результат: \(correctAnswers)/10
                           Количество сыгранных квизов \(gamesCount)
                           Рекорд: \(bestGame.correct)/\(bestGame.total) (\(bestGame.date.dateTimeString))
                           Средяя точность: \(String(format: "%.2f", totalAccuracy))%
                           """,
                               buttonText: "Сыграть ещё раз") {  [weak self]  in
            guard let self = self else { return }
            self.presenter.restartGame()
        }
        alertPresenter?.createAlert(model: model)
    }
    
    func showLoadingIndicator() {
        activityIndicator.startAnimating()
    }
    
     func hideLoadingIndicator() {
        activityIndicator.stopAnimating()
    }
    
     func showNetworkError(message: String) {
        
        let model = AlertModel(title: "Ошибка",
                               message: message,
                               buttonText: "Попробовать еще раз") {  [weak self]  in
            guard let self = self else { return }
                self.presenter.restartGame()
        }
        alertPresenter?.createAlert(model: model)
    }
    

    // MARK: - Actions
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        presenter.yesButtonClicked()
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        presenter.noButtonClicked()
    }
}
