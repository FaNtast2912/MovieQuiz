//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Maksim Zakharov on 13.07.2024.
//

import Foundation
//В структуре AlertModel должны быть:
//текст заголовка алерта title,
//текст сообщения алерта message,
//текст для кнопки алерта buttonText,
//замыкание без параметров для действия по кнопке алерта completion.
//private func show(quiz result: QuizResultsViewModel) {
//    let alertController = UIAlertController(title: result.title, message: result.text, preferredStyle: .alert)
//    let action = UIAlertAction(title: result.buttonText, style: .default) { [weak self] _ in
//        guard let self = self else {return}
//        self.currentQuestionIndex = 0
//        self.correctAnswers = 0
//        questionFactory?.requestNextQuestion()
//        
//        
//    }
//    
//    alertController.addAction(action)
//    
//    self.present(alertController, animated: true, completion: nil)
//    
//}
//if currentQuestionIndex == questionsAmount - 1 {
//    let alertScreen = QuizResultsViewModel(title: "Этот раунд окончен!", text: "Ваш результат \(correctAnswers)/10", buttonText: "Сыграть еще раз")
//    show(quiz: alertScreen)

struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    let completion: ()
}
