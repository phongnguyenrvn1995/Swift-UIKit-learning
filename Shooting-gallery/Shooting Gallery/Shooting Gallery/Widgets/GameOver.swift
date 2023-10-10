//
//  GameOver.swift
//  Shooting Gallery
//
//  Created by Phong Nguyễn Hoàng on 15/10/2023.
//

import SpriteKit

class GameOver: SKSpriteNode {
    var gameoVer: SKSpriteNode!
    func configure() {
        gameoVer = SKSpriteNode(texture: TextureFactory.OTHER_GAME_OVER)
        gameoVer.size = self.size
        gameoVer.isHidden = true
        addChild(gameoVer)
    }
    
    func fadeIn(action: (@escaping () -> Void) = {}) {
        gameoVer.isHidden = true
        run(SKAction.playSoundFileNamed("whoosh", waitForCompletion: false))
        var listSKA: [SKAction] = []
        listSKA.append(SKAction.scale(to: 10, duration: 0))
        listSKA.append(SKAction.run { [weak self] in
            self?.gameoVer.isHidden = false
        })
        listSKA.append(SKAction.scale(to: 1, duration: 0.5))
        listSKA.append(SKAction.wait(forDuration: 0.5))
        listSKA.append(SKAction.run(action))
        run(SKAction.sequence(listSKA))
    }
    
    func fadeOut(action: (@escaping () -> Void) = {}) {
        gameoVer.isHidden = true
        run(SKAction.playSoundFileNamed("whoosh", waitForCompletion: false))
        var listSKA: [SKAction] = []
        listSKA.append(SKAction.scale(to: 1, duration: 0))
        listSKA.append(SKAction.run { [weak self] in
            self?.gameoVer.isHidden = false
        })
        listSKA.append(SKAction.scale(to: 10, duration: 0.5))
        listSKA.append(SKAction.wait(forDuration: 0.5))
        listSKA.append(SKAction.run(action))
        run(SKAction.sequence(listSKA))
    }
}
