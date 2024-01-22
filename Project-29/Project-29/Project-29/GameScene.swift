//
//  GameScene.swift
//  Project-29
//
//  Created by Phong Nguyễn Hoàng on 21/01/2024.
//

import SpriteKit

enum CollisionTypes: UInt32 {
    case banana = 1
    case building = 2
    case player = 4
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    weak var gameViewController: GameViewController?
    var buildings = [BuildingNode]()
    var player1: SKSpriteNode!
    var player2: SKSpriteNode!
    var banana: SKSpriteNode!
    var currentPlayer = 1
    var p1Score = 0 {
        didSet {
            gameViewController?.p1ScoreLable.text = "Score: \(p1Score)"
        }
    }
    
    var p2Score = 0 {
        didSet {
            gameViewController?.p2ScoreLable.text = "Score: \(p2Score)"
        }
    }
    
    var wind = 0.0 {
        didSet {
            print("HERE")
            if wind < 0 {
                print("HERE 1")
                gameViewController?.windLable.text = "<<< WIND [~\(-Int(wind))]"
            } else if wind > 0 {
                print("HERE 2")
                gameViewController?.windLable.text = "WIND [~\(Int(wind))] >>>"
            } else {
                print("HERE 3")
                gameViewController?.windLable.text = "NO WIND"
            }
        }
    }
    
    override func didMove(to view: SKView) {
        backgroundColor = UIColor(hue: 0.669, saturation: 0.99, brightness: 0.33, alpha: 1)
        createBuildings()
        createPlayer()
        gameViewController?.p1ScoreLable.text = "Score: \(p1Score)"
        gameViewController?.p2ScoreLable.text = "Score: \(p2Score)"
        physicsWorld.contactDelegate = self
        windy()
    }
    
    func windy() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15, execute: DispatchWorkItem(block: { [weak self] in
            guard let self = self else { return }
            physicsWorld.gravity = CGVector(dx: CGFloat.random(in: -9...9), dy: physicsWorld.gravity.dy)
            wind = physicsWorld.gravity.dx
            print(physicsWorld.gravity)
        }))
    }
    
    func createBuildings() {
        var currentX: CGFloat = -15
        while currentX < CGFloat(SizeConsts.WIDTH) {
            let size = CGSize(width: Int.random(in: 1...3) * 40, height: Int.random(in: SizeConsts.HEIGHT / 10 ... SizeConsts.HEIGHT * 3 / 10))
            currentX += size.width + 2
            let building = BuildingNode(color: .white, size: size)
            building.position = CGPoint(x: currentX - (size.width / 2), y: size.height / 2)
            addChild(building)
            buildings.append(building)
            building.setup()
        }
    }
    
    func launch(angle: Int, velocity: Int) {
        let speed = Double(velocity) / 10
        let radian = deg2rad(degree: angle)
        
        if banana != nil {
            banana.removeFromParent()
            banana = nil
        }
        
        banana = SKSpriteNode(imageNamed: "banana")
        banana.name = "banana"
        banana.physicsBody = SKPhysicsBody(circleOfRadius: banana.size.width / 2)
        banana.physicsBody?.categoryBitMask = CollisionTypes.banana.rawValue
        banana.physicsBody?.collisionBitMask = CollisionTypes.building.rawValue | CollisionTypes.player.rawValue
        banana.physicsBody?.contactTestBitMask = CollisionTypes.building.rawValue | CollisionTypes.player.rawValue
        banana.physicsBody?.usesPreciseCollisionDetection = true
        addChild(banana)
        
        if currentPlayer == 1 {
            banana.position = CGPoint(x: player1.position.x - player1.size.width / 3, y: player1.position.y +  player1.size.height)
            banana.size = SizeConsts.BANANA_SIZE
            banana.physicsBody?.angularVelocity = -20
            
            let raiseArm = SKAction.setTexture(SKTexture(imageNamed: "player1Throw"))
            let lowerArm = SKAction.setTexture(SKTexture(imageNamed: "player"))
            let pause = SKAction.wait(forDuration: 0.15)
            player1.run(SKAction.sequence([raiseArm, lowerArm, pause]))
            
            let impulse = CGVector(dx: cos(radian) * speed, dy: sin(radian) * speed)
            banana.physicsBody?.applyImpulse(impulse)
        } else {
            banana.position = CGPoint(x: player2.position.x + player2.size.width / 3, y: player2.position.y +  player2.size.height)
            banana.size = SizeConsts.BANANA_SIZE
            banana.physicsBody?.angularVelocity = -20
            
            let raiseArm = SKAction.setTexture(SKTexture(imageNamed: "player2Throw"))
            let lowerArm = SKAction.setTexture(SKTexture(imageNamed: "player"))
            let pause = SKAction.wait(forDuration: 0.15)
            player2.run(SKAction.sequence([raiseArm, lowerArm, pause]))
            
            let impulse = CGVector(dx: cos(radian) * -speed, dy: sin(radian) * speed)
            banana.physicsBody?.applyImpulse(impulse)
        }
    }
    
    func createPlayer() {
        player1 = SKSpriteNode(imageNamed: "player")
        player1.size = SizeConsts.PLAYER_SIZE
        player1.name = "player1"
        
        player1.physicsBody = SKPhysicsBody(circleOfRadius: player1.size.width / 2)
        player1.physicsBody?.categoryBitMask = CollisionTypes.player.rawValue
        player1.physicsBody?.contactTestBitMask = CollisionTypes.banana.rawValue
        player1.physicsBody?.collisionBitMask = CollisionTypes.banana.rawValue
        player1.physicsBody?.isDynamic = false
        
        let player1Building = buildings[1]
        player1.position = CGPoint(x: player1Building.position.x, y: player1Building.size.height + player1.size.height / 2)
        addChild(player1)
        
        player2 = SKSpriteNode(imageNamed: "player")
        player2.size = SizeConsts.PLAYER_SIZE
        player2.name = "player2"
        
        player2.physicsBody = SKPhysicsBody(circleOfRadius: player2.size.width / 2)
        player2.physicsBody?.categoryBitMask = CollisionTypes.player.rawValue
        player2.physicsBody?.contactTestBitMask = CollisionTypes.banana.rawValue
        player2.physicsBody?.collisionBitMask = CollisionTypes.banana.rawValue
        player2.physicsBody?.isDynamic = false
        
        let player2Building = buildings[buildings.count - 2]
        player2.position = CGPoint(x: player2Building.position.x, y: player2Building.size.height + player2.size.height / 2)
        addChild(player2)
    }
    
    func deg2rad(degree: Int) -> Double {
        Double(degree) * .pi / 180
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let firstBody: SKPhysicsBody
        let secondBody: SKPhysicsBody
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA 
        }
        guard let firstNode = firstBody.node else { return }
        guard let secondNode = secondBody.node else { return }
        
        if firstNode.name == "banana" && secondNode.name == "building" {
            print("hit building")
            bananaHit(building: secondNode, atPoint: contact.contactPoint)
        }
        
        if firstNode.name == "banana" && secondNode.name == "player1" {
            print("hit player 1")
            destroy(player: player1)
            p2Score += 1
        }
        
        if firstNode.name == "banana" && secondNode.name == "player2" {
            print("hit player 2")
            destroy(player: player2)
            p1Score += 1
        }
    }
    
    func destroy(player: SKSpriteNode) {
        if let emitter = SKEmitterNode(fileNamed: "hitPlayer") {
            emitter.position = player.position
            addChild(emitter)
        }
        
        player.removeFromParent()
        banana.removeFromParent()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            if self.p1Score >= 3 {
                self.gameViewController?.gameOver(winnerPlayer: 1)
            } else if self.p2Score >= 3 {
                self.gameViewController?.gameOver(winnerPlayer: 2)
            } else {
                let newGame = GameScene(size: self.size)
                newGame.gameViewController = self.gameViewController
                self.gameViewController?.currentGame = newGame
                
                self.changePlayer()
                newGame.currentPlayer = self.currentPlayer
                newGame.p1Score = self.p1Score
                newGame.p2Score = self.p2Score
                
                let transition = SKTransition.doorway(withDuration: 1.5)
                self.view?.presentScene(newGame, transition: transition)
            }
        }
    }
    
    func changePlayer() {
        if currentPlayer == 1 {
            currentPlayer = 2
        } else {
            currentPlayer = 1
        }
        windy()
        gameViewController?.activePlayer(number: currentPlayer)
    }
    
    func bananaHit(building: SKNode, atPoint contactPoint: CGPoint) {
        guard let building = building as? BuildingNode else { return }
        let buildingLocation = convert(contactPoint, to: building)
        print(buildingLocation)
        building.hit(at: buildingLocation)
        
        if let emitter = SKEmitterNode(fileNamed: "hitBuilding") {
            emitter.position = contactPoint
            addChild(emitter)
        }
        
        banana.name = ""
        banana.removeFromParent()
        banana = nil
        
        changePlayer()
    }
    
    override func update(_ currentTime: TimeInterval) {
        guard banana != nil else { return }
        
        if abs(banana.position.y) > 1000 {
            banana.removeFromParent()
            banana = nil
            changePlayer()
        }
    }
}
