//
//  GameOverScene.swift
//  Project-29
//
//  Created by Phong Nguyễn Hoàng on 22/01/2024.
//

import UIKit
import SpriteKit

class GameOverScene: SKScene {
    var winner = 1
    override func didMove(to view: SKView) {
        let lb = SKLabelNode(text: "WINNER IS PLAYER \(winner)")
        lb.fontSize = 40
        lb.position = CGPoint(x: SizeConsts.WIDTH / 2, y: SizeConsts.HEIGHT / 2)
        addChild(lb)
    }
}
