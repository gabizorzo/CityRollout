//
//  SettingsViewController.swift
//  EndlessRunner
//
//  Created by Gabriela Zorzo on 29/07/24.
//

import UIKit

class SettingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: SettingsViewModel = SettingsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsToggleCell", for: indexPath) as! SettingsToggleCell
        
        cell.settingName = viewModel.settings[indexPath.row].name
        cell.settingLabel.text = viewModel.settings[indexPath.row].label
        cell.settingSwitch.isOn = viewModel.settings[indexPath.row].active
        
        return cell
    }
}
