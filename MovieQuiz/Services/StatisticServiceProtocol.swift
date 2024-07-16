//
//  StatisticServiceProtocol.swift
//  MovieQuiz
//
//  Created by Maksim Zakharov on 15.07.2024.
//

import Foundation

protocol StatisticServiceProtocol: AnyObject {
    var gamesCount: Int { get }
    var bestGame: GameResult { get }
    var totalAccuracy: Double { get }
    
    func store(correct count: Int, total amount: Int)
    
}

