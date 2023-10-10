//
//  CountDownSprite.swift
//  Shooting Gallery
//
//  Created by Phong Nguyễn Hoàng on 15/10/2023.
//

import SpriteKit

class CountDownSprite: SKNode {
    var label: SKLabelNode!
    func configure() {
        label = SKLabelNode(text: "3")
        label.fontName = "Chalkduster"
        label.fontSize = 300
        label.verticalAlignmentMode = .center
        label.fontColor = .red
        addChild(label)
    }
    
    func countDown(from: Int, action: @escaping (() -> Void)) {
        var listSKA: [SKAction] = []
        for i in stride(from: from, through: 0, by: -1) {
            listSKA.append(SKAction.run {
                if i == 0 {
                    self.label.text = "START"
                } else {
                    self.label.text = "\(i)"
                }
            })
            listSKA.append(SKAction.scale(to: 10, duration: 0))
            listSKA.append(SKAction.scale(to: 1, duration: 0.5))
            listSKA.append(SKAction.wait(forDuration: 0.5))
        }
        listSKA.append(SKAction.run { [weak self] in
            self?.label.isHidden = true
        })
        listSKA.append(SKAction.run(action))
        run(SKAction.sequence(listSKA))
    }
}
