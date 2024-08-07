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
}
