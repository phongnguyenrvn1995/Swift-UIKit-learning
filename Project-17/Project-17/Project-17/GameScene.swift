//
//  GameScene.swift
//  Project-17
//
//  Created by Phong Nguyễn Hoàng on 26/09/2023.
//

import SpriteKit
import UIKit


class GameScene: SKScene, SKPhysicsContactDelegate {
    var starField: SKEmitterNode!
    var player: SKSpriteNode!
    var scoreLabel: SKLabelNode!
    var retryLabel: SKLabelNode!
    
    var possibleEnemies = ["ball", "hammer", "tv"]
    var gameTimer: Timer!
    var gameOver = false
    var isPlayerTouched = false
    var createEnemyInterval = 1.0
    var enemySession = 0
    
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    override func didMove(to view: SKView) {
        backgroundColor = .black
        starField = SKEmitterNode(fileNamed: "starfield")
        starField.position = CGPoint(x: 1024, y: 384)
        starField.advanceSimulationTime(10)
        starField.zPosition = -1
        addChild(starField)
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.position = CGPoint(x: 16, y: 16)
        scoreLabel.horizontalAlignmentMode = .left
        addChild(scoreLabel)
        
        restartGame()
    }
    
    func restartGame() {
        gameOver = false
        children.forEach { item in
            if item == starField || item == scoreLabel { return }
            item.removeFromParent()
        }
        
        player = SKSpriteNode(imageNamed: "player")
        player.position = CGPoint(x: 100, y: 384)
        player.physicsBody = SKPhysicsBody(texture: player.texture!, size: player.size)
        player.physicsBody?.contactTestBitMask = 1
        addChild(player)
        
        score = 0
        createEnemyInterval = 1.0
        enemySession = 0
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsWorld.contactDelegate = self
        triggerTimer()
    }
    
    func triggerTimer() {
        print(createEnemyInterval)
        if(gameTimer != nil) {
            gameTimer.invalidate()
        }
        gameTimer = Timer.scheduledTimer(timeInterval: createEnemyInterval, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)
    }
    
    @objc func createEnemy() {
        if gameOver {
            gameTimer.invalidate()
        }
        guard let enemy = possibleEnemies.randomElement() else { return }
        
        let sprite = SKSpriteNode(imageNamed: enemy)
        
        sprite.position = CGPoint(x: 1200, y: Int.random(in: 50...736))
        addChild(sprite)
        
        sprite.physicsBody = SKPhysicsBody(texture: sprite.texture!, size: sprite.size)
        sprite.physicsBody?.categoryBitMask = 1
        sprite.physicsBody?.velocity = CGVector(dx: -500, dy: 0)
        sprite.physicsBody?.linearDamping = 0
        
        sprite.physicsBody?.angularVelocity = 5
        sprite.physicsBody?.angularDamping = 0
        enemySession += 1
        print(enemySession)
        if enemySession >= 20 {
            if createEnemyInterval >= 0.2 {
                createEnemyInterval -= 0.1
            }
            enemySession = 0
            triggerTimer()
        }
    }

    override func update(_ currentTime: TimeInterval) {
        for item in children {
            if item.position.x < -300 {
                item.removeFromParent()
            }
        }
        
        if !gameOver {
            score += 1
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !isPlayerTouched { return }
        guard let touch = touches.first else { return }
        
        var location = touch.location(in: self)
        
        if location.y < 100 {
            location.y = 100
        } else if location.y > 668 {
            location.y = 668
        }
        
        player.position = location
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard let explosion = SKEmitterNode(fileNamed: "explosion") else { return }
        explosion.position = player.position
        player.removeFromParent()
        addChild(explosion)
        gameOver = true
        showGameOver()
    }
    
    func showGameOver() {
        let gameOverLabel = SKSpriteNode(imageNamed: "gameOver")
        gameOverLabel.position = CGPoint(x: 512, y: 384)
        addChild(gameOverLabel)
        
        retryLabel = SKLabelNode(fontNamed: "Chalkduster")
        retryLabel.text = "RETRY"
        retryLabel.horizontalAlignmentMode = .center
        retryLabel.position = CGPoint(x: 512, y: 250)
        addChild(retryLabel)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        isPlayerTouched = false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touche = touches.first else { return }
        let point = touche.location(in: self)
        let listNodes = nodes(at: point)
        if listNodes.contains(player) {
            isPlayerTouched = true
        }
        
        if retryLabel != nil && listNodes.contains(retryLabel!) {
            restartGame()
        }
    }
}
