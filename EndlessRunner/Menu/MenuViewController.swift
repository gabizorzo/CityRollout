//
//  MenuView.swift
//  EndlessRunner
//
//  Created by João Dall Agnol on 22/07/24.
//

import UIKit

class MenuViewController: UIViewController {
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var gameLogoImage: UIImageView!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var howToPlayButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
        
    //MARK: - Settings button tap feedback
    @IBAction func buttonTapFeedback(_ sender: Any) {
        Haptics.shared.buttonHaptic()
        Sounds.shared.buttonSound()
    }
    
    override func viewDidLoad() {
        backgroundImage.frame.size = UIScreen.main.bounds.size
        
        let buttonInsets = NSDirectionalEdgeInsets(top: 16, leading: 0, bottom: 16, trailing: 0)
        startButton.setTitle(String(localized: "menuView.play"), for: .normal)
        startButton.setTitleColor(.white, for: .normal)
        var buttonConfig = startButton.configuration
        buttonConfig?.contentInsets = buttonInsets
        buttonConfig?.titleLineBreakMode = .byTruncatingTail
        startButton.configuration = buttonConfig

        howToPlayButton.setTitle(String(localized: "menuView.howToPlay"), for: .normal)
        howToPlayButton.setTitleColor(.white, for: .normal)
        buttonConfig = howToPlayButton.configuration
        buttonConfig?.contentInsets = buttonInsets
        buttonConfig?.titleLineBreakMode = .byTruncatingTail
        howToPlayButton.configuration = buttonConfig
        
        settingsButton.setTitle(String(localized: "menuView.settings"), for: .normal)
        settingsButton.setTitleColor(.white, for: .normal)
        buttonConfig = settingsButton.configuration
        buttonConfig?.contentInsets = buttonInsets
        buttonConfig?.titleLineBreakMode = .byTruncatingTail
        settingsButton.configuration = buttonConfig
        
        UIAccessibility.post(notification: .screenChanged, argument: startButton)
    }
    
}
