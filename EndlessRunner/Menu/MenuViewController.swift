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
    
//    override func viewWillLayoutSubviews() {
//            
//    }
    
    override func viewWillLayoutSubviews() {
        // UICTContentSizeCategoryAccessibilityM
        // UICTContentSizeCategoryAccessibilityXXL
        // UICTContentSizeCategoryXS
        // UICTContentSizeCategoryXXL
        let scalingFactor = UIApplication.shared.preferredContentSizeCategory.isAccessibilityCategory ? 2.0 : 3.0

        guard let startButtonHeight = startButton.titleLabel?.intrinsicContentSize.height,
              let howToPlayButtonHeight = howToPlayButton.titleLabel?.intrinsicContentSize.height,
              let settingsButtonHeight = settingsButton.titleLabel?.intrinsicContentSize.height else { return }
        
        if let startButtonHeightContraint = startButton.constraints.first(where: { $0.firstAttribute == .height && $0.relation == .equal }),
           let howToPlayHeightConstraint = howToPlayButton.constraints.first(where: { $0.firstAttribute == .height && $0.relation == .equal }),
           let settingsButtonHeightConstraint = settingsButton.constraints.first(where: { $0.firstAttribute == .height && $0.relation == .equal })
        {
            startButtonHeightContraint.constant = startButtonHeight * scalingFactor
            howToPlayHeightConstraint.constant = howToPlayButtonHeight * scalingFactor
            settingsButtonHeightConstraint.constant = settingsButtonHeight * scalingFactor
        }
        
    }
    
    override func viewDidLoad() {
        backgroundImage.frame.size = UIScreen.main.bounds.size
        
        startButton.setTitle(String(localized: "menuView.play"), for: .normal)
        
        startButton.setTitleColor(.white, for: .normal)
        startButton.titleLabel?.numberOfLines = 0
        startButton.titleLabel?.lineBreakMode = .byCharWrapping
//        let height = (startButton.titleLabel?.intrinsicContentSize.height)! * 1.5
//        startButton.heightAnchor.constraint(equalToConstant: height).isActive = true
//        startButton.autoresizingMask = [.flexibleHeight, .flexibleWidth]

        howToPlayButton.setTitle(String(localized: "menuView.howToPlay"), for: .normal)
        howToPlayButton.setTitleColor(.white, for: .normal)
        howToPlayButton.titleLabel?.numberOfLines = 0
        howToPlayButton.titleLabel?.lineBreakMode = .byCharWrapping
//        howToPlayButton.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        settingsButton.setTitle(String(localized: "menuView.settings"), for: .normal)
        settingsButton.setTitleColor(.white, for: .normal)
        settingsButton.titleLabel?.numberOfLines = 0
        settingsButton.titleLabel?.lineBreakMode = .byCharWrapping
//        settingsButton.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        UIAccessibility.post(notification: .screenChanged, argument: startButton)
    }
}
