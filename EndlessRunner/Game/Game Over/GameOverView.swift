//
//  GameOverView.swift
//  EndlessRunner
//
//  Created by Gabriela Zorzo on 18/07/24.
//
import UIKit

class GameOverView: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var gameOverTitleLabel: UILabel!
    @IBOutlet weak var yourScoreLabel: UILabel!
    @IBOutlet weak var highScoreLabel: UILabel!
    @IBOutlet weak var restartButton: UIButton!
    @IBOutlet weak var menuButton: UIButton!
    
    @IBOutlet weak var leadConstraint: NSLayoutConstraint!
    @IBOutlet weak var trailConstraint: NSLayoutConstraint!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("GameOverView", owner: self, options: nil)
        addSubview(contentView)
        
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.backgroundColor = .black.withAlphaComponent(0.3)
        
        gameOverTitleLabel.lineBreakMode = .byCharWrapping
        yourScoreLabel.lineBreakMode = .byCharWrapping
        highScoreLabel.lineBreakMode = .byCharWrapping
        
        let buttonInsets = NSDirectionalEdgeInsets(top: 16, leading: 0, bottom: 16, trailing: 0)
        restartButton.setTitle(String(localized: "gameOverView.playAgain"), for: .normal)
        var buttonConfig = restartButton.configuration
        buttonConfig?.contentInsets = buttonInsets
        buttonConfig?.titleLineBreakMode = .byTruncatingTail
        restartButton.configuration = buttonConfig
        
        menuButton.setTitle(String(localized: "gameOverView.exit"), for: .normal)
        buttonConfig = menuButton.configuration
        buttonConfig?.contentInsets = buttonInsets
        buttonConfig?.titleLineBreakMode = .byTruncatingTail
        menuButton.configuration = buttonConfig
    }
    
    func setupScore(score: Int, isNewHighScore: Bool) {
        if isNewHighScore {
             gameOverTitleLabel.text = String(localized: "gameOverView.congratulations")
             yourScoreLabel.text = String(localized: "gameOverView.newHighScore") + " \(score)"
             highScoreLabel.isHidden = true
         } else {
             gameOverTitleLabel.text = String(localized: "gameOverView.gameOver")
             yourScoreLabel.text = String(localized: "gameOverView.yourScore") + " \(score)"
             highScoreLabel.text = String(localized: "gameOverView.highScore") + " \(Database.shared.getHighScore())"
             highScoreLabel.isHidden = false
         }
    }
    
    func setStackBehavior(_ currentOrientation: UIDeviceOrientation) {
        let isPortrait = currentOrientation == .portrait || currentOrientation == .portraitUpsideDown
        let priority: Float = isPortrait ? 1000 : 250
        if isPortrait {
            self.trailConstraint.priority = UILayoutPriority(priority)
            self.leadConstraint.priority = UILayoutPriority(priority)
            
            self.gameOverTitleLabel.numberOfLines = 0
            self.yourScoreLabel.numberOfLines = 0
            self.highScoreLabel.numberOfLines = 0
            
            adjustButtonsInsets(size: 16)
        } else {
            self.trailConstraint.priority = UILayoutPriority(priority)
            self.leadConstraint.priority = UILayoutPriority(priority)
            
            self.gameOverTitleLabel.numberOfLines = 1
            self.yourScoreLabel.numberOfLines = 1
            self.highScoreLabel.numberOfLines = 1
            
            let currentContentSize = UIApplication.shared.preferredContentSizeCategory
            if currentContentSize == .accessibilityExtraExtraExtraLarge || currentContentSize == .accessibilityExtraExtraLarge {
                adjustButtonsInsets(size: 0)
            } else {
                adjustButtonsInsets(size: 16)
            }
            
        }
    }
    
    func adjustButtonsInsets(size: CGFloat) {
            var buttonConfig = restartButton.configuration
            let buttonInsets = NSDirectionalEdgeInsets(top: size, leading: 0, bottom: size, trailing: 0)
            buttonConfig?.contentInsets = buttonInsets
            restartButton.configuration = buttonConfig
            
            buttonConfig = menuButton.configuration
            buttonConfig?.contentInsets = buttonInsets
            menuButton.configuration = buttonConfig
    }
    
    //MARK: - Actions
    var restartButtonAction: () -> Void = {}
    @IBAction func restartAction(_ sender: UIButton) {
        restartButtonAction()
    }
    
    var menuButtonAction: () -> Void = {}
    @IBAction func menuAction(_ sender: Any) {
        menuButtonAction()
    }
    
}
