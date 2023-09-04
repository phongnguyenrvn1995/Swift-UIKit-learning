//
//  WhackSlot.swift
//  Project-14
//
//  Created by Phong Nguyễn Hoàng on 28/08/2023.
//

import UIKit
import SpriteKit

class WhackSlot: SKNode {
    var isVisible = false
    var isHit = false
    var charNode: SKSpriteNode!
    
    func configure(at position: CGPoint) {
        self.position = position
        let sprite = SKSpriteNode(imageNamed: "whackHole")
        addChild(sprite)
        
        let cropNode = SKCropNode()
        cropNode.position = CGPoint(x: 0, y: 15)
        cropNode.zPosition = 1
        cropNode.maskNode = SKSpriteNode(imageNamed: "whackMask")
        
        charNode = SKSpriteNode(imageNamed: "penguinGood")
        charNode.position = CGPoint(x: 0, y: -90)
        charNode.name = "character"
        cropNode.addChild(charNode)
        
        addChild(cropNode)
    }
    
    func show(hideTime: Double) {
        if isVisible { return }
        charNode.xScale = 1
        charNode.yScale = 1
        if let showEffect = SKEmitterNode(fileNamed: "my_magic.sks") {
            showEffect.zPosition = 1
            addChild(showEffect)
        }
        charNode.run(SKAction.moveBy(x: 0, y: 80, duration: 0.05))
        isVisible = true
        isHit = false
        
        if Int.random(in: 0...2) == 0 {
            charNode.texture = SKTexture(imageNamed: "penguinEvil")
            charNode.name = "penguinEnemy"
        } else {
            charNode.texture = SKTexture(imageNamed: "penguinGood")
            charNode.name = "penguinFriend"
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + hideTime * 3.5, execute: { [weak self] in
            self?.hide()
        })
    }
    
    func hide() {
        if !isVisible { return }
        if let showEffect = SKEmitterNode(fileNamed: "my_magic.sks") {
            showEffect.zPosition = 1
            addChild(showEffect)
        }
        charNode.run(SKAction.moveBy(x: 0, y: -80, duration: 0.05))
        isVisible = false
    }
    
    func hit() {
        isHit = true
        let delay = SKAction.wait(forDuration: 0.5)
        let hide = SKAction.moveBy(x: 0, y: -80, duration: 0.5)
        let notVisible = SKAction.run { [weak self] in
            self?.isVisible = false;
        }
        
        if let fire = SKEmitterNode(fileNamed: charNode.name == "penguinFriend" ? "friend_hit.sks" : "evil_hit_s.sks") {
            fire.zPosition = 1
            addChild(fire)
        }
        
        let sequence = SKAction.sequence([delay, hide, notVisible])
        charNode.run(sequence)
    }
}
