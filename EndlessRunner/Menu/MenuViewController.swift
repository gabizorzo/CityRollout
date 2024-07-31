//
//  MenuView.swift
//  EndlessRunner
//
//  Created by João Dall Agnol on 22/07/24.
//

import UIKit

class MenuViewController: UIViewController {
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    
    override func viewDidLoad() {
        backgroundImage.frame.size = UIScreen.main.bounds.size
        
        startButton.setTitle("Tap to play", for: .normal)
        startButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        startButton.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        settingsButton.setTitle("Settings", for: .normal)
        settingsButton.setImage(UIImage(systemName: "gearshape.fill"), for: .normal)
        settingsButton.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
}
