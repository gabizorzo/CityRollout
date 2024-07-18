//
//  Database.swift
//  EndlessRunner
//
//  Created by Gabriela Zorzo on 17/07/24.
//

import Foundation

class Database {
    private let userDefaults = UserDefaults.standard
    static var shared = Database()
    
    private let highScore: String = "highScore"
    
    private init() {}
    
    func getHighScore() -> Int {
        return userDefaults.integer(forKey: highScore)
    }
    
    func setHighScore(score: Int) {
        userDefaults.setValue(score, forKey: highScore)
    }
}
