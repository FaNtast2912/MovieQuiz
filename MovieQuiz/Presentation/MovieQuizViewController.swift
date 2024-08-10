import UIKit

final class MovieQuizViewController: UIViewController, AlertPresenterDelegate {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var yesButton: UIButton!
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var textViewQuestion: UILabel!
    @IBOutlet private weak var activityIndicatorView: UIActivityIndicatorView!
    
    // MARK: - Public Properties
    
    // MARK: - Private Properties
    private var presenter: MovieQuizPresenterProtocol?
    private var currentQuestion: QuizQuestion?
    private var alertPresenter: AlertPresenterProtocol?
    private var statisticService: StatisticServiceProtocol?
    
    // MARK: - Initializers
    
    // MARK: - Overrides Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // font set
        textLabel.font = UIFont(name: "YSDisplay-Bold", size: 23)
        textViewQuestion.font = UIFont(name: "YSDisplay-Medium", size: 20)
        counterLabel.font = UIFont(name: "YSDisplay-Medium", size: 20)
        yesButton.titleLabel?.font = UIFont(name: "YSDisplay-Medium", size: 20)
        noButton.titleLabel?.font = UIFont(name: "YSDisplay-Medium", size: 20)
        
        alertPresenter = AlertPresenter()
        statisticService = StatisticService()
        showLoadingIndicator()
        imageView.layer.cornerRadius = 20
        presenter = MovieQuizPresenter(viewController: self)
    }
    
    // MARK: - IB Actions
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        presenter?.yesButtonClicked()
        yesButton.isEnabled = false
        noButton.isEnabled = false
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        presenter?.noButtonClicked()
        yesButton.isEnabled = false
        noButton.isEnabled = false
    }
    
    // MARK: - Public Methods
    
    // Setting Alert Model for show Network Error
    func setNetworkErrorAlertModel(errorMessage: String) -> AlertModel {
        let model = AlertModel(title: "Ошибка", message: errorMessage, buttonText: "Попробовать еще раз") { [weak self] in
            guard let self = self else { return }
            presenter?.restartGame()
        }
        return model
    }
    
    // MARK: - Private Methods
    
    //Show Loading Indicator
    func showLoadingIndicator() {
        activityIndicatorView.isHidden = false // говорим, что индикатор загрузки не скрыт
        activityIndicatorView.startAnimating() // включаем анимацию
    }
    
    //Hide Loading Indicator
    func hideLoadingIndicator() {
        activityIndicatorView.isHidden = true // говорим, что индикатор загрузки скрыт
        /*activityIndicatorView.stopAnimating()*/ // выключаем анимацию
    }
    
    func showNetworkError(message: String) {
        hideLoadingIndicator() // скрываем индикатор загрузки
        alertPresenter?.showAlert(in: self, model: setNetworkErrorAlertModel(errorMessage: message))// создайте и покажите алерт
        self.presenter?.restartGame()
    }
    
    func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    
    func show(quiz result: QuizResultsViewModel) {
        var message = result.text
        if let statisticService = statisticService {
            statisticService.store(correct: presenter?.correctAnswers ?? 0, total: presenter?.questionsAmount ?? 0)

            let bestGame = statisticService.bestGame

            let totalPlaysCountLine = "Количество сыгранных квизов: \(statisticService.gamesCount)"
            let currentGameResultLine = "Ваш результат: \(presenter?.correctAnswers ?? 0)\\\(presenter?.questionsAmount ?? 0)"
            let bestGameInfoLine = "Рекорд: \(bestGame.correct)\\\(bestGame.total)"
            + " (\(bestGame.date.dateTimeString))"
            let averageAccuracyLine = "Средняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%"

            let resultMessage = [
                currentGameResultLine, totalPlaysCountLine, bestGameInfoLine, averageAccuracyLine
            ].joined(separator: "\n")

            message = resultMessage
        }

        let model = AlertModel(title: result.title, message: message, buttonText: result.buttonText) { [weak self] in
            guard let self = self else { return }

            presenter?.restartGame()
        }

        alertPresenter?.showAlert(in: self, model: model)
    }
    
    // react on answer
    func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            presenter?.didAnswer(isCorrectAnswer: isCorrect)
        }
        
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect == true ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        imageView.layer.cornerRadius = 20
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else {return}
            self.yesButton.isEnabled = true
            self.noButton.isEnabled = true
            self.imageView.layer.borderColor = UIColor.clear.cgColor
            self.presenter?.showNextQuestionOrResults()
        }
    }
}
