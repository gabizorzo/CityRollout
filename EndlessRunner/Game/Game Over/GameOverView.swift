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
        
        gameOverTitleLabel.lineBreakMode = .byCharWrapping
        yourScoreLabel.lineBreakMode = .byCharWrapping
        highScoreLabel.lineBreakMode = .byCharWrapping
        
        restartButton.setTitle(String(localized: "gameOverView.playAgain"), for: .normal)
        restartButton.titleLabel?.lineBreakMode = .byCharWrapping
        restartButton.titleLabel?.numberOfLines = 0
        
        menuButton.setTitle(String(localized: "gameOverView.exit"), for: .normal)
        menuButton.titleLabel?.lineBreakMode = .byCharWrapping
        menuButton.titleLabel?.numberOfLines = 0
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
        let priority: Float = currentOrientation == .portrait ? 1000 : 250
        if currentOrientation == .portrait {
            self.trailConstraint.priority = UILayoutPriority(priority)
            self.leadConstraint.priority = UILayoutPriority(priority)
            
            self.gameOverTitleLabel.numberOfLines = 0
            self.yourScoreLabel.numberOfLines = 0
            self.highScoreLabel.numberOfLines = 0
            self.restartButton.titleLabel?.numberOfLines = 0
        } else if currentOrientation == .landscapeRight || currentOrientation == .landscapeLeft {
            self.trailConstraint.priority = UILayoutPriority(priority)
            self.leadConstraint.priority = UILayoutPriority(priority)
            
            self.gameOverTitleLabel.numberOfLines = 1
            self.yourScoreLabel.numberOfLines = 1
            self.highScoreLabel.numberOfLines = 1
            self.restartButton.titleLabel?.numberOfLines = 1
        }
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
