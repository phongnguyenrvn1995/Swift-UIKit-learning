//
//  GameScene.swift
//  Project-20
//
//  Created by Phong Nguyễn Hoàng on 28/10/2023.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    var gameTimer: Timer?
    var fireWorks = [SKNode]()
    var scoreLabel: SKLabelNode!
    let leftEdge = -22
    let bottomEdge = -22
    let rightEdge = 1024 + 22
    let topEdge = 768 + 22
    
    var launchLimit = 0
    var currentLaunch = 0
    
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    override func didMove(to view: SKView) {
        start()
    }
    
    func start() {
        removeAllChildren()
        let bg = SKSpriteNode(imageNamed: "background")
        bg.position = CGPoint(x: 512, y: 384)
        bg.zPosition = -1
        bg.blendMode = .replace
        addChild(bg)
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.position = CGPoint(x: 512, y: 0)
        scoreLabel.text = "Score: 0"
        scoreLabel.fontSize = 40
        addChild(scoreLabel)
        
        score = 0
        
        launchLimit += 1
        currentLaunch = 0
        
        gameTimer = Timer.scheduledTimer(timeInterval: 6, target: self, selector: #selector(launchFireworks), userInfo: nil, repeats: true)
    }
    
    @objc func launchFireworks() {
        if currentLaunch >= launchLimit {
            gameTimer?.invalidate()
            showGameOver()
            return
        }
        
        let movementAmount: CGFloat = 1800
        switch Int.random(in: 0...3) {
        case 0: //fire five, straight up
            createFireWork(xMoment: 0, x: 512, y: bottomEdge)
            createFireWork(xMoment: 0, x: 512 - 100, y: bottomEdge)
            createFireWork(xMoment: 0, x: 512 - 200, y: bottomEdge)
            createFireWork(xMoment: 0, x: 512 + 100, y: bottomEdge)
            createFireWork(xMoment: 0, x: 512 + 200, y: bottomEdge)
        case 1: //fire five, in a fan
            createFireWork(xMoment: 0, x: 512, y: bottomEdge)
            createFireWork(xMoment: -100, x: 512 - 100, y: bottomEdge)
            createFireWork(xMoment: -200, x: 512 - 200, y: bottomEdge)
            createFireWork(xMoment: 100, x: 512 + 100, y: bottomEdge)
            createFireWork(xMoment: 200, x: 512 + 200, y: bottomEdge)
        case 2: //fire five, from left to right
            createFireWork(xMoment: movementAmount, x: leftEdge, y: bottomEdge + 400)
            createFireWork(xMoment: movementAmount, x: leftEdge, y: bottomEdge + 300)
            createFireWork(xMoment: movementAmount, x: leftEdge, y: bottomEdge + 200)
            createFireWork(xMoment: movementAmount, x: leftEdge, y: bottomEdge + 100)
            createFireWork(xMoment: movementAmount, x: leftEdge, y: bottomEdge)
        case 3: //fire five, from right to left
            createFireWork(xMoment: -movementAmount, x: rightEdge, y: bottomEdge + 400)
            createFireWork(xMoment: -movementAmount, x: rightEdge, y: bottomEdge + 300)
            createFireWork(xMoment: -movementAmount, x: rightEdge, y: bottomEdge + 200)
            createFireWork(xMoment: -movementAmount, x: rightEdge, y: bottomEdge + 100)
            createFireWork(xMoment: -movementAmount, x: rightEdge, y: bottomEdge)
        default:
            print("default")
        }
        
        currentLaunch += 1
    }
    
    func showGameOver(){
        let gameOver = SKLabelNode(text: "GAME OVER!")
        gameOver.fontSize = 100
        gameOver.position = CGPoint(x: 512, y: 384)
        addChild(gameOver)
        
        gameOver.run(SKAction.sequence([
            SKAction.scale(to: 1.7, duration: 5),
            SKAction.run { [weak self] in
                self?.start()
            }
        ]))
    }
    
    func createFireWork(xMoment: CGFloat, x: Int, y: Int) {
        let node = SKNode()
        node.position = CGPoint(x: x, y: y)
        
        let fireWork = SKSpriteNode(imageNamed: "rocket")
        fireWork.colorBlendFactor = 1.0
        fireWork.name = "fireWork"
        node.addChild(fireWork)
        
        switch Int.random(in: 0...2) {
        case 1:
            fireWork.color = .cyan
        case 2:
            fireWork.color = .green
        default:
            fireWork.color = .red
        }
        
        let path = UIBezierPath()
        path.move(to: .zero)
        path.addLine(to: CGPoint(x: xMoment, y: 1000))
        let move = SKAction.follow(path.cgPath, asOffset: true, orientToPath: true, speed: 200)
        
        node.run(move)
        
        if let emitter = SKEmitterNode(fileNamed: "fuse") {
            emitter.position = CGPoint(x: 0, y: -22)
            node.addChild(emitter)
        }
        
        fireWorks.append(node)
        addChild(node)
    }
    
    func checkTouches(_ touches: Set<UITouch>) {
        guard let touch = touches.first else { return }
        let position = touch.location(in: self)
        let nodeAtPosition = nodes(at: position)
        
        for case let node as SKSpriteNode in nodeAtPosition {
            guard node.name == "fireWork" else { continue }
            
            for parent in fireWorks {
                guard let firework = parent.children.first as? SKSpriteNode else { continue }
                if firework.name == "selected" && firework.color != node.color {
                    firework.colorBlendFactor = 1
                    firework.name = "fireWork"
                }
            }
            
            node.name = "selected"
            node.colorBlendFactor = 0.0
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        checkTouches(touches)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        checkTouches(touches)
    }
    
    override func update(_ currentTime: TimeInterval) {
        for (index, node) in fireWorks.enumerated().reversed() {
            if node.position.y > 900 {
                fireWorks.remove(at: index)
                node.removeFromParent()
            }
        }
    }
    
    func explodeFirework(firework: SKNode) {
        if let emitter = SKEmitterNode(fileNamed: "explode") {
            emitter.position = firework.position
            addChild(emitter)
            
            emitter.run(SKAction.sequence([
                SKAction.wait(forDuration: 3),
                SKAction.run { [weak emitter] in
                    print("remove")
                    emitter?.removeFromParent()
                }
            ]))
        }
        
        firework.removeFromParent()
    }
    
    func explodeFireworks() {
        var numberOfExpload = 0
        for (index, node) in fireWorks.enumerated().reversed() {
            guard let firework = node.children.first as? SKSpriteNode else { continue }
            if firework.name == "selected" {
                numberOfExpload += 1
                fireWorks.remove(at: index)
                explodeFirework(firework: node)
            }
        }
        
        switch numberOfExpload {
        case 0:
            break
        case 1:
            score += 200
        case 2:
            score += 500
        case 3:
            score += 1500
        case 4:
            score += 2500
        case 5:
            score += 4000
        default:
            break
        }
    }
}
