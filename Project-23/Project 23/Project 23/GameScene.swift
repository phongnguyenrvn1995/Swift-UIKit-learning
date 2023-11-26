//
//  GameScene.swift
//  Project 23
//
//  Created by Phong Nguyễn Hoàng on 19/11/2023.
//
import AVFoundation
import SpriteKit

enum ForceBoom {
    case always, never, radom
}

enum SequenceType: CaseIterable {
    case oneNoBoom, one, twoWithOneBoom, two, three, four, chain, fastChain
}

class GameScene: SKScene {
    
    var scoreLabel: SKLabelNode!
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var livesImages = [SKSpriteNode]()
    var lives = 3
    
    var activeSliceBG: SKShapeNode!
    var activeSliceFG: SKShapeNode!
    var activeSlicePoints = [CGPoint]()
    var isSwooshSoundActive = false
    
    var activeEnemies = [SKSpriteNode]()
    var boomSoundEffect: AVAudioPlayer?
    
    var popupTime = 1.0
    var sequences = [SequenceType]()
    var sequencePos = 0
    var chainDelay = 3.0
    var isHasNextSequence = true
    var isGameOver = false
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "sliceBackground")
        background.size = CGSize(width: GameConstants.SCREEN_WIDTH, height: GameConstants.SCREEN_HEIGHT)
        background.position = CGPoint(x: GameConstants.SCREEN_WIDTH/2, y: GameConstants.SCREEN_HEIGHT/2)
        background.zPosition = -1
        background.blendMode = .replace
        addChild(background)
        
        physicsWorld.gravity = CGVector(dx: 0, dy: -6)
        physicsWorld.speed = 0.85
        
        createScore()
        createLives()
        createSlices()
        
        sequences = [.oneNoBoom, .oneNoBoom, .twoWithOneBoom, .twoWithOneBoom, .three, .one, .chain]
        
        for _ in 0...1000 {
            if let sequence = SequenceType.allCases.randomElement() {
                sequences.append(sequence)
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.tossEnemy()
        }
    }
    
    func createScore() {
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.fontSize = GameConstants.SCREEN_WIDTH / 20
        scoreLabel.position = CGPoint(x: 8, y: 8)
        addChild(scoreLabel)
        
        score = 0
    }
    
    func createLives() {
        let size: CGFloat = 50
        for i in 0 ..< 3 {
            let nodeLive = SKSpriteNode(imageNamed: "sliceLife")
            let x = (GameConstants.SCREEN_WIDTH) - size * 3 + CGFloat(i) * size
            let y = GameConstants.SCREEN_HEIGHT - size
            nodeLive.position = CGPoint(x: x, y: y)
            nodeLive.size = CGSize(width: size, height: size)
            nodeLive.anchorPoint = CGPoint(x: 0.0, y: 0.0)
            addChild(nodeLive)
            livesImages.append(nodeLive)
        }
    }
    
    func createSlices() {
        activeSliceBG = SKShapeNode()
        activeSliceBG.zPosition = 2
        
        activeSliceFG = SKShapeNode()
        activeSliceFG.zPosition = 3
        
        activeSliceBG.strokeColor = UIColor(red: 1, green: 0.9, blue: 0, alpha: 1)
        activeSliceBG.lineWidth = 9
        
        activeSliceFG.strokeColor = UIColor.white
        activeSliceFG.lineWidth = 5
        
        addChild(activeSliceBG)
        addChild(activeSliceFG)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard isGameOver == false else { return }
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        activeSlicePoints.append(location)
        redrawActiveSlice()
        if !isSwooshSoundActive {
            playSwooshSound()
        }
        
        let nodes = nodes(at: location)
        for case let node as SKSpriteNode in nodes {
            if node.name == "enemy" || node.name == "bonus" {
                if let emitter = SKEmitterNode(fileNamed: "sliceHitEnemy.sks") {
                    emitter.position = node.position
                    addChild(emitter)
                }
                
                let scoreIncrease = node.name == "bonus" ? 3 : 1
                
                node.name = ""
                node.physicsBody?.isDynamic = false
                let scaleOut = SKAction.scale(to: 0.001, duration: 0.2)
                let fadeOut = SKAction.fadeOut(withDuration: 0.2)
                let group = SKAction.group([scaleOut, fadeOut])
                let seqs = SKAction.sequence([group, SKAction.removeFromParent()])
                node.run(seqs)
                
                score += scoreIncrease
                if let index = activeEnemies.firstIndex(of: node) {
                    activeEnemies.remove(at: index)
                }
                
                run(SKAction.playSoundFileNamed("whack.caf", waitForCompletion: false))
            } else if node.name == "boom" {
                guard let boomContainer = node.parent as? SKSpriteNode else { continue }
                if let emitter = SKEmitterNode(fileNamed: "sliceHitBomb.sks") {
                    emitter.position = boomContainer.position
                    addChild(emitter)
                }
                
                node.name = ""
                boomContainer.physicsBody?.isDynamic = false
                
                let scale = SKAction.scale(to: 0.001, duration: 0.2)
                let fade = SKAction.fadeOut(withDuration: 0.02)
                let group = SKAction.group([scale, fade])
                boomContainer.run(SKAction.sequence([group, .removeFromParent()]))
                
                if let index = activeEnemies.firstIndex(of: boomContainer) {
                    activeEnemies.remove(at: index)
                }
                
                run(SKAction.playSoundFileNamed("explosion.caf", waitForCompletion: false))
                endGame(triggerByBoom: true)
            }
        }
    }
    
    func endGame(triggerByBoom: Bool) {
        guard isGameOver == false else { return }
        isGameOver = true
        
//        physicsWorld.speed = 0
        isUserInteractionEnabled = false
        
        boomSoundEffect?.stop()
        boomSoundEffect = nil
        
        if triggerByBoom {
            livesImages[0].texture = SKTexture(imageNamed: "sliceLifeGone")
            livesImages[1].texture = SKTexture(imageNamed: "sliceLifeGone")
            livesImages[2].texture = SKTexture(imageNamed: "sliceLifeGone")
        }
        
        let gameOverNode = SKLabelNode(text: "GAME OVER")
        gameOverNode.fontSize = 80
        gameOverNode.position = CGPoint(x: GameConstants.SCREEN_WIDTH / 2, y: GameConstants.SCREEN_HEIGHT / 2)
        gameOverNode.zPosition = 10
        gameOverNode.xScale = 1.3
        gameOverNode.yScale = 1.3
        addChild(gameOverNode)
        gameOverNode.run(SKAction.scale(to: 1, duration: 0.2))
    }
    
    func playSwooshSound() {
        isSwooshSoundActive = true
        
        let ran = Int.random(in: 1...3)
        let swooshSoundName = "swoosh\(ran).caf"
        let swooshAction = SKAction.playSoundFileNamed(swooshSoundName, waitForCompletion: true)
        
        run(swooshAction) { [weak self] in
            self?.isSwooshSoundActive = false
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        activeSliceBG.run(SKAction.fadeOut(withDuration: 0.25))
        activeSliceFG.run(SKAction.fadeOut(withDuration: 0.25))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        activeSlicePoints.removeAll(keepingCapacity: true)
        
        let location = touch.location(in: self)
        activeSlicePoints.append(location)
        
        activeSliceBG.removeAllActions()
        activeSliceFG.removeAllActions()
        
        activeSliceBG.alpha = 1
        activeSliceFG.alpha = 1
        redrawActiveSlice()
    }
    
    func redrawActiveSlice() {
        if activeSlicePoints.count < 2 {
            activeSliceBG.path = nil
            activeSliceFG.path = nil
            return
        }
        
        if activeSlicePoints.count > 12 {
            activeSlicePoints.removeFirst(activeSlicePoints.count - 12)
        }
        
        let path = UIBezierPath()
        path.move(to: activeSlicePoints[0])
        
        for i in 1 ..< activeSlicePoints.count {
            path.addLine(to: activeSlicePoints[i])
        }
        
        activeSliceBG.path = path.cgPath
        activeSliceFG.path = path.cgPath
    }
    
    func createEnemy(forceBoom: ForceBoom = .radom) {
        let enemy: SKSpriteNode
        let enemySize = GameConstants.ENEMY_SIZE
        var enemyType = Int.random(in: 0...6)
        if forceBoom == .always {
            enemyType = 0
        } else if forceBoom == .never {
            enemyType = Int.random(in: 1...6)
        }
        if enemyType == 0 {
            //boom
            enemy = SKSpriteNode()
            enemy.size = enemySize
            enemy.zPosition = 1
            enemy.name = "boomContainer"
            
            let boomImage = SKSpriteNode(imageNamed: "sliceBomb")
            boomImage.size = enemySize
            boomImage.name = "boom"
            enemy.addChild(boomImage)
            
            if boomSoundEffect != nil {
                boomSoundEffect?.stop()
                boomSoundEffect = nil
            }
            
            if let path = Bundle.main.url(forResource: "sliceBombFuse", withExtension: "caf") {
                if let sound = try? AVAudioPlayer(contentsOf: path) {
                    boomSoundEffect = sound
                    boomSoundEffect?.play()
                }
            }
            
            if let fuseEmitter = SKEmitterNode(fileNamed: "sliceFuse") {
                fuseEmitter.position = CGPoint(x: enemySize.width / 2 * 0.8, y: enemySize.height / 2 * 0.8)
                enemy.addChild(fuseEmitter)
            }
        } else if enemyType == 1 {
            enemy = SKSpriteNode(imageNamed: "penguin")
            enemy.size = enemySize
            enemy.name = "bonus"
            enemy.colorBlendFactor = 1
            enemy.color = UIColor.red
            run(SKAction.playSoundFileNamed("launch.caf", waitForCompletion: false))
        } else {
            enemy = SKSpriteNode(imageNamed: "penguin")
            enemy.size = enemySize
            enemy.name = "enemy"
            run(SKAction.playSoundFileNamed("launch.caf", waitForCompletion: false))
        }
        
        let randomPosition = CGPoint(x: Int.random(in: GameConstants.ENEMY_MIN_RAND_POS...GameConstants.ENEMY_MAX_RAND_POS), y: -128)
        enemy.position = randomPosition
        
        let randomAngularVelocity = CGFloat.random(in: GameConstants.ENEMY_MIN_ANGULAR_X_VELOCITY...GameConstants.ENEMY_MAX_ANGULAR_X_VELOCITY)
        let randomXVelocity: Int
        
        if randomPosition.x < GameConstants.SCREEN_WIDTH * 1 / 4 {
            randomXVelocity = Int.random(in: GameConstants.ENEMY_MIN_HIGH_X_VELOCITY...GameConstants.ENEMY_MAX_HIGH_X_VELOCITY)
        } else if randomPosition.x < GameConstants.SCREEN_WIDTH * 2 / 4 {
            randomXVelocity = Int.random(in: GameConstants.ENEMY_MIN_LOW_X_VELOCITY...GameConstants.ENEMY_MAX_LOW_X_VELOCITY)
        } else if randomPosition.x < GameConstants.SCREEN_WIDTH * 4 / 4 {
            randomXVelocity = -Int.random(in: GameConstants.ENEMY_MIN_LOW_X_VELOCITY...GameConstants.ENEMY_MAX_LOW_X_VELOCITY)
        } else {
            randomXVelocity = -Int.random(in: GameConstants.ENEMY_MIN_HIGH_X_VELOCITY...GameConstants.ENEMY_MAX_HIGH_X_VELOCITY)
        }
        
        let randomYVelocity = Int.random(in: GameConstants.ENEMY_MIN_Y_VELOCITY...GameConstants.ENEMY_MAX_Y_VELOCITY)
        
        enemy.physicsBody = SKPhysicsBody(circleOfRadius: enemy.size.width / 2)
        enemy.physicsBody?.angularVelocity = randomAngularVelocity
        enemy.physicsBody?.velocity = CGVector(dx: randomXVelocity * GameConstants.NORMAL_MULTIPLE_CONST, dy: randomYVelocity * GameConstants.NORMAL_MULTIPLE_CONST)
        if enemy.name == "bonus" {
            enemy.physicsBody?.velocity = CGVector(dx: 0, dy: GameConstants.ENEMY_MAX_Y_VELOCITY * GameConstants.NORMAL_MULTIPLE_CONST)
        }
        enemy.physicsBody?.collisionBitMask = 0
        
        
        addChild(enemy)
        activeEnemies.append(enemy)
    }
    
    func substractLife() {
        lives -= 1
        run(SKAction.playSoundFileNamed("wrong.caf", waitForCompletion: true))
        
        let life: SKSpriteNode
        if lives == 2 {
            life = livesImages[0]
        } else if lives == 1 {
            life = livesImages[1]
        } else {
            life = livesImages[2]
            endGame(triggerByBoom: false)
        }
        
        life.texture = SKTexture(imageNamed: "sliceLifeGone")
        life.xScale = 1.3
        life.yScale = 1.3
        life.run(SKAction.scale(to: 1, duration: 0.1))
    }
    
    override func update(_ currentTime: TimeInterval) {
//        print(activeEnemies.count)
        if activeEnemies.count > 0 {
            for (index, node) in activeEnemies.enumerated().reversed() {
                if node.position.y < -140 {
                    node.removeAllActions()
                    if node.name == "enemy" || node.name == "bonus"{
                        node.name = ""
                        substractLife()
                        node.removeFromParent()
                        activeEnemies.remove(at: index)
                    } else if node.name == "boomContainer" {
                        node.name = ""
                        node.removeFromParent()
                        activeEnemies.remove(at: index)
                    }
                }
            }
        } else {
            if !isHasNextSequence {
                DispatchQueue.main.asyncAfter(deadline: .now() + popupTime) { [weak self] in
                    self?.tossEnemy()
                }
                isHasNextSequence = true
            }
        }
        
        
        var boomCount = 0
        for node in activeEnemies {
            if node.name == "boomContainer" {
                boomCount += 1
                break
            }
        }
        
        if boomCount == 0 {
            boomSoundEffect?.stop()
            boomSoundEffect = nil
        }
    }
    
    func tossEnemy() {
        guard isGameOver == false else { return }
        popupTime *= 0.991
        chainDelay *= 0.99
        physicsWorld.speed *= 1.02
        let sequence = sequences[sequencePos]
        
        switch sequence {
        case .oneNoBoom:
            createEnemy(forceBoom: .never)
        case .one:
            createEnemy(forceBoom: .radom)
        case .twoWithOneBoom:
            createEnemy(forceBoom: .always)
            createEnemy(forceBoom: .never)
        case .two:
            createEnemy(forceBoom: .radom)
            createEnemy(forceBoom: .radom)
        case .three:
            createEnemy(forceBoom: .radom)
            createEnemy(forceBoom: .radom)
            createEnemy(forceBoom: .radom)
        case .four:
            createEnemy(forceBoom: .radom)
            createEnemy(forceBoom: .radom)
            createEnemy(forceBoom: .radom)
            createEnemy(forceBoom: .radom)
        case .chain:
            createEnemy(forceBoom: .radom)
            DispatchQueue.main.asyncAfter(deadline: .now() + chainDelay / 5.0) { [weak self] in
                self?.createEnemy()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + chainDelay / 5.0 * 2) { [weak self] in
                self?.createEnemy()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + chainDelay / 5.0 * 3) { [weak self] in
                self?.createEnemy()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + chainDelay / 5.0 * 4) { [weak self] in
                self?.createEnemy()
            }
        case .fastChain:
            createEnemy(forceBoom: .radom)
            DispatchQueue.main.asyncAfter(deadline: .now() + chainDelay / 10.0) { [weak self] in
                self?.createEnemy()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + chainDelay / 10.0 * 2) { [weak self] in
                self?.createEnemy()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + chainDelay / 10.0 * 3) { [weak self] in
                self?.createEnemy()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + chainDelay / 10.0 * 4) { [weak self] in
                self?.createEnemy()
            }
        }
        
        sequencePos += 1
        isHasNextSequence = false
    }
}
