//
//  GameViewController.swift
//  EndlessRunner
//
//  Created by Gabriela Zorzo on 15/07/24.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    @IBOutlet weak var gameView: SKView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var livesLabel: UILabel!
    @IBOutlet weak var gameOverView: GameOverView!
    @IBOutlet weak var pauseButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createOrientationObserver()
        presentScene()
        restartGame()
    }
    
    deinit {
        removeOrientationObserver()
    }
    
    // MARK: - Actions
    @IBAction func pauseAction(_ sender: Any) {
        gameView.isPaused = !gameView.isPaused
        
        if gameView.isPaused {
            pauseButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        } else {
            pauseButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        }
    }

    // MARK: - Configs
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func createOrientationObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(GameViewController.rotateLabels), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    func removeOrientationObserver() {
        NotificationCenter.default.removeObserver(self, name: UIDevice.orientationDidChangeNotification, object: nil)
    }
}

// MARK: - Game scene
extension GameViewController {
    func presentScene() {
        let screenSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        let scene = GameScene(size: screenSize)
        scene.gameDelegate = self
        
        scene.scaleMode = .aspectFill
        scene.size = self.view.bounds.size
        
        // Present the scene
        gameView.presentScene(scene)
        gameView.ignoresSiblingOrder = true
    }
}

// MARK: - Game Delegate
extension GameViewController: GameDelegate {
    func updateScore(score: Int) {
        scoreLabel.text = "\(score)"
    }
    
    func updateLives(lives: Int) {
        livesLabel.text = "Lives: \(lives)"
    }
    
    func gameOver(score: Int) {
        gameOverView.setupScore(score: score)
        gameOverView.isHidden = false
    }
    
    func restartGame() {
        gameOverView.restartButtonAction = { [weak self] in
            self?.updateLives(lives: 3)
            self?.updateScore(score: 0)
            self?.gameOverView.isHidden = true
            self?.presentScene()
        }
    }
    
    @objc func rotateLabels() {
        let currentOrientation = UIDevice.current.orientation
        var rotation = CGAffineTransform()
        
        if currentOrientation == .landscapeLeft {
            rotation = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
        } else if currentOrientation == .landscapeRight {
            rotation = CGAffineTransform(rotationAngle: -(CGFloat.pi / 2))
        } else {
            rotation = CGAffineTransform(rotationAngle: 0)
        }
        
        self.scoreLabel.transform = rotation
        self.livesLabel.transform = rotation
        self.pauseButton.transform = rotation
    }
}
