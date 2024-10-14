//
//  GameScene.swift
//  EndlessRunner
//
//  Created by Gabriela Zorzo on 15/07/24.
//

import SpriteKit
import GameplayKit

protocol GameDelegate: AnyObject {
    func updateScore(score: Int)
    func updateLives(lives: Int)
    func gameOver(score: Int, isNewHighScore: Bool)
    func unpauseGame()
}

class GameScene: SKScene {
    // MARK: - Delegate
    weak var gameDelegate: GameDelegate?
    
    // MARK: - Nodes
    private var player = SKSpriteNode()
    
    // MARK: - Sizes
    private let screenHeight = UIScreen.main.bounds.height
    private let screenWidth = UIScreen.main.bounds.width
    
    // MARK: - Collision Categories
    let playerCategory: UInt32 = 1 << 5
    let obstaclesCategory: UInt32 = 1 << 4
    
    // MARK: - Variables
    public var isTouching: Bool = false
    public var touchLocation: CGFloat = 0.0
    private var lastCurrentTimeObstacle: Double = -1
    private var lastCurrentTimeScore: Double = -1
    private var score: Int = 0
    private var lives: Int = 3
    private var gamePaused: Bool = false
    private var difficulty: SettingsDifficulty = .medium
    private var collisionTimer = Timer()
    
    public var tutorialPlayerPaused: Bool = false
    public var tutorialObstaclesPaused: Bool = false
    public var isTutorial: Bool = false
    
    override func didMove(to view: SKView) {
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        physicsWorld.contactDelegate = self

        difficulty = Database.shared.getSettingsDifficulty()
        
        createSceneBoundingBox()
        createBackground()
        createPlayer()
        
        Haptics.shared.startGameHaptic()
        Sounds.shared.startGameSound()
    }
    
    // MARK: - Create nodes
    func createSceneBoundingBox() {
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
    }
    
    func createBackground() {
        for i in 0...1 {
            let texture = SKTexture(imageNamed: "background") 
            let node = SKSpriteNode(texture: texture, size: CGSize(width: screenWidth, height: screenHeight))
            node.name = "Background"
            if i > 0 {
                node.position.y += screenHeight
            }
            self.addChild(node)
        }
    }
    
    func createPlayer() {
        self.player.name = "Player"
        let texture = SKTexture(imageNamed: "player")
        self.player = SKSpriteNode(texture: texture)
        self.player.position = CGPoint(x: 0, y: -(screenHeight/2.5))
        self.player.zPosition = 1
        self.player.constraints = [SKConstraint.zRotation(SKRange(constantValue: 0)),
                                   SKConstraint.positionY(SKRange(constantValue: self.player.position.y))]
        
        let physics = SKPhysicsBody(texture: texture, size: player.size)
        physics.isDynamic = true
        physics.affectedByGravity = false
        physics.usesPreciseCollisionDetection = true
        physics.categoryBitMask = playerCategory
        physics.collisionBitMask = obstaclesCategory
        physics.contactTestBitMask = obstaclesCategory
        self.player.physicsBody = physics
        self.player.yScale = -1 // to make player point up
        self.addChild(player)
    }
    
    func createObstacles() {
        var obstacle = SKSpriteNode()
        
        switch Int.random(in: 0..<3) {
        case 0:
            obstacle = SKSpriteNode(imageNamed: "tree")
            break
        case 1:
            obstacle = SKSpriteNode(imageNamed: "rock")
            break
        case 2:
            obstacle = SKSpriteNode(imageNamed: "cone")
            break
        default:
            break
        }
        
        let scalingFactor = 0.8 // ajuste do tamanho do obstáculo
        obstacle.run(SKAction.scaleX(by: scalingFactor, y: scalingFactor, duration: 0))
        obstacle.name = "Obstacle"
        let x = getPosition(obstacleWidth: obstacle.frame.width)
        let obstaclePosition = CGPoint(x: x, y: screenHeight/2 + obstacle.frame.height)
        obstacle.position = obstaclePosition
        obstacle.zPosition = 1
        
        let physics = SKPhysicsBody(texture: obstacle.texture!, size: obstacle.size)
        physics.isDynamic = false
        physics.affectedByGravity = false
        physics.usesPreciseCollisionDetection = true
        physics.categoryBitMask = obstaclesCategory
        physics.contactTestBitMask = playerCategory
        obstacle.physicsBody = physics
        
        if Bool.random() { obstacle.run(SKAction.scaleX(to: -scalingFactor, duration: 0)) }
        addChild(obstacle)
    }
}

// MARK: - Moves
extension GameScene {
    func movePlayerTouch() {
        if isTouching {
            if touchLocation > 0 {
               movePositive()
            } else {
                moveNegative()
            }
        }
    }
    
    func movePositive() {
        if !tutorialPlayerPaused {
            let distance = 2.5
            if !((self.player.position.x + distance) > (self.screenWidth / 2.95)) {
                self.player.run(SKAction.move(by: CGVector(dx: distance, dy: 0), duration: 0.05))
            }
        }
    }
    
    func moveNegative() {
        if !tutorialPlayerPaused {
            let distance = 2.5
            if !((self.player.position.x - distance) < (-self.screenWidth / 2.95)) {
                self.player.run(SKAction.move(by: CGVector(dx: -distance, dy: 0), duration: 0.05))
            }
        }
    }
    
    func moveBackground() {
        self.enumerateChildNodes(withName: "Background") { node, error in
            node.position.y -= 1
            if node.position.y <= -(self.screenHeight) {
                node.position.y = self.screenHeight
            }
        }
    }
    
    func moveObstacles() {
        self.enumerateChildNodes(withName: "Obstacle") { node, error in
            node.position.y -= self.getSpeedMovement() // aqui que define a velocidade na qual serão movidos os obstáculos
            if node.position.y <= -self.screenHeight/2 - node.frame.height {
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
            collisionTimer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false, block: {_ in})
            
            if contact.bodyA.categoryBitMask == obstaclesCategory {
                contact.bodyA.node?.removeFromParent()
            } else if contact.bodyB.categoryBitMask == obstaclesCategory {
                contact.bodyB.node?.removeFromParent()
            }
        }
    }
}

// MARK: - Help funcs
extension GameScene {
    func getSpeedMovement() -> CGFloat {
        switch difficulty {
        case .easy:
            return 1.75
        case .medium:
            return 2.5
        case .hard:
            return 3
        }
    }
    
    func getPosition(obstacleWidth: Double) -> CGFloat {
        let min = -screenWidth/2 + obstacleWidth
        let max = screenWidth/2 - obstacleWidth
        let value = Int.random(in: Int(min)..<Int(max))
        return CGFloat(value)
    }
    
    func setHighScore() {
        var isNewHighScore = false
        print("\nscore: \(score)")
        print("high score: \(Database.shared.getHighScore())")
        if score > Database.shared.getHighScore() {
            Database.shared.setHighScore(score: score)
            isNewHighScore = true
            print("new high score: \(score)")
        }
        self.gameDelegate?.gameOver(score: score, isNewHighScore: isNewHighScore)
    }
    
    func didCollide() {
        if !collisionTimer.isValid {
            lives -= 1
            print("lives: \(lives)")
            if isTutorial && lives == 0 {
                lives = 1
            }
            self.gameDelegate?.updateLives(lives: lives)
            if lives == 0 {
                gamePaused = true
                setHighScore()
                
                Haptics.shared.gameOverHaptic()
                Sounds.shared.gameOverSound()
            } else {
                Haptics.shared.obstacleHaptic()
                Sounds.shared.obstacleSound()
            }
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
        self.isPaused = gamePaused // gambiarra pra cena não voltar rodando
        
        if !tutorialPlayerPaused {
            // Player movement
            movePlayerTouch()
        }
        
        if lastCurrentTimeObstacle == -1 {
            lastCurrentTimeObstacle = currentTime
            lastCurrentTimeScore = currentTime
        }
        
        if !tutorialObstaclesPaused {
            
            let deltaTimeObstacle = currentTime - lastCurrentTimeObstacle
            let deltaTimeScore = currentTime - lastCurrentTimeScore
        
            var timeObstacle = Double.random(in: 1.5 ..< 4.5)
            
            switch difficulty {
            case .easy:
                timeObstacle = Double.random(in: 4 ..< 4.5)
            case .medium:
                timeObstacle = Double.random(in: 2.0 ..< 3.0)
            case .hard:
                timeObstacle = Double.random(in: 1.0 ..< 2.0)
            }
            
            // Update score
            if deltaTimeScore > 2 {
                score += 1
                self.gameDelegate?.updateScore(score: score)
                lastCurrentTimeScore = currentTime
            }
            
            // Generate obstacles
            if deltaTimeObstacle > timeObstacle { // aqui que define a velocidade na qual serão gerados novos obstáculos
                createObstacles()
                lastCurrentTimeObstacle = currentTime
            }
        
            // Background movement
            moveBackground()
            
            // Obstacles movement
            moveObstacles()
        }
    }
}
