//
//  Rate.swift
//  Shooting Gallery
//
//  Created by Phong Nguyễn Hoàng on 15/10/2023.
//

import SpriteKit

class Rate: SKSpriteNode {
    var blackStars: [SKSpriteNode]!
    var yellowStars: [SKSpriteNode]!
    func configure(starSize: CGSize) {
        blackStars = []
        yellowStars = []
        
        for _ in 0..<3 {
            let black = SKSpriteNode(texture: TextureFactory.OTHER_BLACK_STAR)
            let yellow = SKSpriteNode(texture: TextureFactory.OTHER_YELLOW_STAR)
            
            black.size = CGSize(width: starSize.width * 1.4, height: starSize.height * 1.4)
            black.zPosition = 10
            yellow.size = starSize
            yellow.zPosition = 11
            
            blackStars.append(black)
            yellowStars.append(yellow)
        }
        
        blackStars[0].position.x = -starSize.width * 5 / 3
        yellowStars[0].position.x = -starSize.width * 5 / 3
        
        blackStars[1].position.x = starSize.width * 5 / 3
        yellowStars[1].position.x = starSize.width * 5 / 3
        
        blackStars[2].size = CGSize(width: starSize.width * 2, height: starSize.height * 2)
        yellowStars[2].size = CGSize(width: starSize.width * 1.4, height: starSize.height * 1.4)
        
        blackStars.forEach { [weak self] item in
            item.isHidden = true
            self?.addChild(item)
        }
        yellowStars.forEach { [weak self] item in
            item.isHidden = true
            self?.addChild(item)
        }
    }
    
    func rate(rate: Int, action: (@escaping () -> Void) = {}) {
        if rate < 1 || rate > 3 { return }
        
        blackStars.forEach { item in
            item.isHidden = true
            item.setScale(10)
        }
        yellowStars.forEach { item in
            item.isHidden = true
            item.setScale(10)
        }
        
        for i in 0...2 {
            blackStars[i].run(SKAction.sequence([
                SKAction.run { [weak self] in
                    self?.blackStars[i].isHidden = false
                },
                SKAction.scale(to: 1, duration: 0.5 + Double(i) * 0.2)
            ]))
        }
        
        for i in 0..<rate {
            var listAC: [SKAction] = []
            listAC += [
                SKAction.wait(forDuration: 1.5),
                SKAction.run { [weak self] in
                    self?.yellowStars[i].isHidden = false
                },
                SKAction.scale(to: 1, duration: 0.5 + Double(i) * 0.2),
                SKAction.playSoundFileNamed("coin-sound", waitForCompletion: false),
                SKAction.wait(forDuration: 1)
            ]
            if i == rate - 1 {
                listAC += [
                    SKAction.wait(forDuration: 1),
                    SKAction.run {
                        action()
                    }
                ]
            }
            yellowStars[i].run(SKAction.sequence(listAC))
        }
    }
}
