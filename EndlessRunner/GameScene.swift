//
//  GameScene.swift
//  EndlessRunner
//
//  Created by Gabriela Zorzo on 15/07/24.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    private var circle : SKShapeNode = SKShapeNode(circleOfRadius: 10)

    override func didMove(to view: SKView) {
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        self.circle.fillColor = .red
        self.circle.strokeColor = .clear
        self.circle.position = CGPoint(x: 0, y: 0)
        
        self.addChild(circle)
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
