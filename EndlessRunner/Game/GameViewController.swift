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
    @IBOutlet weak var gameOverView: GameOverView!
    @IBOutlet weak var pauseButton: UIButton!
    
    var scene: GameScene!
    var session: ARSession!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        session = ARSession()
        session.delegate = self
        
        presentScene()
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
        gameView.isPaused = !gameView.isPaused
        
        if gameView.isPaused {
            pauseButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        } else {
            pauseButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        }
    }
    
    
    // MARK: - Configs
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .portrait
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
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
        scoreLabel.text = "\(score)"
    }
    
    func updateLives(lives: Int) {
        livesLabel.text = "Lives: \(lives)"
    }
    
    func gameOver(score: Int) {
        gameOverView.setupScore(score: score)
        gameOverView.isHidden = false
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
            
            if left > 0.1 {
                scene.movePositive()
            }
        }
        
        if let right = blendShapes[.mouthRight] as? Float {
            print("R: \(right)")
            
            if right > 0.1 {
                scene.moveNegative()
            }
        }
    }
}
