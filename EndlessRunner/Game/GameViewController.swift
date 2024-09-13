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
    #warning("check if possible to remove livesstack outlet")
    @IBOutlet weak var gameView: SKView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var livesStackView: UIStackView!
    @IBOutlet weak var heart1: UIImageView!
    @IBOutlet weak var heart2: UIImageView!
    @IBOutlet weak var heart3: UIImageView!
    @IBOutlet weak var pauseView: PauseView!
    @IBOutlet weak var gameOverView: GameOverView!
    @IBOutlet weak var pauseButton: UIButton!
    
    var scene: GameScene!
    var session: ARSession!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Database.shared.getSettingsStatus(for: .faceMovements) {
            session = ARSession()
            session.delegate = self
        }
        
        setHudLabels()
        createOrientationObserver()
        rotateLabels()
        presentScene()
        restartGame()
        unpauseGame()
        backToMenu()
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
        gameView.isPaused = true
        pauseButton.isHidden = true
        pauseView.isHidden = false
        Haptics.shared.buttonHaptic()
        Sounds.shared.buttonSound()
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
    
    func setHudLabels() {
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
    
    func backToMenu() {
        pauseView.menuButtonAction = { [weak self] in
            self?.scene.setHighScore()
            self?.navigationController?.popViewController(animated: false)
            Haptics.shared.buttonHaptic()
            Sounds.shared.buttonSound()
        }
#warning("como melhorar essa duplicacao de codigo??")
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
            self?.gameView.isPaused = false
            Haptics.shared.buttonHaptic()
            Sounds.shared.buttonSound()
        }
    }
    
    func updateScore(score: Int) {
        scoreLabel.text = " \(score) "
    }
    
    func updateLives(lives: Int) {
        switch lives {
        case 2:
            self.heart3.image = UIImage(named: "hurtHeart")
            break
        case 1:
            self.heart2.image = UIImage(named: "hurtHeart")
            break
        case 0:
            self.heart1.image = UIImage(named: "hurtHeart")
            break
        case 3:
            self.heart1.image = UIImage(named: "heart")
            self.heart2.image = UIImage(named: "heart")
            self.heart3.image = UIImage(named: "heart")
            break
        default:
            break
        }
    }
    
    func gameOver(score: Int, isNewHighScore: Bool) {
        gameOverView.setupScore(score: score, isNewHighScore: isNewHighScore)
        gameOverView.isHidden = false
    }
    
    func restartGame() {
        gameOverView.restartButtonAction = { [weak self] in
            self?.updateLives(lives: 3)
            self?.updateScore(score: 0)
            self?.gameOverView.isHidden = true
            self?.presentScene()
            Haptics.shared.startGameHaptic()
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
            } else if currentOrientation == .portrait{
                rotation = CGAffineTransform(rotationAngle: 0)
            }
            
            self.scoreLabel.transform = rotation
            for heart in self.livesStackView.arrangedSubviews {
                heart.transform = rotation
            }
            self.pauseButton.transform = rotation
            self.gameOverView.stackView.transform = rotation
            self.gameOverView.setStackBehavior(currentOrientation)
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
