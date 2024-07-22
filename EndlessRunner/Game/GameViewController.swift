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
//        if let faceAnchor = anchors.first as? ARFaceAnchor {
//            update(withFaceAnchor: faceAnchor)
//        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        if let faceAnchor = anchor as? ARFaceAnchor,
           let faceGeo = node.geometry as? ARSCNFaceGeometry {
                
            if faceAnchor.lookAtPoint.y <= 0 {
                print("A head is...")
            }
                
            if node.orientation.x >= Float.pi/32 {
                print("A head is...")
            }
        }
    }
    
    func update(withFaceAnchor faceAnchor: ARFaceAnchor) {

//        var blendShapes: [ARFaceAnchor.BlendShapeLocation:Any] = faceAnchor.blendShapes
//        
//        if let lookLeft = blendShapes[.eyeLookOutLeft] as? Float {
//            print(lookLeft)
//            
//            if lookLeft > 0 {
//                scene.moveNegative()
//            }
//        }
//        
//        if let lookRight = blendShapes[.eyeLookOutRight] as? Float {
//            print(lookRight)
//            
//            if lookRight > 0 {
//                scene.movePositive()
//            }
//        }
        
    }
}
