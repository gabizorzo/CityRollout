//
//  SettingsViewController.swift
//  EndlessRunner
//
//  Created by Gabriela Zorzo on 29/07/24.
//

import UIKit

class SettingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navBarItem: UINavigationItem!
    
    var viewModel: SettingsViewModel = SettingsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
        
        navBarItem.title = String(localized: "menuView.settings")
        
        let backButton = UIButton(type: .custom)
        backButton.setTitle(String(localized: "nav.back"), for: .normal)
        backButton.setTitleColor(.tintColor, for: .normal)
        backButton.tintColor = UIColor(red: 241/255, green: 111/255, blue: 2/255, alpha: 1)
        backButton.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        backButton.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        let barButtonItem = UIBarButtonItem(customView: backButton)
        navBarItem.leftBarButtonItem = barButtonItem
        
        UIAccessibility.post(notification: .screenChanged, argument: navBarItem)
    }

    @objc func backButtonAction() {
        self.navigationController?.popViewController(animated: false)
        Haptics.shared.buttonHaptic()
        Sounds.shared.buttonSound()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row < 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsToggleCell", for: indexPath) as! SettingsToggleCell
            
            cell.settingName = viewModel.settings[indexPath.row].name
            cell.settingLabel.text = viewModel.settings[indexPath.row].label
            cell.settingSwitch.isOn = viewModel.settings[indexPath.row].active
            cell.settingSwitch.onTintColor = UIColor(red: 241/255, green: 111/255, blue: 2/255, alpha: 1)
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsSelectCell", for: indexPath) as! SettingsSelectCell
            
            cell.settingName = viewModel.settings[indexPath.row].name
            cell.settingLabel.text = viewModel.settings[indexPath.row].label
            cell.settingLabel.numberOfLines = 2
            cell.settingLabel.lineBreakMode = .byCharWrapping
            
            cell.setupMenu()
            
            return cell
        }
    }
}
