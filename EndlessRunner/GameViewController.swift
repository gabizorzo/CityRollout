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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            
            let screenSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            
            let scene = GameScene(size: screenSize)
            // Set the scale mode to scale to fit the window
            scene.scaleMode = .aspectFill
            
            scene.size = self.view.bounds.size
            
            // Present the scene
            view.presentScene(scene)
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
