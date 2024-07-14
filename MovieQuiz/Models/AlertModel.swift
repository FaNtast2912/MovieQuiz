//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Maksim Zakharov on 13.07.2024.
//

import Foundation
struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    let completion: () -> Void
}
