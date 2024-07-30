//
//  SettingsModel.swift
//  EndlessRunner
//
//  Created by Gabriela Zorzo on 29/07/24.
//

import Foundation

enum SettingsName: String {
    case haptics, sounds, faceMovements, speed
}

enum SettingsLevel: String {
    case easy, medium, hard
}

struct SettingsModel {
    var label: String
    var name: SettingsName
    var active: Bool
    var level: SettingsLevel?
}
