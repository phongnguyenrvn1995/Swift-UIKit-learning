//
//  Friend.swift
//  Shooting Gallery
//
//  Created by Phong Nguyễn Hoàng on 08/10/2023.
//

import SpriteKit

class Friend: Enemy {
    override func configure(texture: SKTexture, hMode: Enemy.Horizontal = .FULL, vMode: Enemy.Vertical = .TOP_TO_BOT, minY: CGFloat = -100, maxY: CGFloat = GameViewController.SCREEN_HEIGHT + 100, verticalStep: CGFloat = 100, mySpeed: CGFloat = GameViewController.SCREEN_HEIGHT) {
        super.configure(texture: texture, hMode: hMode, vMode: vMode, minY: minY, maxY: maxY, verticalStep: verticalStep, mySpeed: mySpeed)
        
        name = "friend_\(texture)"
    }
    
    override func jet() {
        
    }
}
