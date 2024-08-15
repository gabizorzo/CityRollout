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
    private let firstSettings: String = "firstSettings"
    
    private init() {}
    
    func getHighScore() -> Int {
        return userDefaults.integer(forKey: highScore)
    }
    
    func setHighScore(score: Int) {
        userDefaults.setValue(score, forKey: highScore)
    }
    
    func getFirstSettings() -> Bool {
        return userDefaults.bool(forKey: firstSettings)
    }
    
    func setFirstSettings() {
        userDefaults.setValue(true, forKey: firstSettings)
    }
    
    func toggleSettingsStatus(for setting: SettingsName){
        let value = !getSettingsStatus(for: setting)
        userDefaults.setValue(value, forKey: setting.rawValue)
    }
    
    func getSettingsStatus(for setting: SettingsName) -> Bool {
        return userDefaults.bool(forKey: setting.rawValue)
    }
    
    func setSettingsLevel(level: String, for setting: SettingsName){
        userDefaults.setValue(level, forKey: setting.rawValue)
    }
    
    func getSettingsDifficulty() -> SettingsDifficulty {
        let level = userDefaults.string(forKey: SettingsName.difficulty.rawValue) ?? ""
        return SettingsDifficulty(rawValue: level) ?? .medium
    }
}
