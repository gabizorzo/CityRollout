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
    @IBOutlet weak var livesLabel: UILabel!
    @IBOutlet weak var pauseView: PauseView!
    @IBOutlet weak var gameOverView: GameOverView!
    @IBOutlet weak var pauseButton: UIButton!
    
    var scene: GameScene!
    var session: ARSession!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        session = ARSession()
        session.delegate = self
        
        createOrientationObserver()
        rotateLabels()
        presentScene()
        restartGame()
        unpauseGame()
    }
    
    deinit {
        removeOrientationObserver()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard ARFaceTrackingConfiguration.isSupported else { return } // tratar mensagem para dispositivos que não suportam
        
        let configuration = ARFaceTrackingConfiguration()
        
        session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        session.pause()
    }
    
    // MARK: - Actions
    @IBAction func pauseAction(_ sender: Any) {
        #warning("Mexi aqui")
        gameView.isPaused = true
        pauseButton.isHidden = true
        pauseView.isHidden = false
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
    
    func unpauseGame() {
        pauseView.unpauseButtonAction = { [weak self] in
            print("Unpause Action")
            self?.gameView.isPaused = false
            self?.pauseButton.isHidden = false
            self?.pauseView.isHidden = true
        }
    }
    
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
        self.gameOverView.stackView.transform = rotation
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
            print("L: \(left)")
            
            if left > 0.09 {
                scene.movePositive()
            }
        }
        
        if let right = blendShapes[.mouthRight] as? Float {
            print("R: \(right)")
            
            if right > 0.09 {
                scene.moveNegative()
            }
        }
    }
}
