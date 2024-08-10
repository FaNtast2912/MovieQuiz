//
//  AlertPresenterProtocol.swift
//  MovieQuiz
//
//  Created by Maksim Zakharov on 14.07.2024.
//

import Foundation
import UIKit

protocol AlertPresenterProtocol {
    func showAlert(in vc: UIViewController, model: AlertModel) 
}
