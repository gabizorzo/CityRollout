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
    
    // MARK: - Variables
    private var isTouching: Bool = false
    private var touchLocation: CGFloat = 0.0
    private var lastCurrentTime: Double = -1
    
    override func didMove(to view: SKView) {
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
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
        
        let physics = SKPhysicsBody(circleOfRadius: (self.player.path?.boundingBox.width)!/2)
        physics.categoryBitMask = playerCategory
        physics.affectedByGravity = false
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
        physics.categoryBitMask = obstaclesCategory
        physics.affectedByGravity = false
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
