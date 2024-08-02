//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Maksim Zakharov on 13.07.2024.
//

import Foundation
protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
    func didLoadDataFromServer()
    func didFailToLoadData(with error: Error)
}
