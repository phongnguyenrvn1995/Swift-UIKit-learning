//
//  DelayBar.swift
//  Shooting Gallery
//
//  Created by Phong Nguyễn Hoàng on 14/10/2023.
//

import SpriteKit

class DelayBar: SKSpriteNode {
    var mask: SKSpriteNode!
    var node: SKSpriteNode!
    func configure(size: CGSize) {
        self.size = size
        let cropNode = SKCropNode()
        mask = SKSpriteNode(texture: TextureFactory.OTHER_DELAY_BULLET_MASK)
        mask.size = size
        cropNode.maskNode = mask
        
        node = SKSpriteNode(texture: TextureFactory.OTHER_DELAY_BULLET)
        node.size = size
        node.zPosition = mask.zPosition
        cropNode.addChild(node)
        cropNode.zPosition = 1
        addChild(cropNode)
    }
    
    func refill(durationSecs: TimeInterval) {
        mask.position = CGPoint(x: -size.width, y: 0)
        mask.removeAction(forKey: "refill")
        mask.run(SKAction.moveTo(x: 0, duration: durationSecs), withKey: "refill")
    }
    
    func setPercent(percent: CGFloat) {
        mask.position.x = -mask.size.width + (mask.size.width * percent / CGFloat(100))
    }
}

class LoadingBar: DelayBar {
    var bg: SKSpriteNode!
    override func configure(size: CGSize) {
        super.configure(size: size)
        mask.size = CGSize(width: size.width * 9.5 / 10, height: size.height * 7 / 10)
        node.size = CGSize(width: size.width * 9.5 / 10, height: size.height * 7 / 10)
        node.texture = TextureFactory.OTHER_LOADING
        
        bg = SKSpriteNode(texture: TextureFactory.OTHER_DELAY_BULLET_BG)
        bg.size = size
        bg.zPosition = 0
        addChild(bg)
    }
}
