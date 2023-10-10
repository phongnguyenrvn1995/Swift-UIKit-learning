//
//  GameScene.swift
//  Shooting Gallery
//
//  Created by Phong Nguyễn Hoàng on 07/10/2023.
//

import SpriteKit
import Darwin
import AVFoundation

class GameScene: SKScene, SKPhysicsContactDelegate, HeartPanelDelegate, MapDelegate {
    
    var SHOOT_FORCE = 1000.0
    var SHOOT_DELAY = 1000.0
    var MAX_BULLET_IN_A_SESSION = 3
    var BULLET_TEXTURE = TextureFactory.BULLET_RED_CIRCLE
    
    var isCancel = false
    var numberOfBulletInSession = 0
    var lastShootTimestamps = Date().timeIntervalSince1970 * 1000
    
    var cannonSprite: CannonSprite!
    var cancelSprite: SKSpriteNode!
    var cancelRedPannel: SKSpriteNode!
    var loadingBar: LoadingBar!
    var heartPanel: HeartPanel!
    var delayBar: DelayBar!
    var gameOverPannel: GameOver!
    var ratePannel: Rate!
    
    var playBtn: FTButtonNode!
    
    var backgroundSound: AVAudioPlayer?
    var enemies: [Enemy] = []
    var infoBullet: [String: Any]!
    var timer: Timer?
    var map: [Map] = [Map1()]
    var currentMapIndex = 0
    var enemyIdx = 0
    
    
    override func didMove(to view: SKView) {
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
        applyBulletType(type: .RED)
//        initMap()
        startScreen()
    }
    
    func startScreen(position: CGPoint = CGPoint(x: GameViewController.SCREEN_WIDTH / 2, y: GameViewController.SCREEN_HEIGHT / 2)) {
//        let bg = SKSpriteNode(texture: TextureFactory.BG_1)
//        bg.position = CGPoint(x: GameViewController.SCREEN_WIDTH / 2, y: GameViewController.SCREEN_HEIGHT / 2)
//        bg.size = CGSize(width: GameViewController.SCREEN_WIDTH, height: GameViewController.SCREEN_HEIGHT)
//        bg.zPosition = -2
//        addChild(bg)
        
        playBtn = FTButtonNode(normalTexture: TextureFactory.OTHER_RED_BUTTON, selectedTexture: TextureFactory.OTHER_RED_BUTTON_PRESSED, disabledTexture: TextureFactory.OTHER_RED_BUTTON)
        playBtn.size = CGSize(width: GameViewController.SCREEN_WIDTH / 6, height: GameViewController.SCREEN_HEIGHT / 7)
        playBtn.position = position
        playBtn.setButtonAction(target: self, triggerEvent: .TouchUpInside, action: #selector(onPlayButtonTapped))
        playBtn.setButtonLabel(title: "ROUND 1", font: "Avenir-Black", fontSize: 32)
        addChild(playBtn)
    }
    
    @objc func onPlayButtonTapped() {
        initMap()
    }
    
    func rate(action: (@escaping () -> Void) = {}) {
        ratePannel.rate(rate: heartPanel.currentHealth, action: action)
    }
    
    func showGameOver(action: (@escaping() -> Void) = {}) {
        gameOverPannel.fadeIn(action: action)
    }
    
    func hideGameOver(action: (@escaping() -> Void) = {}) {
        gameOverPannel.fadeOut(action: action)
    }
    
    func countDown() {
        let cd = CountDownSprite()
        cd.position = CGPoint(x: GameViewController.SCREEN_WIDTH / 2, y: GameViewController.SCREEN_HEIGHT / 2)
        cd.zPosition = 100
        cd.configure()
        addChild(cd)
        cd.countDown(from: 3) { [weak self] in
            self?.applyMap()
        }
    }
    
    func initMap() {
        cannonSprite = nil
        cancelSprite = nil
        cancelRedPannel = nil
        loadingBar = nil
        heartPanel = nil
        delayBar = nil
        gameOverPannel = nil
        ratePannel = nil
        
        removeAllChildren()
//        print("removed")
        loadingBar = LoadingBar()
        addChild(loadingBar)
        loadingBar.configure(size: CGSize(width: GameViewController.SCREEN_WIDTH / 2, height: GameViewController.SCREEN_HEIGHT /  15))
        loadingBar.position = CGPoint(x: GameViewController.SCREEN_WIDTH / 2, y: GameViewController.SCREEN_HEIGHT / 2)
        loadingBar.setPercent(percent: 0)
        
        map[currentMapIndex] = Map1()
        map[currentMapIndex].delegate = self
        map[currentMapIndex].mapInit()
    }
    
    func applyMap() {
        enemies = map[currentMapIndex].enemies
        cannonSprite = map[currentMapIndex].cannonSprite
        addChild(cannonSprite)
        
        gameOverPannel = GameOver()
        gameOverPannel.size = CGSize(width: GameViewController.SCREEN_WIDTH * 2 / 3, height: GameViewController.SCREEN_HEIGHT * 2 / 3)
        gameOverPannel.position = CGPoint(x: GameViewController.SCREEN_WIDTH / 2, y: GameViewController.SCREEN_HEIGHT / 2)
        gameOverPannel.configure()
        gameOverPannel.zPosition = 100
        addChild(gameOverPannel)
        
        ratePannel = Rate()
        ratePannel.position = CGPoint(x: GameViewController.SCREEN_WIDTH / 2, y: GameViewController.SCREEN_HEIGHT * 2 / 3)
        ratePannel.configure(starSize: CGSize(width: GameViewController.SCREEN_WIDTH / 8, height: GameViewController.SCREEN_WIDTH / 8))
        addChild(ratePannel)
        
        
        cancelSprite = SKSpriteNode(texture: TextureFactory.BTN_CANCEL)
        cancelSprite.size = cannonSprite.size
        cancelSprite.position = cannonSprite.position
        cancelSprite.zPosition = cannonSprite.zPosition + 1
        cancelSprite.alpha = 0.5
        cancelSprite.isHidden = true
        addChild(cancelSprite)
        
        cancelRedPannel = SKSpriteNode(color: UIColor.red, size: CGSize(width: GameViewController.SCREEN_WIDTH, height: GameViewController.SCREEN_HEIGHT))
        cancelRedPannel.position = CGPoint(x: GameViewController.SCREEN_WIDTH / 2, y: GameViewController.SCREEN_HEIGHT / 2)
        cancelRedPannel.alpha = 0.5
        cancelRedPannel.zPosition = cancelSprite.zPosition
        cancelRedPannel.isHidden = true
        addChild(cancelRedPannel)
        
        delayBar = DelayBar()
        delayBar.configure(size: CGSize(width: cannonSprite.size.width * 2, height: cannonSprite.size.height / 5))
        delayBar.position = CGPoint(x: cannonSprite.position.x, y: cannonSprite.position.y - cannonSprite.size.height / 2 - delayBar.size.height / 2)
        addChild(delayBar)
        
        heartPanel = HeartPanel()
        heartPanel.configure(num: 3, itemSize: cannonSprite.size.width / 3)
        heartPanel.position = CGPoint(x: cannonSprite.position.x, y: delayBar.position.y - delayBar.size.height / 2 - cannonSprite.size.width / 3 / 2)
        heartPanel.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        heartPanel.delegate = self
        addChild(heartPanel)
        
        self.enemies.shuffle()
        if timer != nil { timer?.invalidate() }
        timer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { _ in
            if let e = self.enemies.filter({ i in
                i.isWaiting && !i.isDied
            }).first {
                e.resetPosition(isRight: false)
                self.addChild(e)
                e.transform(isTransformIn: true)
            }
        }
    }
    
    func applyBulletType(type: BulletType) {
        infoBullet = Bullet.apply(type: type)
        SHOOT_FORCE = infoBullet["force"]! as! Double
        SHOOT_DELAY = infoBullet["delay"]! as! Double
        MAX_BULLET_IN_A_SESSION = infoBullet["num"]! as! Int
        BULLET_TEXTURE = infoBullet["texture"] as! SKTexture
    }
    
    func backgroundSound(stop: Bool = false) {
        if stop {
            backgroundSound?.stop()
            return
        }
        
        if let url = map[currentMapIndex].createBackGroundSound() {
            backgroundSound = try? AVAudioPlayer(contentsOf: url)
            if let backgroundSound = backgroundSound {
                backgroundSound.numberOfLoops = .max
                backgroundSound.volume = 0.2
                backgroundSound.play()
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        print("touchesBegan")
        guard let cannonSprite = self.cannonSprite else { return }
        guard let touch = touches.first else { return }
        let position = touch.location(in: self)
        
        if let rotateAngle = calcAngle(position) {
            cannonSprite.zRotation = -rotateAngle
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        print("touchesMoved")
        guard let cannonSprite = self.cannonSprite else { return }
        guard let touch = touches.first else { return }
        let position = touch.location(in: self)
        let nodes = nodes(at: position)
        
        if let rotateAngle = calcAngle(position) {
            cannonSprite.zRotation = -rotateAngle
            cancelSprite.isHidden = false
        }
        
        if nodes.contains(cancelSprite) {
            cancelRedPannel.isHidden = false
        } else {
            cancelRedPannel.isHidden = true
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        print("touchesEnded")
        guard self.cannonSprite != nil else { return }
        if touches.count != 1 { return }
        guard let touch = touches.first else { return }
        let position = touch.location(in: self)
        let nodes = nodes(at: position)
        
        if !nodes.contains(cancelSprite) {
            shoot(position)
        }
        cancelSprite.isHidden = true
        cancelRedPannel.isHidden = true
    }
    
    
    func shoot(_ position: CGPoint) {
        guard let cannonSprite = self.cannonSprite else { return }
        if map[currentMapIndex].isDone == true { return }
        if numberOfBulletInSession >= MAX_BULLET_IN_A_SESSION { return }
        if Date().timeIntervalSince1970 * 1000 <= lastShootTimestamps + SHOOT_DELAY {
            return
        }
        
        
        let dx = position.x - cannonSprite.position.x
        let dy = position.y - cannonSprite.position.y
        if dy <= 0 { return }
        let vector = CGVector(dx: dx, dy: dy).setSpeed(to: SHOOT_FORCE)
        
        let bullet = Bullet()
        bullet.name = "bullet_"
        bullet.position = cannonSprite.position
        bullet.size = CGSize(width: cannonSprite.size.width / 3, height: cannonSprite.size.height / 3)
//        print(vector.speed())
        bullet.zPosition = cannonSprite.zPosition - 1
        bullet.configure(texture: BULLET_TEXTURE, vector: vector.setSpeed(to: SHOOT_FORCE))
        bullet.physicsBody?.contactTestBitMask = GameViewController.CATEGORY_ENEMY
        addChild(bullet)
        numberOfBulletInSession += 1
        cannonSprite.fire()
        lastShootTimestamps = Date().timeIntervalSince1970 * 1000
        delayBar.refill(durationSecs: infoBullet["delay"] as! Double / 1000)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard self.cannonSprite != nil else { return }
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        [nodeA, nodeB].forEach { item in
            if item.name?.starts(with: "enemy_") == true {
                let enemy = item as! Enemy
                enemy.isDied = true
                enemy.removeFromParent()
                explode(position: enemy.position)
            } else if item.name?.starts(with: "friend_") == true {
                let friend = item as! Enemy
                friend.isDied = true
                friend.removeFromParent()
                explode(position: friend.position)
                heartPanel.decrease()
            } else if item.name?.starts(with: "bullet_") == true {
                item.removeFromParent()
                numberOfBulletInSession -= 1
            }
        }
    }
    
    func explode(position: CGPoint) {
        guard self.cannonSprite != nil else { return }
        if let explode = SKEmitterNode(fileNamed: "explode") {
            explode.position = position
            run(SKAction.playSoundFileNamed("explosion", waitForCompletion: false))
            addChild(explode)
            run(SKAction.sequence([
                SKAction.wait(forDuration: 2),
                SKAction.run {
                    explode.removeFromParent()
                }
            ]))
        }
    }
    
    func onFull() {
        
    }
    
    func onNext() {
//        print("Next")
        killAllEnemiesAndFriends()
        self.map[currentMapIndex].isDone = true
        currentMapIndex += 1
        if currentMapIndex >= map.count {
            currentMapIndex = 0
        }
        run(SKAction.sequence([
            SKAction.run { [weak self] in
                self?.rate() {
                    self?.startScreen(position: CGPoint(x: GameViewController.SCREEN_WIDTH / 2, y: GameViewController.SCREEN_HEIGHT / 8))
                }
            }
        ]))
    }
    
    func backGroundLoaded() {
        backgroundSound()
        let bg = map[currentMapIndex].background
//        print("add bg")
        addChild(bg!)
    }
    
    func onLoading(percent: CGFloat) {
        loadingBar.setPercent(percent: (percent))
//        print(percent)
    }
    
    func onLoaded() {
        loadingBar.removeFromParent()
        countDown()
    }
    
    func onRunOut() {
        map[currentMapIndex].isDone = true
        killAllEnemiesAndFriends()
        showGameOver() { [weak self] in
            guard let self = self else { return }
            self.run(SKAction.sequence([
                SKAction.wait(forDuration: 3),
                SKAction.run { [weak self] in
//                    self?.hideGameOver() {
//                        self?.initMap()
//                    }
                    self?.startScreen(position: CGPoint(x: GameViewController.SCREEN_WIDTH / 2, y: GameViewController.SCREEN_HEIGHT / 8))
                }
            ]))
        }
    }
    
    func removeRelavantCannon() {
        cannonSprite.removeFromParent()
        cancelSprite.removeFromParent()
        heartPanel.removeFromParent()
        delayBar.removeFromParent()
    }
    
    func killAllEnemiesAndFriends() {
        removeRelavantCannon()
        timer?.invalidate()
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            guard let self = self else { return }
            enemies.filter({ item in
                !item.isWaiting
            }).forEach { item in
                item.isDied = true
                item.transform(isTransformIn: false)
            }
        }
    }
    
    func calcAngle(_ position: CGPoint) -> CGFloat? {
        let oppositeLine = position.x - cannonSprite.position.x
        let nextToLine = position.y - cannonSprite.position.y
        if nextToLine <= 0 { return nil }
        let tan = oppositeLine / nextToLine
        return atan(tan)
    }
    
    override func update(_ currentTime: TimeInterval) {
        children.forEach { node in
            if node.position.x < -100 || node.position.x > GameViewController.SCREEN_WIDTH + 100
                || node.position.y < -100 || node.position.y > GameViewController.SCREEN_HEIGHT + 100 {
                node.removeFromParent()
                if node.name?.starts(with: "bullet_") == true {
                    numberOfBulletInSession -= 1
                }
            }
        }
        
    }
    
}

extension CGVector {
    func setSpeed(to maxLength: CGFloat) -> CGVector {
        let currentSpeed = hypot(dx, dy)

            let scale = maxLength / currentSpeed
            return CGVector(dx: dx * scale, dy: dy * scale)
    }
    
    func speed() -> CGFloat {
        return hypot(dx, dy)
    }
}
