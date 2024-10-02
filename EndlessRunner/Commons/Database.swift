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
    private let firstSettings: String = "firstSettingsSetupi"
    private let firstTutorial: String = "firstTutorial"
    
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
    
    func getFirstTutorial() -> Bool {
        return userDefaults.bool(forKey: firstTutorial)
    }
    
    func setFirstTutorial() {
        userDefaults.setValue(true, forKey: firstTutorial)
    }
    
    func setSettingsStatus(value: Bool, for setting: SettingsName){
        userDefaults.setValue(value, forKey: setting.rawValue)
    }
    
    func toggleSettingsStatus(for setting: SettingsName){
        let value = !getSettingsStatus(for: setting)
        userDefaults.setValue(value, forKey: setting.rawValue)
    }
    
    func getSettingsStatus(for setting: SettingsName) -> Bool {
        return userDefaults.bool(forKey: setting.rawValue)
    }
    
    func setSettingsDifficulty(difficulty: SettingsDifficulty, for setting: SettingsName){
        userDefaults.setValue(difficulty.rawValue, forKey: setting.rawValue)
    }
    
    func getSettingsDifficulty() -> SettingsDifficulty {
        let difficulty = userDefaults.string(forKey: SettingsName.difficulty.rawValue) ?? ""
        return SettingsDifficulty(rawValue: difficulty) ?? .medium
    }
}
