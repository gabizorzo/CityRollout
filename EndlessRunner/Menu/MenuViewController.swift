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
        startButton.setTitleColor(.white, for: .normal)
        startButton.titleLabel?.numberOfLines = 0
        startButton.titleLabel?.lineBreakMode = .byCharWrapping

        howToPlayButton.setTitle(String(localized: "menuView.howToPlay"), for: .normal)
        howToPlayButton.setTitleColor(.white, for: .normal)
        howToPlayButton.titleLabel?.numberOfLines = 0
        howToPlayButton.titleLabel?.lineBreakMode = .byCharWrapping
        
        settingsButton.setTitle(String(localized: "menuView.settings"), for: .normal)
        settingsButton.setTitleColor(.white, for: .normal)
        settingsButton.titleLabel?.numberOfLines = 0
        settingsButton.titleLabel?.lineBreakMode = .byCharWrapping
        
        adjustButtonsHeight()
        
        UIAccessibility.post(notification: .screenChanged, argument: startButton)
    }
    
    private func adjustButtonsHeight() {
        let scalingFactor = UIApplication.shared.preferredContentSizeCategory.isAccessibilityCategory ? 1.5 : 1.7

        guard let startButtonHeight = startButton.titleLabel?.intrinsicContentSize.height,
              let howToPlayButtonHeight = howToPlayButton.titleLabel?.intrinsicContentSize.height,
              let settingsButtonHeight = settingsButton.titleLabel?.intrinsicContentSize.height else { return }
        
        startButton.heightAnchor.constraint(equalToConstant: startButtonHeight * scalingFactor).isActive = true
        howToPlayButton.heightAnchor.constraint(equalToConstant: howToPlayButtonHeight * scalingFactor).isActive = true
        settingsButton.heightAnchor.constraint(equalToConstant: settingsButtonHeight * scalingFactor).isActive = true
        
        self.view.layoutIfNeeded()
    }
}
