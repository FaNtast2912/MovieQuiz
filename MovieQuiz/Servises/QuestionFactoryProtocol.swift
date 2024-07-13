//
//  QuestionFactoryProtocol.swift
//  MovieQuiz
//
//  Created by Maksim Zakharov on 13.07.2024.
//

import Foundation

protocol QuestionFactoryProtocol {
    var questions: [QuizQuestion] { get }
    func requestNextQuestion() -> QuizQuestion?
}
