//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Илья Волощик on 23.02.24.
//

import UIKit

// MARK: - Модель лучшего результата


struct GameRecord: Codable {
    let correct: Int
    let total: Int
    let date: Date
    
    func isBetterThan(_ another: GameRecord) -> Bool {
        return correct > another.correct
    }
    
}

// MARK: - Протокол с обязательными свойствами и методами для класса

protocol StatisticService {
    var totalAccuracy: Double { get }
    var gamesCount: Int { get }
    var bestGame: GameRecord { get }
    
    func store(correct count: Int, total amount: Int)
    func plusOneGameCount()
    func setTotalAccuracy( correctAnswers: Int, gamesCount: Int)
}



// MARK: - Ключи для работы с Юзер Дефолтс

private enum Keys: String {
    case correct, total, bestGame, gamesCount
}



// MARK: - Класс для работы с Юзер Дефолтс

final class StatisticServiceImplementation: StatisticService {
    
    private let userDefaults = UserDefaults.standard
    
    var totalAccuracy: Double {
        
        get {
            guard let data = userDefaults.data(forKey: Keys.total.rawValue),
                  let total = try? JSONDecoder().decode(Double.self, from: data) else {
                return 0
            }
            return total
        }
        
        set {
            guard let data = try? JSONEncoder().encode(newValue) else {
                print("Невозможно сохранить результат")
                return
            }
            
            userDefaults.set(data, forKey: Keys.total.rawValue)
        }
    }
    
    var gamesCount: Int {
        
        get {
            guard let data = userDefaults.data(forKey: Keys.gamesCount.rawValue),
                  let gameCount = try? JSONDecoder().decode(Int.self, from: data) else {
                return 0
            }
            return gameCount
        }
        
        set {
            guard let data = try? JSONEncoder().encode(newValue) else {
                print("Невозможно сохранить результат")
                return
            }
            
            userDefaults.set(data, forKey: Keys.gamesCount.rawValue)
        }
    }
    
    
    var bestGame: GameRecord {
        
        get {
            guard let data = userDefaults.data(forKey: Keys.bestGame.rawValue),
                  let record = try? JSONDecoder().decode(GameRecord.self, from: data) else {
                return .init(correct: 0, total: 0, date: Date())
            }
            return record
        }
        
        set {
            guard let data = try? JSONEncoder().encode(newValue) else {
                print("Невозможно сохранить результат")
                return
            }
            userDefaults.set(data, forKey: Keys.bestGame.rawValue)
        }
    }
    
    // MARK: - Открытые методы класса, для работы с приватными сеттерами свойств
    
    func store(correct count: Int, total amount: Int) {
        
        let newGameRecord = GameRecord(correct: count, total: amount, date: Date())
        if !bestGame.isBetterThan(newGameRecord) {
            guard let data = try? JSONEncoder().encode(newGameRecord) else {
                print("Невозможно сохранить результат")
                return
            }
            
            userDefaults.set(data, forKey: Keys.bestGame.rawValue)
        }
    }
    
    func plusOneGameCount(){
        gamesCount+=1
    }
    
    func setTotalAccuracy( correctAnswers: Int, gamesCount: Int) {
        guard gamesCount != 0 else {return}
        var newTotalAccyracy: Double = Double(correctAnswers) * 10
        let oldTotalAccuracy = totalAccuracy * Double(gamesCount-1)
        newTotalAccyracy = (newTotalAccyracy + oldTotalAccuracy) / Double(gamesCount)
        totalAccuracy = newTotalAccyracy
    }
}
