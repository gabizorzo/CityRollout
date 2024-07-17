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
    private let screenHeight = UIScreen.main.bounds.height
    private let screenWidth = UIScreen.main.bounds.width
    
    // MARK: - Collision Categories
    let playerCategory: UInt32 = 1 << 5
    
    // MARK: - Variables
    var isTouching: Bool = false
    var touchLocation: CGFloat = 0.0
    
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
        guard let touch = touches.first else { return }
        
        touchLocation = touch.location(in: self).x
        isTouching = true
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        isTouching = false
    }
    
    override func update(_ currentTime: TimeInterval) {
        // MARK: Player movement
        if isTouching {
            if touchLocation > 0 {
                self.player.run(SKAction.move(by: CGVector(dx: 2, dy: 0), duration: 0.05))
            } else {
                self.player.run(SKAction.move(by: CGVector(dx: -2, dy: 0), duration: 0.05))
            }
        }
    }
}
