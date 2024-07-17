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
    let obstaclesCategory: UInt32 = 1 << 4
    let bonusCategory: UInt32 = 1 << 3
    
    // MARK: - Variables
    private var isTouching: Bool = false
    private var touchLocation: CGFloat = 0.0
    private var lastCurrentTime: Double = -1
    
    override func didMove(to view: SKView) {
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        physicsWorld.contactDelegate = self
        
        createSceneBoundingBox()
        createPlayer()
    }
    
    // MARK: - Create nodes
    func createSceneBoundingBox() {
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
    }
    
    func createPlayer() {
        self.player.name = "Player"
        self.player.fillColor = .green
        self.player.strokeColor = .clear
        self.player.position = CGPoint(x: 0, y: -(screenHeight/2.5))
        self.player.zPosition = 1
        
        let physics = SKPhysicsBody(circleOfRadius: 15)
        physics.isDynamic = true
        physics.affectedByGravity = false
        physics.usesPreciseCollisionDetection = true
        physics.categoryBitMask = playerCategory
        physics.collisionBitMask = obstaclesCategory
        physics.contactTestBitMask = obstaclesCategory | bonusCategory
        self.player.physicsBody = physics

        self.addChild(player)
    }
    
    func createObstacles() {
        let obstacleSize = 15
        let obstacle = SKShapeNode(rectOf: CGSize(width: obstacleSize, height: obstacleSize))
        obstacle.name = "Obstacle"
        obstacle.strokeColor = .clear
        obstacle.fillColor = .red
        
        let x = getPosition()
        let obstaclePosition = CGPoint(x: x, y: screenHeight/2)
        obstacle.position = obstaclePosition
        obstacle.zPosition = 1
        
        let physics = SKPhysicsBody(rectangleOf: CGSize(width: obstacleSize, height: obstacleSize))
        physics.isDynamic = false
        physics.affectedByGravity = false
        physics.usesPreciseCollisionDetection = true
        physics.categoryBitMask = obstaclesCategory
        physics.contactTestBitMask = playerCategory
        obstacle.physicsBody = physics
        
        addChild(obstacle)
    }
}

// MARK: - Moves
extension GameScene {
    func movePlayer() {
        if isTouching {
            if touchLocation > 0 {
                self.player.run(SKAction.move(by: CGVector(dx: 2, dy: 0), duration: 0.05))
            } else {
                self.player.run(SKAction.move(by: CGVector(dx: -2, dy: 0), duration: 0.05))
            }
        }
    }
    
    func moveObstacles() {
        self.enumerateChildNodes(withName: "Obstacle") { node, error in
            node.position.y -= 2 // aqui que define a velocidade na qual serão movidos os obstáculos
            if node.position.y <= -self.screenHeight/2 + 15 { // 15 é o tamanho do obstáculo, ajustar depois
                node.removeFromParent()
            }
        }
    }
}

// MARK: - Physics
extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        print(contact.bodyA.categoryBitMask)
        if (contact.bodyA.categoryBitMask == playerCategory) && (contact.bodyB.categoryBitMask == obstaclesCategory) || (
            contact.bodyA.categoryBitMask == obstaclesCategory) && (contact.bodyB.categoryBitMask == playerCategory) {
            self.scene?.isPaused = true
        }
    }
}

// MARK: - Help funcs
extension GameScene {
    func getPosition() -> CGFloat {
        let min = -screenWidth/2 + 15 // 15 é o tamanho do obstáculo, ajustar depois
        let max = screenWidth/2 - 15 // 15 é o tamanho do obstáculo, ajustar depois
        let value = Int.random(in: Int(min)..<Int(max))
        return CGFloat(value)
    }
}

// MARK: - Touches
extension GameScene {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        touchLocation = touch.location(in: self).x
        isTouching = true
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard touches.first != nil else { return }
        
        isTouching = false
    }
}

// MARK: - Update
extension GameScene {
    override func update(_ currentTime: TimeInterval) {
        // MARK: Player movement
        movePlayer()
        
        // MARK: Generate obstacles
        if lastCurrentTime == -1 {
            lastCurrentTime = currentTime
        }
        
        let deltaTime = currentTime - lastCurrentTime
        
        if deltaTime > 2.5 { // aqui que define a velocidade na qual serão gerados novos obstáculos
            createObstacles()
            lastCurrentTime = currentTime
        }
        
        // MARK: Obstacles movement
        moveObstacles()
    }
}
