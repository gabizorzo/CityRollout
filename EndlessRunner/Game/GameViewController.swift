//
//  GameViewController.swift
//  EndlessRunner
//
//  Created by Gabriela Zorzo on 15/07/24.
//

import UIKit
import SpriteKit
import GameplayKit
import ARKit

class GameViewController: UIViewController {
    @IBOutlet weak var gameView: SKView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var livesStackView: UIStackView!
    @IBOutlet weak var pauseView: PauseView!
    @IBOutlet weak var gameOverView: GameOverView!
    @IBOutlet weak var tutorialView: TutorialView!
    @IBOutlet weak var pauseButton: UIButton!
    
    var scene: GameScene!
    var session: ARSession!
    
    var isTutorialEnabled: Bool = !Database.shared.getFirstTutorial()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Database.shared.getSettingsStatus(for: .faceMovements) {
            session = ARSession()
            session.delegate = self
        }
        
        tutorialView.isHidden = true
        
        setHudLabels()
        createOrientationObserver()
        rotateLabels()
        presentScene()
        restartGame()
        unpauseGame()
        backToMenu()
        movePlayerTutorial()
        stopMovePlayerTutorial()
        closeTutorial()
        howToPlay()
        pauseGame()
        
        if isTutorialEnabled {
            pauseButton.isHidden = true
            tutorialView.isHidden = false
            scene.tutorialPlayerPaused = true
            scene.isTutorial = true
        }
        
        UIAccessibility.post(notification: .screenChanged, argument: scoreLabel)
    }
    
    deinit {
        removeOrientationObserver()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        if Database.shared.getSettingsStatus(for: .faceMovements) {
            guard ARFaceTrackingConfiguration.isSupported else { return } // tratar mensagem para dispositivos que não suportam
            
            let configuration = ARFaceTrackingConfiguration()
            
            session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if Database.shared.getSettingsStatus(for: .faceMovements) {
            session.pause()
        }
    }
    
    // MARK: - Actions
    @IBAction func pauseAction(_ sender: Any) {
        scene.tutorialPlayerPaused = true
        scene.tutorialObstaclesPaused = true
        pauseButton.isHidden = true
        pauseView.isHidden = false
        Haptics.shared.buttonHaptic()
        Sounds.shared.buttonSound()
        
        UIAccessibility.post(notification: .screenChanged, argument: pauseView.unpauseButton)
    }

    // MARK: - Configs
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var preferredScreenEdgesDeferringSystemGestures: UIRectEdge { 
        return .all
    }
    
    func createOrientationObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(GameViewController.rotateLabels), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    func removeOrientationObserver() {
        NotificationCenter.default.removeObserver(self, name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    func setHudLabels() {
        if UIApplication.shared.preferredContentSizeCategory.isAccessibilityCategory {
            self.livesStackView.spacing = -4
        } else {
            self.livesStackView.spacing = 8
        }
        
        scoreLabel.layer.cornerRadius = 8
        scoreLabel.layer.masksToBounds = true
    }
}

// MARK: - Game scene
extension GameViewController {
    func presentScene() {
        let screenSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        scene = GameScene(size: screenSize)
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
        scoreLabel.text = " \(score) "
    }
    
    func updateLives(lives: Int) {
        if lives == 3 {
            for i in 0..<lives {
                self.livesStackView.arrangedSubviews[i].isHidden = false
            }
        } else {
            self.livesStackView.arrangedSubviews[lives].isHidden = true
        }
        
        for i in 0..<3 {
            self.livesStackView.arrangedSubviews[i].accessibilityLabel = lives == 1 ? "\(lives) \(String(localized: "gameScene.life"))" : "\(lives) \(String(localized: "gameScene.lives"))"
        }
    }
    
    func gameOver(score: Int, isNewHighScore: Bool) {
        gameOverView.setupScore(score: score, isNewHighScore: isNewHighScore)
        gameOverView.isHidden = false
        
        UIAccessibility.post(notification: .screenChanged, argument: gameOverView.gameOverTitleLabel)
    }
    
    func restartGame() {
        gameOverView.restartButtonAction = { [weak self] in
            self?.updateLives(lives: 3)
            self?.updateScore(score: 0)
            self?.gameOverView.isHidden = true
            self?.presentScene()
            Haptics.shared.startGameHaptic()
            
            UIAccessibility.post(notification: .layoutChanged, argument: self?.scoreLabel)
        }
    }
    
    @objc func rotateLabels() {
        let currentOrientation = UIDevice.current.orientation
        if currentOrientation != .faceUp && currentOrientation != .faceDown {
            var rotation = CGAffineTransform()
            
            if currentOrientation == .landscapeLeft {
                rotation = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
            } else if currentOrientation == .landscapeRight {
                rotation = CGAffineTransform(rotationAngle: -(CGFloat.pi / 2))
            } else if currentOrientation == .portrait || currentOrientation == .portraitUpsideDown {
                rotation = CGAffineTransform(rotationAngle: 0)
            }
            
            self.scoreLabel.transform = rotation
            for heart in self.livesStackView.arrangedSubviews {
                heart.transform = rotation
            }
            self.pauseButton.transform = rotation
            self.gameOverView.stackView.transform = rotation
            self.gameOverView.setStackBehavior(currentOrientation)
        
            self.pauseView.stackView.transform = rotation
            self.pauseView.setStackBehavior(currentOrientation)
        
            self.tutorialView.stackView.transform = rotation
        }
    }
}

// MARK: - Face Movement
extension GameViewController: ARSessionDelegate {
    func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
        if let faceAnchor = anchors.first as? ARFaceAnchor {
            update(withFaceAnchor: faceAnchor)
        }
    }
    
    func update(withFaceAnchor faceAnchor: ARFaceAnchor) {
        let blendShapes: [ARFaceAnchor.BlendShapeLocation:Any] = faceAnchor.blendShapes
        
        if let left = blendShapes[.mouthLeft] as? Float {
//            print("L: \(left)")
            
            if left > 0.09 {
                scene.movePositive()
            }
        }
        
        if let right = blendShapes[.mouthRight] as? Float {
//            print("R: \(right)")
            
            if right > 0.09 {
                scene.moveNegative()
            }
        }
    }
}

// MARK: - Pause

extension GameViewController {
    func backToMenu() {
        pauseView.menuButtonAction = { [weak self] in
            self?.scene.setHighScore()
            self?.navigationController?.popViewController(animated: false)
            Haptics.shared.buttonHaptic()
            Sounds.shared.buttonSound()
        }

        gameOverView.menuButtonAction = { [weak self] in
            self?.navigationController?.popViewController(animated: false)
            Haptics.shared.buttonHaptic()
            Sounds.shared.buttonSound()
        }
    }
    
    func unpauseGame() {
        pauseView.unpauseButtonAction = { [weak self] in
            self?.pauseButton.isHidden = false
            self?.pauseView.isHidden = true
            self?.scene.tutorialPlayerPaused = false
            self?.scene.tutorialObstaclesPaused = false
            Haptics.shared.buttonHaptic()
            Sounds.shared.buttonSound()
            
            UIAccessibility.post(notification: .layoutChanged, argument: self?.scoreLabel)
        }
    }
    
    func howToPlay() {
        pauseView.howToPlayButtonAction = { [weak self] in
            self?.pauseView.isHidden = true
            self?.pauseButton.isHidden = true
            self?.tutorialView.reset()
            self?.tutorialView.isHidden = false
            self?.scene.tutorialObstaclesPaused = false
            self?.scene.tutorialPlayerPaused = true
            self?.scene.isTutorial = true
        }
    }
}

// MARK: - Tutorial
extension GameViewController {
    func movePlayerTutorial() {
        tutorialView.isUserInteractionEnabled = true
        tutorialView.continueButton.isUserInteractionEnabled = true
        tutorialView.movePlayer = { [weak self] location in
            self?.scene.touchLocation = location
            self?.scene.isTouching = true
        }
    }
    
    func stopMovePlayerTutorial() {
        tutorialView.stopPlayer = { [weak self] in
            self?.scene.isTouching = false
        }
    }
    
    func closeTutorial() {
        tutorialView.closeTutorial = { [weak self] in
            self?.tutorialView.isHidden = true
            self?.pauseButton.isHidden = false
            self?.scene.isTutorial = false
            self?.scene.tutorialPlayerPaused = false
            self?.scene.tutorialObstaclesPaused = false
        }
    }
    
    func pauseGame() {
        tutorialView.pauseGame = { [weak self] playerPaused, obstaclesPaused  in
            if playerPaused && obstaclesPaused {
                self?.scene.tutorialPlayerPaused = true
                self?.scene.tutorialObstaclesPaused = true
            } else if playerPaused {
                self?.scene.tutorialPlayerPaused = true
                self?.scene.tutorialObstaclesPaused = false
            } else if obstaclesPaused {
                self?.scene.tutorialPlayerPaused = false
                self?.scene.tutorialObstaclesPaused = true
            } else {
                self?.scene.tutorialPlayerPaused = false
                self?.scene.tutorialObstaclesPaused = false
            }
        }
    }
}
