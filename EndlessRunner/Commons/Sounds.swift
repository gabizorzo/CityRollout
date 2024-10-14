//
//  Sounds.swift
//  EndlessRunner
//
//  Created by João Dall Agnol on 12/08/24.
//

import AVFoundation

class Sounds {
    static var shared = Sounds()
    
    func buttonSound() {
        let soundStatus = Database.shared.getSettingsStatus(for: .sounds)
        
        if soundStatus {
            AudioServicesPlayAlertSound(1057) // PINKeyPressed
        }
    }
    
    func startGameSound() {
        let soundStatus = Database.shared.getSettingsStatus(for: .sounds)
        
        if soundStatus {
            AudioServicesPlayAlertSound(1113) // BeginRecording
        }
    }
    
    func gameOverSound() {
        let soundStatus = Database.shared.getSettingsStatus(for: .sounds)
        
        if soundStatus {
            AudioServicesPlayAlertSound(1324) // Descent
        }
    }
    
    func bonusSound() {
        let soundStatus = Database.shared.getSettingsStatus(for: .sounds)
        
        if soundStatus {
            AudioServicesPlayAlertSound(1072) // AudioTonePathAcknowledge
        }
    }
    
    func obstacleSound() {
        let soundStatus = Database.shared.getSettingsStatus(for: .sounds)
        
        if soundStatus {
            AudioServicesPlayAlertSound(1070) // AudioToneBusy
        }
    }
}

