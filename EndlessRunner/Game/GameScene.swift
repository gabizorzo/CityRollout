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
    private var lastCurrentTimeObstacle: Double = -1
    private var lastCurrentTimeBonus: Double = -1
    private var score: Int = 0
    private var lives: Int = 3
    
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
    
    func createBonus() {
        let bonusSize = 15
        let bonus = SKShapeNode(rectOf: CGSize(width: bonusSize, height: bonusSize))
        bonus.name = "Bonus"
        bonus.strokeColor = .clear
        bonus.fillColor = .blue
        
        let x = getPosition()
        let obstaclePosition = CGPoint(x: x, y: screenHeight/2)
        bonus.position = obstaclePosition
        bonus.zPosition = 1
        bonus.zRotation = 0.785398
        
        let physics = SKPhysicsBody(rectangleOf: CGSize(width: bonusSize, height: bonusSize))
        physics.isDynamic = false
        physics.affectedByGravity = false
        physics.usesPreciseCollisionDetection = true
        physics.categoryBitMask = bonusCategory
        physics.contactTestBitMask = playerCategory
        bonus.physicsBody = physics
        
        addChild(bonus)
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
    
    func moveBonus() {
        self.enumerateChildNodes(withName: "Bonus") { node, error in
            node.position.y -= 2 // aqui que define a velocidade na qual serão movidos os bonus
            if node.position.y <= -self.screenHeight/2 + 15 { // 15 é o tamanho do bonus, ajustar depois
                node.removeFromParent()
            }
        }
    }
}

// MARK: - Physics
extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        if (contact.bodyA.categoryBitMask == playerCategory) && (contact.bodyB.categoryBitMask == obstaclesCategory) || (
            contact.bodyA.categoryBitMask == obstaclesCategory) && (contact.bodyB.categoryBitMask == playerCategory) {
            didCollide()
            
            if contact.bodyA.categoryBitMask == obstaclesCategory {
                contact.bodyA.node?.removeFromParent()
            } else if contact.bodyB.categoryBitMask == obstaclesCategory {
                contact.bodyB.node?.removeFromParent()
            }
        }
        
        if (contact.bodyA.categoryBitMask == playerCategory) && (contact.bodyB.categoryBitMask == bonusCategory) || (
            contact.bodyA.categoryBitMask == bonusCategory) && (contact.bodyB.categoryBitMask == playerCategory) {
            score += 1
            
            if contact.bodyA.categoryBitMask == bonusCategory {
                contact.bodyA.node?.removeFromParent()
            } else if contact.bodyB.categoryBitMask == bonusCategory {
                contact.bodyB.node?.removeFromParent()
            }
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
    
    func setHighScore() {
        print("\nscore: \(score)")
        print("high score: \(Database.shared.getHighScore())")
        if score > Database.shared.getHighScore() {
            Database.shared.setHighScore(score: score)
            print("new high score: \(score)")
        }
    }
    
    func didCollide() {
        print("lives: \(lives)")
        if lives == 0 {
            self.scene?.isPaused = true
            setHighScore()
        } else {
            lives -= 1
        }
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
        if lastCurrentTimeObstacle == -1 {
            lastCurrentTimeObstacle = currentTime
            lastCurrentTimeBonus = currentTime
        }
        
        let deltaTimeObstacle = currentTime - lastCurrentTimeObstacle
        let deltaTimeBonus = currentTime - lastCurrentTimeBonus
        
        // Player movement
        movePlayer()
        
        // Generate obstacles
        if deltaTimeObstacle > 2.5 { // aqui que define a velocidade na qual serão gerados novos obstáculos
            createObstacles()
            lastCurrentTimeObstacle = currentTime
        }
        
        // Generate bonus
        if deltaTimeBonus > 7 { // aqui que define a velocidade na qual serão gerados novos bonus
            createBonus()
            lastCurrentTimeBonus = currentTime
        }
        
        // Obstacles movement
        moveObstacles()
        
        // Bonus movement
        moveBonus()
    }
}
