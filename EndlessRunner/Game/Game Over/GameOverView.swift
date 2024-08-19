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
    @IBOutlet weak var yourScoreValueLabel: UILabel!
    @IBOutlet weak var highScoreLabel: UILabel!
    @IBOutlet weak var highScoreValueLabel: UILabel!
    @IBOutlet weak var restartButton: UIButton!
        
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
        yourScoreLabel.text = String(localized: "gameOverView.yourScore")
        highScoreLabel.text = String(localized: "gameOverView.highScore")
        restartButton.setTitle(String(localized: "gameOverView.playAgain"), for: .normal)
        restartButton.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    func setupScore(score: Int) {
        yourScoreValueLabel.text = "\(score)"
        highScoreValueLabel.text = "\(Database.shared.getHighScore())"
    }
    
    //MARK: - Actions
    var restartButtonAction: () -> Void = {}
    @IBAction func restartAction(_ sender: UIButton) {
        restartButtonAction()
    }
}

