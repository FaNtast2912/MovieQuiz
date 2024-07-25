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
        case bestGameCorrect
        case bestGameTotal
        case bestGameDate
        case totalAccuracy
        
    }
    
    var gamesCount: Int {
        get {storage.integer(forKey: Keys.gamesCount.rawValue)}
        set {storage.set(newValue, forKey: Keys.gamesCount.rawValue)}
    }
    
    var bestGame: GameResult {
        get {GameResult(correct: storage.integer(forKey: Keys.bestGameCorrect.rawValue), total: storage.integer(forKey: Keys.bestGameTotal.rawValue), date: storage.object(forKey: Keys.bestGameDate.rawValue) as? Date ?? Date())}
        set {
            storage.set(newValue.correct, forKey: Keys.bestGameCorrect.rawValue)
            storage.set(newValue.total, forKey: Keys.bestGameTotal.rawValue)
            storage.set(newValue.date, forKey: Keys.bestGameDate.rawValue)
        }
    }
    
    var totalAccuracy: Double {
        get {storage.double(forKey: Keys.totalAccuracy.rawValue)}
        set {storage.set(newValue, forKey: Keys.totalAccuracy.rawValue)}
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
