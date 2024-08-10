//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Maksim Zakharov on 14.07.2024.
//

import Foundation
import UIKit

class AlertPresenter: AlertPresenterProtocol {
    
    
    private weak var delegate: UIViewController?
    
    init(delegate: UIViewController?) {
        self.delegate = delegate
    }
    
    func showAlert(in vc: UIViewController, model: AlertModel) {
        
        let alertController = UIAlertController(title: model.title, message: model.message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: model.buttonText, style: .default) { _ in
            model.completion()
        }
        alertController.addAction(alertAction)
        
        vc.present(alertController, animated: true, completion: nil)
    }
   
    
}
