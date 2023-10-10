//
//  CannonSprite.swift
//  Shooting Gallery
//
//  Created by Phong Nguyễn Hoàng on 08/10/2023.
//

import SpriteKit

class CannonSprite: SKSpriteNode {
    var cannonSprite: SKSpriteNode!
    public func configure(texture: SKTexture) {
        cannonSprite = SKSpriteNode(texture: texture)
        cannonSprite.size = size
        cannonSprite.zPosition = zPosition
//        print("size \(cannonSprite.size)",
//              "position \(cannonSprite.position)",
//              "anchor \(cannonSprite.anchorPoint)",
//              separator:  "---")
        addChild(cannonSprite)
    }
    
    public func fire() {
        if let fire = SKEmitterNode(fileNamed: "shoot") {
            fire.position = CGPoint(x: cannonSprite.position.x, y: cannonSprite.position.y + size.height / 2)
            fire.zPosition = cannonSprite.zPosition + 1
            addChild(fire)
            
            run(SKAction.playSoundFileNamed("shoot.mp3", waitForCompletion: false))
            
            cannonSprite.run(SKAction.sequence([
                SKAction.scaleY(to: 0.7, duration: 0.1),
                SKAction.scaleY(to: 1.0, duration: 0.1),
            ]))
            
            run(SKAction.sequence([
                SKAction.wait(forDuration: 1.5),
                SKAction.run { [weak fire] in
                    fire?.removeFromParent()
                }
            ]))
        }
    }
}
