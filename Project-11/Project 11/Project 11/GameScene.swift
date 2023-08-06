//
//  GameScene.swift
//  Project 11
//
//  Created by Phong Nguyễn Hoàng on 29/07/2023.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    var numberOfBallLabel: SKLabelNode!
    var numberOfBall = 5 {
        didSet {
            numberOfBallLabel.text = "Ball: \(numberOfBall)"
        }
    }
    var spawnBar: SKSpriteNode! = nil
    let ballList = ["ballBlue", "ballCyan", "ballGreen", "ballGrey", "ballPurple", "ballRed", "ballYellow"]
    let sceneWidth = 1024
    let sceneHeight = 768
    var scoreLabel: SKLabelNode!
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var editLable: SKLabelNode!
    var editingMode = false {
        didSet {
            if editingMode {
                editLable.text = "Done"
            } else {
                editLable.text = "Edit"
            }
        }
    }
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: sceneWidth/2, y: sceneHeight/2)
        background.blendMode = .replace
        background.zPosition = -2
        addChild(background)
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score: 0"
        scoreLabel.horizontalAlignmentMode = .right
        scoreLabel.position = CGPoint(x: sceneWidth - 44, y: sceneHeight - 35)
        addChild(scoreLabel)
        
        numberOfBallLabel = SKLabelNode(fontNamed: "Chalkduster")
        numberOfBallLabel.horizontalAlignmentMode = .center
        numberOfBallLabel.position = CGPoint(x: sceneWidth / 2, y: sceneHeight - 35)
        addChild(numberOfBallLabel)
        
        editLable = SKLabelNode(fontNamed: "Chalkduster")
        editLable.text = "Edit"
        editLable.position = CGPoint(x: 80, y: sceneHeight - 35)
        addChild(editLable)

        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        physicsWorld.contactDelegate = self
        
        if let rain = SKEmitterNode(fileNamed: "RainParticle") {
            rain.position = CGPoint(x: 0, y: 1000)
            addChild(rain)
        }
        
        makeSlot(at: CGPoint(x: sceneWidth * 1 / 8, y: 0), isGood: true)
        makeSlot(at: CGPoint(x: sceneWidth * 3 / 8, y: 0), isGood: false)
        makeSlot(at: CGPoint(x: sceneWidth * 5 / 8, y: 0), isGood: true)
        makeSlot(at: CGPoint(x: sceneWidth * 7 / 8, y: 0), isGood: false)
        
        makeBouncer(at: CGPoint(x: sceneWidth * 0 / 4, y: 0))
        makeBouncer(at: CGPoint(x: sceneWidth * 1 / 4, y: 0))
        makeBouncer(at: CGPoint(x: sceneWidth * 2 / 4, y: 0))
        makeBouncer(at: CGPoint(x: sceneWidth * 3 / 4, y: 0))
        makeBouncer(at: CGPoint(x: sceneWidth * 4 / 4, y: 0))
        
        spawnBar = SKSpriteNode(color: UIColor(white: 1, alpha: 0.1), size: CGSize(width: sceneWidth, height: 115))
        spawnBar.alpha = 0.1
        spawnBar.position = CGPoint(x: sceneWidth / 2, y: sceneHeight - (185 / 2))
        addChild(spawnBar)
        
        numberOfBall = 5
    }
    
    func makeBouncer(at position: CGPoint) {
        let bouncer = SKSpriteNode(imageNamed: "bouncer")
        bouncer.position = position
        bouncer.physicsBody = SKPhysicsBody(circleOfRadius: CGFloat(bouncer.size.width/2))
        bouncer.physicsBody?.isDynamic = false
        addChild(bouncer)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let myTouch = touches.first else { return }
        let position = myTouch.location(in: self)
        let object = nodes(at: position)
        if object.contains(editLable) {
            editingMode.toggle()
            return
        }
        
        if(editingMode) {
            // create a box
            let size = CGSize(width: Int.random(in: 70...150), height: 16)
            let box = SKSpriteNode(color: UIColor(red: CGFloat.random(in: 0...1), green: CGFloat.random(in: 0...1), blue: CGFloat.random(in: 0...1), alpha: 1), size: size)
            box.name = "box"
            box.position = position
            box.zRotation = CGFloat.random(in: -CGFloat.pi / 4...CGFloat.pi / 4)
            box.physicsBody = SKPhysicsBody(rectangleOf: box.size)
            box.physicsBody?.isDynamic = false
            addChild(box)
            return
        }
        // create ball
        if(!object.contains(spawnBar)) {
            if spawnBar.action(forKey: "action") != nil {
                return
            }
            spawnBar.alpha = CGFloat(1)
            spawnBar.run(SKAction.fadeAlpha(to: 0.1, duration: TimeInterval(1)), withKey: "action")
            return
        }
        
        let ball = SKSpriteNode(imageNamed: ballList[Int.random(in: 0 ..< ballList.count)])
        ball.physicsBody = SKPhysicsBody(circleOfRadius: CGFloat(ball.size.width/2))
        ball.physicsBody?.contactTestBitMask = ball.physicsBody?.collisionBitMask ?? 0
        ball.physicsBody?.restitution = 0.4
        ball.position = position
        ball.name = "ball"
        numberOfBall -= 1
        addChild(ball)
    }
    
    func makeSlot(at position: CGPoint, isGood: Bool) {
        let baseSlot: SKSpriteNode!
        let baseGlow: SKSpriteNode!
        if isGood {
            baseSlot = SKSpriteNode(imageNamed: "slotBaseGood")
            baseGlow = SKSpriteNode(imageNamed: "slotGlowGood")
            baseSlot.name = "good"
        } else {
            baseSlot = SKSpriteNode(imageNamed: "slotBaseBad")
            baseGlow = SKSpriteNode(imageNamed: "slotGlowBad")
            baseSlot.name = "bad"
        }
        baseSlot.position = position
        baseGlow.position = position
        baseGlow.zPosition = -1
        
        baseSlot.physicsBody = SKPhysicsBody(rectangleOf: baseSlot.size)
        baseSlot.physicsBody?.isDynamic = false
        
        addChild(baseSlot)
        addChild(baseGlow)
        
        let spin = SKAction.rotate(byAngle: .pi, duration: 10)
        let spinForever = SKAction.repeatForever(spin)
        baseGlow.run(spinForever)
    }
    
    func collision(between ball: SKNode, object: SKNode) {
        if object.name == "good" {
            destroy(ball: ball)
            score += 1
            numberOfBall += 1
        } else if object.name == "bad" {
            destroy(ball: ball)
            score -= 1
        }
    }
    
    func destroy(ball: SKNode) {
        if let fire = SKEmitterNode(fileNamed: "MyParticle") {
            fire.position = ball.position
            addChild(fire)
        }
        ball.removeFromParent()
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        if nodeA.name == "ball" {
            collision(between: nodeA, object: nodeB)
        } else if nodeB.name == "ball" {
            collision(between: nodeB, object: nodeA)
        }
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        if nodeA.name == "box" {
            destroy(box: nodeA)
        }
        
        if nodeB.name == "box" {
            destroy(box: nodeB)
        }
    }
    
    func destroy(box: SKNode) {
        box.run(SKAction.colorize(with: UIColor.red, colorBlendFactor: 1.0, duration: TimeInterval(2.0)))
        box.run(SKAction.scale(to: 1.5, duration: TimeInterval(2.0)))
        _ = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { [weak self] _ in
            box.removeFromParent()
            
            if let fire = SKEmitterNode(fileNamed: "FireParticles") {
                fire.position = box.position
                self?.addChild(fire)
            }
        }
    }
}
