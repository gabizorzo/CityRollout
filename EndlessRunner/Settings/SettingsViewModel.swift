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
        
        let haptics: SettingsModel = SettingsModel(label: "Haptics", name: .haptics, active: statusHaptics)
        let sounds: SettingsModel = SettingsModel(label: "Sounds", name: .sounds, active: statusSounds)
        let faceMovements: SettingsModel = SettingsModel(label: "Face movements", name: .faceMovements, active: statusFaceMovements)
        
        let level = Database.shared.getSettingsLevel(for: .difficulty)
        let difficulty: SettingsModel = SettingsModel(label: "Difficulty", name: .difficulty, active: true, level: level)
        
        settings = [haptics, sounds, faceMovements, difficulty]
    }
}
