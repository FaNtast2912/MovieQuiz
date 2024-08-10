//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Maksim Zakharov on 09.08.2024.
//

import Foundation
import UIKit

final class MovieQuizPresenter {
    
    // MARK: - Public Properties
    weak var viewController: MovieQuizViewController?
    let questionsAmount: Int = 10
    var currentQuestion: QuizQuestion?
    
    // MARK: - Private Properties
    private var currentQuestionIndex: Int = 0
    
    
    // MARK: - Public Methods
    func yesButtonClicked() {
        didAnswer(isYes: true)
    }
    
    func noButtonClicked() {
        didAnswer(isYes: false)
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
    
    // MARK: - Private Methods
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(image: UIImage(data: model.image) ?? UIImage(), question: model.text, questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
    
    private func didAnswer(isYes: Bool) {
        guard let currentQuestion = currentQuestion else { return }
        let givenAnswer = isYes
        viewController?.showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
}

