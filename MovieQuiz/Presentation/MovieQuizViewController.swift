import UIKit

final class MovieQuizViewController: UIViewController, AlertPresenterDelegate, MovieQuizViewControllerProtocol {
    
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
    private var alertPresenter: AlertPresenterProtocol?
    
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
    
    func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    
    func show(quiz result: QuizResultsViewModel) {
        guard let message = presenter?.makeResultsMessage() else { return }
        
        let alert = UIAlertController(
            title: result.title,
            message: message,
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: result.buttonText, style: .default) { [weak self] _ in
            guard let self = self else { return }
            
            self.presenter?.restartGame()
        }
        
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func highlightImageBorder(isCorrectAnswer: Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrectAnswer ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
    }
    func clearImageBorder() {
        imageView.layer.borderColor = UIColor.clear.cgColor
    }
    
    func unableButton() {
        self.yesButton.isEnabled = true
        self.noButton.isEnabled = true
    }
    
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
    
    
    
    // MARK: - Private Methods
    
    // Setting Alert Model for show Network Error
    private func setNetworkErrorAlertModel(errorMessage: String) -> AlertModel {
        let model = AlertModel(title: "Ошибка", message: errorMessage, buttonText: "Попробовать еще раз") { [weak self] in
            guard let self = self else { return }
            presenter?.restartGame()
        }
        return model
    }
}
