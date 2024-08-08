//
//  Haptics.swift
//  EndlessRunner
//
//  Created by João Dall Agnol on 07/08/24.
//

import Foundation
import UIKit

// UISelectionFeedbackGenerator
// UINotificationFeedbackGenerator
// UIImpactFeedbackGenerator

enum hapticName {
    case button, enemyCollision
}

class Haptics {
    static var shared = Haptics()
    
    func buttonHaptic() {
        let hapticsStatus = Database.shared.getSettingsStatus(for: .haptics)
        
        if hapticsStatus {
            let generator = UISelectionFeedbackGenerator()
            generator.prepare()
            generator.selectionChanged()
        }
    }
    
    func startGameHaptic() {
        let hapticsStatus = Database.shared.getSettingsStatus(for: .haptics)
        
        if hapticsStatus {
            let generator = UINotificationFeedbackGenerator()
            generator.prepare()
            generator.notificationOccurred(.success)
        }
    }
    
    func gameOverHaptic() {
        let hapticsStatus = Database.shared.getSettingsStatus(for: .haptics)
        
        if hapticsStatus {
            let generator = UINotificationFeedbackGenerator()
            generator.prepare()
            generator.notificationOccurred(.error)
        }
    }
    
    func obstacleHaptic() {
        let hapticsStatus = Database.shared.getSettingsStatus(for: .haptics)
        
        if hapticsStatus {
            let generator = UIImpactFeedbackGenerator(style: .heavy)
            generator.prepare()
            generator.impactOccurred()
        }
    }
    
    func bonusHaptic() {
        let hapticsStatus = Database.shared.getSettingsStatus(for: .haptics)
        
        if hapticsStatus {
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.prepare()
            generator.impactOccurred()
        }
    }
}
