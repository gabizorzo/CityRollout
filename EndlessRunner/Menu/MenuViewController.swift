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
        
        startButton.setTitle(String(localized: "menuView.play"), for: .normal)
//        startButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        startButton.setTitleColor(.white, for: .normal)
        startButton.titleLabel?.numberOfLines = 0
        startButton.titleLabel?.lineBreakMode = .byCharWrapping
        startButton.autoresizingMask = [.flexibleHeight, .flexibleWidth]

        howToPlayButton.setTitle("How to play", for: .normal)
        howToPlayButton.setTitleColor(.white, for: .normal)
        howToPlayButton.titleLabel?.numberOfLines = 0
        howToPlayButton.titleLabel?.lineBreakMode = .byCharWrapping
        howToPlayButton.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        settingsButton.setTitle(String(localized: "menuView.settings"), for: .normal)
//        settingsButton.setImage(UIImage(systemName: "gearshape.fill"), for: .normal)
        settingsButton.setTitleColor(.white, for: .normal)
        settingsButton.titleLabel?.numberOfLines = 0
        settingsButton.titleLabel?.lineBreakMode = .byCharWrapping
        settingsButton.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
}
