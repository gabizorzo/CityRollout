//
//  SettingsSelectCell.swift
//  EndlessRunner
//
//  Created by Gabriela Zorzo on 30/07/24.
//

import UIKit

class SettingsSelectCell: UITableViewCell {
    
    @IBOutlet weak var settingLabel: UILabel!
    @IBOutlet weak var selectButton: UIButton!
    
    var settingName: SettingsName?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupMenu() {        
        let level = Database.shared.getSettingsDifficulty()
        
        let menuClosure = {(action: UIAction) in
            self.update(title: action.title)
        }
        
        selectButton.menu = UIMenu(children: [
            UIAction(title: String(localized: "settingsView.easy"), state: level == .easy ? .on : .off, handler: menuClosure),
            UIAction(title: String(localized: "settingsView.medium"), state: level == .medium ? .on : .off, handler: menuClosure),
            UIAction(title: String(localized: "settingsView.hard"), state: level == .hard ? .on : .off, handler: menuClosure),
        ])

        selectButton.showsMenuAsPrimaryAction = true
        selectButton.changesSelectionAsPrimaryAction = true
        selectButton.tintColor = UIColor(red: 241/255, green: 111/255, blue: 2/255, alpha: 1)
    }
    
    func update(title: String) {
        guard let settingName = settingName else { return }
        
        var difficulty: SettingsDifficulty = .medium
        
        if title == String(localized: "settingsView.easy") {
            difficulty = .easy
        } else if title == String(localized: "settingsView.medium") {
            difficulty = .medium
        } else if title == String(localized: "settingsView.hard") {
            difficulty = .hard
        }
        
        Database.shared.setSettingsDifficulty(difficulty: difficulty, for: settingName)
        Haptics.shared.buttonHaptic()
        Sounds.shared.buttonSound()
    }
}
