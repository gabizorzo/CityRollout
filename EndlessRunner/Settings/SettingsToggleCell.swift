//
//  SettingsToggleCell.swift
//  EndlessRunner
//
//  Created by Gabriela Zorzo on 29/07/24.
//

import UIKit

class SettingsToggleCell: UITableViewCell {
    
    @IBOutlet weak var settingLabel: UILabel!
    @IBOutlet weak var settingSwitch: UISwitch!
    
    var settingName: SettingsName?
    
    @IBAction func switchAction(_ sender: Any) {
        guard let settingName = settingName else { return }
        
        Database.shared.toggleSettingsStatus(for: settingName)
        let status = Database.shared.getSettingsStatus(for: settingName)
        settingSwitch.isOn = status
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
