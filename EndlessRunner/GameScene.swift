//
//  GameScene.swift
//  EndlessRunner
//
//  Created by Gabriela Zorzo on 15/07/24.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    private var player = SKShapeNode(circleOfRadius: 15)
    private var screenSize = UIScreen.main.bounds
    
    override func didMove(to view: SKView) {
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        createSceneBoundingBox()
        createPlayer()
    }
    
    func createSceneBoundingBox() {
        self.view?.showsPhysics = true

        let rect = CGRect(x: 0, y: 0, width: screenSize.width/3, height: screenSize.height)
        let leftWall = SKShapeNode(rect: rect)
        leftWall.fillColor = .red

        #warning("this is vrong")
        let verticalWallPhysics = SKPhysicsBody(rectangleOf: leftWall.frame.size)
        verticalWallPhysics.node?.position = CGPoint(x: 0, y: 0)
        
        verticalWallPhysics.affectedByGravity = false
        verticalWallPhysics.collisionBitMask = 0b0001
        
        leftWall.physicsBody = verticalWallPhysics
        
        self.addChild(leftWall)
    }
    
    func createPlayer() {
        self.player.fillColor = .green
        self.player.strokeColor = .clear
        self.player.position = CGPoint(x: 0, y: -(screenSize.height/2.5))
        let physics = SKPhysicsBody(circleOfRadius: (self.player.path?.boundingBox.width)!/2)
        physics.collisionBitMask = 0b0001
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
