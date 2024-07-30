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
        
        navBarItem.title = "Settings"
        
        let backButton = UIButton(type: .custom)
        backButton.setTitle("Back", for: .normal)
        backButton.setTitleColor(.tintColor, for: .normal)
        backButton.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        backButton.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        let barButtonItem = UIBarButtonItem(customView: backButton)
        navBarItem.leftBarButtonItem = barButtonItem
    }

    @objc func backButtonAction() {
        self.navigationController?.popViewController(animated: false)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
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
