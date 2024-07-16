//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Maksim Zakharov on 15.07.2024.
//

import Foundation

class StatisticService: StatisticServiceProtocol {
    
    private let storage: UserDefaults = .standard
    
    private enum Keys: String {
        case correct
        case bestGame
        case gamesCount
    }
    
    var gamesCount: Int {
        get {storage.integer(forKey: Keys.gamesCount.rawValue)}
        set {storage.set(newValue, forKey: Keys.gamesCount.rawValue)}
    }
    
    var bestGame: GameResult {
        get {GameResult(correct: storage.integer(forKey: "bestGameCorrect"), total: storage.integer(forKey: "bestGameTotal"), date: storage.object(forKey: "bestGameDate") as? Date ?? Date())}
        set {
            storage.set(newValue.correct, forKey: "bestGameCorrect")
            storage.set(newValue.total, forKey: "bestGameTotal")
            storage.set(newValue.date, forKey: "bestGameDate")
        }
    }
    
    var totalAccuracy: Double {
        get {storage.double(forKey: "totalAccuracy")}
        set {storage.set(newValue, forKey: "totalAccuracy")}
    }
    
    var correct: Int {
        get {storage.integer(forKey: Keys.correct.rawValue)}
        set {storage.set(newValue, forKey: Keys.correct.rawValue)}
    }
    
    
    func store(correct count: Int, total amount: Int) {
        correct += count
        gamesCount += 1
        totalAccuracy = (Double(correct)/Double(10*gamesCount))*100
    
        
        if GameResult(correct: count, total: amount, date: Date()).isBetterThen(bestGame) {
            bestGame = GameResult(correct: count, total: amount, date: Date())
        }
        
    }
    
    
}
