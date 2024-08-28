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
    @IBOutlet weak var congratulationsLabel: UILabel!
    @IBOutlet weak var yourScoreLabel: UILabel!
    @IBOutlet weak var newHighScore: UILabel!
    @IBOutlet weak var highScoreLabel: UILabel!
    @IBOutlet weak var restartButton: UIButton!
    
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
        
        gameOverTitleLabel.text = String(localized: "gameOverView.gameOver")
        gameOverTitleLabel.lineBreakMode = .byCharWrapping
        gameOverTitleLabel.numberOfLines = 0
        gameOverTitleLabel.isHidden = true
        
        congratulationsLabel.text = String(localized: "gameOverView.congratulations")
        congratulationsLabel.lineBreakMode = .byCharWrapping
        congratulationsLabel.numberOfLines = 0
        congratulationsLabel.isHidden = true
        
        yourScoreLabel.text = String(localized: "gameOverView.yourScore")
        yourScoreLabel.lineBreakMode = .byCharWrapping
        yourScoreLabel.numberOfLines = 0
        yourScoreLabel.isHidden = true
        
        highScoreLabel.text = String(localized: "gameOverView.highScore") + "\(Database.shared.getHighScore())"
        highScoreLabel.lineBreakMode = .byCharWrapping
        highScoreLabel.numberOfLines = 0
        highScoreLabel.isHidden = true
        
        newHighScore.text = String(localized: "gameOverView.newHighScore") + "\(Database.shared.getHighScore())"
        newHighScore.lineBreakMode = .byCharWrapping
        newHighScore.numberOfLines = 0
        newHighScore.isHidden = true
        
        restartButton.setTitle(String(localized: "gameOverView.playAgain"), for: .normal)
        restartButton.titleLabel?.lineBreakMode = .byCharWrapping
        restartButton.titleLabel?.numberOfLines = 0
        restartButton.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    func setupScore(score: Int, isNewHighScore: Bool) {
        
        if true {
//            newHighScore.text = String(localized: "gameOverView.newHighScore") + "\(score)"
            
            gameOverTitleLabel.isHidden = true
            yourScoreLabel.isHidden = true
            highScoreLabel.isHidden = true
            congratulationsLabel.isHidden = false
            newHighScore.isHidden = false
            
        } else {
            yourScoreLabel.text = String(localized: "gameOverView.yourScore") + "\(score)"
            
            gameOverTitleLabel.isHidden = false
            yourScoreLabel.isHidden = false
            highScoreLabel.isHidden = false
            congratulationsLabel.isHidden = true
            newHighScore.isHidden = true
        }
    }
    
    func setStackConstraintPriority(priority: Float) {
        self.trailConstraint.priority = UILayoutPriority(priority)
        self.leadConstraint.priority = UILayoutPriority(priority)
    }
    
    //MARK: - Actions
    var restartButtonAction: () -> Void = {}
    @IBAction func restartAction(_ sender: UIButton) {
        restartButtonAction()
    }
}
