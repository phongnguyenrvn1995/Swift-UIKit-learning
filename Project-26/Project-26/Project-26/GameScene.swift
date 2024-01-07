//
//  GameScene.swift
//  Project-26
//
//  Created by Phong Nguyễn Hoàng on 26/12/2023.
//
import CoreMotion
import SpriteKit

enum ConlissionType: UInt32 {
    case player =   0b00000001
    case wall =     0b00000010
    case star =     0b00000100
    case vortex =   0b00001000
    case finish =   0b00010000
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var player: SKSpriteNode!
    let itemSizeWidth = Int(GameConst.UNIT_SIZE_GENERAL)
    let itemSizeHeight = Int(GameConst.UNIT_SIZE_GENERAL)
    var lastTouchPosition: CGPoint? = nil
    var motionMng: CMMotionManager?
    var scoreLabel: SKLabelNode!
    var isGameOver = false
    var outPoint: CGPoint?
    var currentLevel = 1
    
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    override func didMove(to view: SKView) {
        startLevel("level\(currentLevel)")
        physicsWorld.gravity = .zero
        motionMng = CMMotionManager()
        motionMng?.startAccelerometerUpdates()
        physicsWorld.contactDelegate = self
    }
    
    func startLevel(_ name: String) {
        removeAllChildren()
        loadBackground()
        loadLevel(name)
        loadPlayer()
        loadScore()
    }
    
    func loadScore() {
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score: \(score)"
        scoreLabel.position = CGPoint(x: 16, y: 16)
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.zPosition = 2
        addChild(scoreLabel)
    }
    
    func loadBackground() {
        let bg = SKSpriteNode(imageNamed: "background")
        bg.size = CGSize(width: GameViewController.SCREEN_WIDTH, height: GameViewController.SCREEN_HEIGHT)
        bg.position = CGPoint(x: GameViewController.SCREEN_WIDTH / 2, y: GameViewController.SCREEN_HEIGHT / 2)
        bg.zPosition = -1
        bg.blendMode = .replace
        addChild(bg)
    }
    
    func loadPlayer(position: CGPoint? = nil) {
        player = SKSpriteNode(imageNamed: "player")
        player.physicsBody?.isDynamic = true
        player.zPosition = 1
        if(position == nil) {
            player.position = CGPoint(x: itemSizeWidth * 3 / 2, y: itemSizeWidth * 10)
        } else {
            player.position = position!
        }
        player.size = CGSize(width: itemSizeWidth - 10, height: itemSizeWidth - 10)
        player.physicsBody = SKPhysicsBody(circleOfRadius: player.size.width / 2)
        player.physicsBody?.allowsRotation = false
        player.physicsBody?.linearDamping = 5
        player.physicsBody?.categoryBitMask = ConlissionType.player.rawValue
        player.physicsBody?.contactTestBitMask = ConlissionType.star.rawValue | ConlissionType.vortex.rawValue | ConlissionType.finish.rawValue
        
        player.physicsBody?.collisionBitMask = ConlissionType.wall.rawValue
        
        addChild(player)
    }
    
    func loadLevel(_ mapName: String) {
        guard let level = Bundle.main.url(forResource: mapName, withExtension: "txt") else {
            fatalError("Cannot find the level1.txt")
        }
        guard let levelString = try? String(contentsOf: level) else {
            fatalError("Cannot load the level1.txt")
        }
        let lines = levelString.components(separatedBy: "\n").filter { item in
            !item.isEmpty
        }
        let itemSize = CGSize(width: itemSizeWidth, height: itemSizeHeight)
        
        for (row, line) in lines.reversed().enumerated() {
            for (column, letter) in line.enumerated() {
                var node: SKSpriteNode? = nil
                let position = CGPoint(
                    x: (itemSizeWidth * column) + itemSizeWidth / 2,
                    y: (itemSizeHeight * row) + itemSizeHeight / 2)
                
                if letter == "x" {
                    // wall
                    node = (makeWallBlock(itemSize: itemSize, itemPosition: position))
                } else if letter == "v" {
                    // vortex
                    node = (makeVotex(itemSize: itemSize, itemPosition: position))
                } else if letter == "s" {
                    // star
                    node = (makeStar(itemSize: itemSize, itemPosition: position))
                } else if letter == "f" {
                    // finish point
                    node = (makeFinishPoint(itemSize: itemSize, itemPosition: position))
                } else if letter == "i" {
                    node = makeTeleVotex(itemSize: itemSize, itemPosition: position, isIn: true)
                } else if letter == "o" {
                    node = makeTeleVotex(itemSize: itemSize, itemPosition: position, isIn: false)
                } else if letter == " " {
                    //do nothing
                } else {
                    fatalError("Unknown level letter \(letter)")
                }
                if(node != nil) {
                    addChild(node!)
                }
            }
        }
    }
    
    func makeFinishPoint(itemSize: CGSize, itemPosition: CGPoint) -> SKSpriteNode {
        let node = SKSpriteNode(imageNamed: "finish")
        node.position = itemPosition
        node.size = itemSize
        node.name = "finish"
        node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
        node.physicsBody?.isDynamic = false
        node.physicsBody?.categoryBitMask = ConlissionType.finish.rawValue
        node.physicsBody?.contactTestBitMask = ConlissionType.player.rawValue
        node.physicsBody?.collisionBitMask = 0
        return node
    }
    
    func makeStar(itemSize: CGSize, itemPosition: CGPoint) -> SKSpriteNode {
        let node = SKSpriteNode(imageNamed: "star")
        node.position = itemPosition
        node.size = itemSize
        node.name = "star"
        node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
        node.physicsBody?.isDynamic = false
        node.physicsBody?.categoryBitMask = ConlissionType.star.rawValue
        node.physicsBody?.contactTestBitMask = ConlissionType.player.rawValue
        node.physicsBody?.collisionBitMask = 0
        return node
    }
    
    func makeWallBlock(itemSize: CGSize, itemPosition: CGPoint) -> SKSpriteNode {
        let node = SKSpriteNode(imageNamed: "block")
        node.position = itemPosition
        node.size = itemSize
        node.physicsBody = SKPhysicsBody(rectangleOf: node.size)
        node.physicsBody?.categoryBitMask = ConlissionType.wall.rawValue
        node.physicsBody?.isDynamic = false
        return node
    }
    
    func makeVotex(itemSize: CGSize, itemPosition: CGPoint) -> SKSpriteNode {
        let node = SKSpriteNode(imageNamed: "vortex")
        node.name = "vortex"
        node.position = itemPosition
        node.size = itemSize
        
        node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
        node.physicsBody?.isDynamic = false
        node.physicsBody?.categoryBitMask = ConlissionType.vortex.rawValue
        
        node.run(SKAction.repeatForever(SKAction.rotate(byAngle: .pi, duration: 1)))
        node.physicsBody?.contactTestBitMask = ConlissionType.player.rawValue
        node.physicsBody?.collisionBitMask = 0
        return node
    }
    
    func makeTeleVotex(itemSize: CGSize, itemPosition: CGPoint, isIn: Bool) -> SKSpriteNode {
        let node = SKSpriteNode(imageNamed: "vortex")
        node.colorBlendFactor = 0.7
        if(isIn) { 
            node.color = .blue
            node.name = "tele_in_vortex"
        } else {
            node.color = .green
            node.name = "tele_out_vortex"
            outPoint = itemPosition
        }
        node.position = itemPosition
        node.size = itemSize
        
        node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
        node.physicsBody?.isDynamic = false
        node.physicsBody?.categoryBitMask = ConlissionType.vortex.rawValue
        
        node.run(SKAction.repeatForever(SKAction.rotate(byAngle: .pi, duration: 1)))
        node.physicsBody?.contactTestBitMask = ConlissionType.player.rawValue
        node.physicsBody?.collisionBitMask = 0
        return node
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let pos = touch.location(in: self)
        lastTouchPosition = pos
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let pos = touch.location(in: self)
        lastTouchPosition = pos
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        lastTouchPosition = nil
    }
    
    override func update(_ currentTime: TimeInterval) {
        guard isGameOver == false else { return }
        
        #if targetEnvironment(simulator)
        if let lastTouchPosition = lastTouchPosition {
            let diff = CGPoint(x: lastTouchPosition.x - player.position.x, y: lastTouchPosition.y - player.position.y)
            physicsWorld.gravity = CGVector(dx: diff.x / 100, dy: diff.y / 100)
        }
        #else
        if let accelerometerData = motionMng?.accelerometerData {
//            print(accelerometerData)
            physicsWorld.gravity = CGVector(dx: accelerometerData.acceleration.y * -50, dy: accelerometerData.acceleration.x * 50)
        }
        #endif
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        
        if nodeA == player {
            didCollision(node: nodeB)
        } else if nodeB == player {
            didCollision(node: nodeA)
        }
    }
    
    func didCollision(node: SKNode) {
        if node.name == "vortex" || node.name == "tele_in_vortex" {
            isGameOver = true
            player.physicsBody?.isDynamic = false
            score -= 1
            
            let move = SKAction.move(to: node.position, duration: 0.25)
            let scale = SKAction.scale(to: 0, duration: 0.25)
            let remove = SKAction.removeFromParent()
            
            player.run(SKAction.sequence([move, scale, remove])) { [weak self, weak node] in
                if node?.name == "tele_in_vortex" {
                    self?.loadPlayer(position: self?.outPoint)
                } else {
                    self?.loadPlayer()
                }
                self?.isGameOver = false
            }
        } else if node.name == "star" {
            node.removeFromParent()
            score += 1
        } else if node.name == "finish" {
            currentLevel += 1
            if currentLevel > 3 { currentLevel = 1 }
            startLevel("level\(currentLevel)")
        }
    }
}
