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
    @IBOutlet weak var gameOverLabel: UILabel!
    @IBOutlet weak var yourScoreLabel: UILabel!
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
        
        gameOverLabel.text = String(localized: "gameOverView.gameOver")
        gameOverLabel.lineBreakMode = .byCharWrapping
        gameOverLabel.numberOfLines = 0
        
        yourScoreLabel.text = String(localized: "gameOverView.yourScore")
        yourScoreLabel.lineBreakMode = .byCharWrapping
        yourScoreLabel.numberOfLines = 0
        
        highScoreLabel.text = String(localized: "gameOverView.highScore")
        highScoreLabel.lineBreakMode = .byCharWrapping
        highScoreLabel.numberOfLines = 0
        
        restartButton.setTitle(String(localized: "gameOverView.playAgain"), for: .normal)
        restartButton.titleLabel?.lineBreakMode = .byCharWrapping
        restartButton.titleLabel?.numberOfLines = 0
        restartButton.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    func setupScore(score: Int) {
        yourScoreLabel.text = String(localized: "gameOverView.yourScore") + " \(score)"
        highScoreLabel.text = String(localized: "gameOverView.highScore") + " \(Database.shared.getHighScore())"
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

