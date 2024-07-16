//
//  GameResultModel.swift
//  MovieQuiz
//
//  Created by Maksim Zakharov on 15.07.2024.
//

import Foundation


struct GameResult {
    
    let correct: Int
    let total: Int
    let date: Date
    
    func isBetterThen(_ previousRecord: GameResult) -> Bool {correct > previousRecord.correct ? true : false}
}
