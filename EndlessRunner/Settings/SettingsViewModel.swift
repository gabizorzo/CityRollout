//
//  SettingsViewModel.swift
//  EndlessRunner
//
//  Created by Gabriela Zorzo on 29/07/24.
//

import Foundation

class SettingsViewModel {
    
    var settings: [SettingsModel]
    
    init() {
        var statusHaptics = true
        var statusSounds = true
        var statusFaceMovements = false
        
        if !Database.shared.getFirstSettings() {
            Database.shared.setFirstSettings()
        } else {
            statusHaptics = Database.shared.getSettingsStatus(for: .haptics)
            statusSounds = Database.shared.getSettingsStatus(for: .sounds)
            statusFaceMovements = Database.shared.getSettingsStatus(for: .faceMovements)
        }
        
        let haptics: SettingsModel = SettingsModel(label: String(localized: "settingsView.haptics"), name: .haptics, active: statusHaptics)
        let sounds: SettingsModel = SettingsModel(label: String(localized: "settingsView.sounds"), name: .sounds, active: statusSounds)
        let faceMovements: SettingsModel = SettingsModel(label: String(localized: "settingsView.faceMoves"), name: .faceMovements, active: statusFaceMovements)
        
        let currentDifficulty = Database.shared.getSettingsDifficulty()
        let difficulty: SettingsModel = SettingsModel(label: String(localized: "settingsView.difficulty"), name: .difficulty, active: true, difficulty: currentDifficulty)
        
        settings = [haptics, sounds, faceMovements, difficulty]
    }
}
