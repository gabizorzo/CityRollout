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
        guard let settingName = settingName else { return }
        
        let level = Database.shared.getSettingsDifficulty()
        
        let menuClosure = {(action: UIAction) in
            self.update(level: action.title)
        }
        
        selectButton.menu = UIMenu(children: [
            UIAction(title: "easy", state: level == .easy ? .on : .off, handler: menuClosure),
            UIAction(title: "medium", state: level == .medium ? .on : .off, handler: menuClosure),
            UIAction(title: "hard", state: level == .hard ? .on : .off, handler: menuClosure),
        ])
        
        selectButton.showsMenuAsPrimaryAction = true
        selectButton.changesSelectionAsPrimaryAction = true
    }
    
    func update(level: String) {
        guard let settingName = settingName else { return }
        
        Database.shared.setSettingsLevel(level: level, for: settingName)
        Haptics.shared.buttonHaptic()
        Sounds.shared.buttonSound()
    }
}
