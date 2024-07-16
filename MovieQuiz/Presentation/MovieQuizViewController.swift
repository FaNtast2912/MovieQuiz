import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate, AlertPresenterDelegate {

    // MARK: - Outlets

    @IBOutlet private weak var yesButton: UIButton!
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var textViewQuestion: UILabel!
    
    // MARK: - Public Properties

    // MARK: - Private Properties
    
    private var currentQuestionIndex = 0
    private var correctAnswers = 0
    private let questionsAmount: Int = 10
    private var questionFactory: QuestionFactoryProtocol?
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
        
        
        let questionFactory = QuestionFactory()
            questionFactory.delegate = self
            self.questionFactory = questionFactory
        
        questionFactory.requestNextQuestion()
        alertPresenter = AlertPresenter(delegate: self)
        statisticService = StatisticService()
        
        
    }
    
    // MARK: - IB Actions
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        guard currentQuestion != nil else {return}
        let givenAnswer = currentQuestion?.correctAnswer
        showAnswerResult(isCorrect: givenAnswer == true) // проверь как работает в прошлом проекте
        yesButton.isEnabled = false
        noButton.isEnabled = false
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        guard currentQuestion != nil else {return}
        let givenAnswer = currentQuestion?.correctAnswer
        showAnswerResult(isCorrect: givenAnswer == false) // проверь как работает в прошлом проекте
        noButton.isEnabled = false
        yesButton.isEnabled = false
    }

    // MARK: - Public Methods
    
    // QuestionFactoryDelegate
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {return}

        currentQuestion = question
        let viewModel = convert(model: question)
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {return}
            self.show(quiz: viewModel)
        }
    }
    
    // Setting Alert Model for show
    func setAlertModel() -> AlertModel {
        
        guard let statisticService else {return AlertModel(title: "Ошибка", message: "error 1.01", buttonText: "Сыграть еще раз") {[weak self] in
            guard let self = self else {return}
            self.currentQuestionIndex = 0
            self.correctAnswers = 0
            questionFactory?.requestNextQuestion()
        }}
        // store results
        statisticService.store(correct: correctAnswers, total: questionsAmount)
        
        let endGameScreen = AlertModel(
            title: "Этот раунд окончен!",
            message: "Ваш результат \(correctAnswers)/10\n"
            + "Количество сыгранных квизов: \(statisticService.gamesCount)\n"
            + "Рекорд: \(statisticService.bestGame.correct)/\(statisticService.bestGame.total) (\(statisticService.bestGame.date.dateTimeString))\n"
            + "Средняя точность: \(String(format: "%.2f", (statisticService.totalAccuracy)))%",
            buttonText: "Сыграть еще раз") {[weak self] in
            guard let self = self else {return}
            self.currentQuestionIndex = 0
            self.correctAnswers = 0
            questionFactory?.requestNextQuestion()
        }
            
        return endGameScreen
    }
    
    // next screen or restart game
    func showNextQuestionOrResults() {
        
        if currentQuestionIndex == questionsAmount - 1 {
            alertPresenter?.showEndGameScreen(model: setAlertModel())
            
        } else {
            currentQuestionIndex += 1
            questionFactory?.requestNextQuestion()
        }
    }
    
    // MARK: - Private Methods
    
    // convert mok
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(image: UIImage(named: model.image) ?? UIImage(), question: model.text, questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
    
    // set our screen
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    
    // react on answer
    private func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            correctAnswers += 1
        }
    
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect == true ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        imageView.layer.cornerRadius = 20
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else {return}
            self.yesButton.isEnabled = true
            self.noButton.isEnabled = true
            self.showNextQuestionOrResults()
            self.imageView.layer.borderColor = UIColor.clear.cgColor
        }
    }
}
