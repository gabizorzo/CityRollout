//
//  GameScene.swift
//  EndlessRunner
//
//  Created by Gabriela Zorzo on 15/07/24.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    // MARK: - Nodes
    private var player = SKShapeNode(circleOfRadius: 15)
    
    // MARK: - Sizes
    private var screenHeight = UIScreen.main.bounds.height
    private var screenWidth = UIScreen.main.bounds.width
    
    // MARK: - Collision Categories
    let playerCategory: UInt32 = 1 << 5
    
    override func didMove(to view: SKView) {
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        createSceneBoundingBox()
        createPlayer()
    }
    
    func createSceneBoundingBox() {
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
    }
    
    func createPlayer() {
        self.player.fillColor = .green
        self.player.strokeColor = .clear
        self.player.position = CGPoint(x: 0, y: -(screenHeight/2.5))
        let physics = SKPhysicsBody(circleOfRadius: (self.player.path?.boundingBox.width)!/2)
        physics.categoryBitMask = playerCategory
        physics.affectedByGravity = false
        self.player.physicsBody = physics

        self.addChild(player)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        
        let location = touch.location(in: self)
        if location.x > 0 {
            self.player.run(SKAction.move(by: CGVector(dx: 15, dy: 0), duration: 0.05))
        } else {
            self.player.run(SKAction.move(by: CGVector(dx: -15, dy: 0), duration: 0.05))
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
