//
//  Map.swift
//  Shooting Gallery
//
//  Created by Phong Nguyễn Hoàng on 12/10/2023.
//

import UIKit
import SpriteKit

protocol PMap: AnyObject {
    var ENEMY_NAMES: [SKTexture] { get set } //= ["UFO-purple", "devil", "devil-head", "dracula"]
    var FRIEND_NAMES: [SKTexture] { get set } //= ["air-balloon", "jet", "satellite", "iss"]
    var enemies: [Enemy] { get set }
    var delegate: MapDelegate? { get set }
    var background: SKSpriteNode? {get set}
    var cannonSprite: CannonSprite? {get set}
    var isDone: Bool {get set}
    
    func createEnemies() -> [Enemy]
    func createFriends() -> [Friend]
    func backGroundName() -> SKTexture
    func createBackGround() -> SKSpriteNode
    func createBackGroundSound() -> URL?
    func createCannon() -> CannonSprite
}

extension PMap {
//    func mapInit() {
//        background = createBackGround()
//        enemies += createEnemies()
//        enemies += createFriends()
//        cannonSprite = createCannon()
//    }
}

protocol MapDelegate {
    func onNext()
    func onLoading(percent: CGFloat)
    func onLoaded()
    func backGroundLoaded()
}

class Map: PMap {
    var isDone: Bool = false
    var cannonSprite: CannonSprite?
    var ENEMY_NAMES: [SKTexture] = []
    var FRIEND_NAMES: [SKTexture] = []
    var enemies: [Enemy] = []
    var delegate: MapDelegate? = nil
    var background: SKSpriteNode?
    
    var enemySize = CGSize(width: GameViewController.SCREEN_HEIGHT / 6, height: GameViewController.SCREEN_HEIGHT / 6)
    var enemyBornPosition = CGPoint(x: GameViewController.SCREEN_WIDTH - 100, y: GameViewController.SCREEN_HEIGHT * 9 / 10)
    var enemyHorizontalMode = Enemy.Horizontal.FULL
    var enemyVerticalMode = Enemy.Vertical.TOP_TO_BOT
    var enemyMinY = GameViewController.SCREEN_HEIGHT / 4
    var enemyMaxY = GameViewController.SCREEN_HEIGHT + 100
    var enemyVerticalStep = GameViewController.SCREEN_HEIGHT / 5
    var enemySpeed = GameViewController.SCREEN_WIDTH / 4
    var friendSize = CGSize(width: GameViewController.SCREEN_HEIGHT / 6, height: GameViewController.SCREEN_HEIGHT / 6)
    var friendBornPosition = CGPoint(x: GameViewController.SCREEN_WIDTH - 100, y: GameViewController.SCREEN_HEIGHT * 9 / 10)
    var friendHorizontalMode = Enemy.Horizontal.FULL
    var friendVerticalMode = Enemy.Vertical.TOP_TO_BOT
    var friendMinY = GameViewController.SCREEN_HEIGHT / 4
    var friendMaxY = GameViewController.SCREEN_HEIGHT + 100
    var friendVerticalStep = GameViewController.SCREEN_HEIGHT / 5
    var friendSpeed = GameViewController.SCREEN_WIDTH / 4
    
    var observer = [NSKeyValueObservation]()
    
    func mapInit() {
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            guard let self = self else { return }
            enemies.removeAll()
            isDone = false
            background = createBackGround()
            DispatchQueue.main.sync {
                self.delegate?.backGroundLoaded()
            }
            enemies += createEnemies()
            enemies += createFriends()
            cannonSprite = createCannon()
            enemies.forEach { item in
                //            print(item)
                self.observer.append(item.observe(\.isDied, options: [.new], changeHandler: { [weak self] a,b in
                if self?.isDone == false && self?.isGameOver() == true {
                    self?.isDone = true
//                    print("self?.isDone == false")
                    self?.delegate?.onNext()
                }
            }))
            }
            DispatchQueue.main.sync {
                self.delegate?.onLoaded()
            }
        }
    }
    
    func createEnemies() -> [Enemy] {
        []
    }
    
    func createFriends() -> [Friend] {
        []
    }
    
    func backGroundName() -> SKTexture {
        TextureFactory.BG_1
    }
    
    func createBackGround() -> SKSpriteNode {
        let bg = SKSpriteNode(texture: backGroundName())
        bg.position.y = GameViewController.SCREEN_HEIGHT / 2
        bg.position.x = GameViewController.SCREEN_WIDTH / 2
        bg.size.width = GameViewController.SCREEN_WIDTH
        bg.size.height = GameViewController.SCREEN_HEIGHT
        bg.zPosition = -1
        bg.blendMode = .replace
        return bg
    }
    
    func createBackGroundSound() -> URL? {
        return Bundle.main.url(forResource: "round-1", withExtension: "mp3")
    }
    
    func createCannon() -> CannonSprite {
        let cannonSprite = CannonSprite()
        cannonSprite.size = CGSize(width: GameViewController.SCREEN_WIDTH / 15, height: GameViewController.SCREEN_WIDTH / 15)
        cannonSprite.position = CGPoint(x: GameViewController.SCREEN_WIDTH / 2, y: cannonSprite.size.height * 10 / 8)
        cannonSprite.zPosition = 10
        cannonSprite.configure(texture: TextureFactory.WEAPONS_CANNON_1)
        return cannonSprite
    }
    
    func isGameOver() -> Bool {
        let count = enemies.filter { item in
            item.name?.starts(with: "enemy_") == true
            && !item.isDied
        }.count
        return count <= 0
    }
}
