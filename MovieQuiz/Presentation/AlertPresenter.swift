//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Maksim Zakharov on 14.07.2024.
//

import Foundation
import UIKit

class AlertPresenter: AlertPresenterProtocol {
    func showAlert(in vc: UIViewController, model: AlertModel) {
        let alert = UIAlertController(
            title: model.title,
            message: model.message,
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: model.buttonText, style: .default) { _ in
            model.completion()
        }
        
        alert.addAction(action)
        
        vc.present(alert, animated: true, completion: nil)
    }
}
