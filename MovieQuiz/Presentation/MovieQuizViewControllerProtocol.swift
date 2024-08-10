//
//  MovieQuizViewControllerProtocol.swift
//  MovieQuiz
//
//  Created by Maksim Zakharov on 10.08.2024.
//

import Foundation

protocol MovieQuizViewControllerProtocol: AnyObject {
    func show(quiz step: QuizStepViewModel)
    func show(quiz result: QuizResultsViewModel)
    func highlightImageBorder(isCorrectAnswer: Bool)
    func clearImageBorder()
    func unableButton()
    func showLoadingIndicator()
    func hideLoadingIndicator()
    func showNetworkError(message: String)
}
