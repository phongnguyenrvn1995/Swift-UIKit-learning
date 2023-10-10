//
//  Bullet.swift
//  Shooting Gallery
//
//  Created by Phong Nguyễn Hoàng on 08/10/2023.
//

import SpriteKit
import Darwin

class Bullet: SKSpriteNode {
    var bullet: SKSpriteNode!
    func configure(texture: SKTexture, vector: CGVector) {
        bullet = SKSpriteNode(texture: texture)
        bullet.size = size
        physicsBody = SKPhysicsBody(circleOfRadius: bullet.size.width / 2)
        physicsBody?.velocity = vector
        bullet.run(SKAction.repeatForever(SKAction.rotate(byAngle: .pi, duration: 0.1)))
        addChild(bullet)
        
        if let tail = SKEmitterNode(fileNamed: "bullet_tail") {
            tail.position.y = -(size.height / 2)
            tail.advanceSimulationTime(3)
            addChild(tail)
        }
        
        zRotation = -atan(vector.dx / vector.dy)
    }
    
    static func apply(type: BulletType = .RED) -> [String: Any] {
        var dic = [String: Any]()
        switch(type) {
        case .RED:
            dic["force"] = GameViewController.SCREEN_HEIGHT
            dic["delay"] = 1000.0
            dic["num"] = 3
            dic["texture"] = TextureFactory.BULLET_RED_CIRCLE
            break
        case .GREEN:
            dic["force"] = GameViewController.SCREEN_HEIGHT * 2
            dic["delay"] = 800.0
            dic["num"] = 4
            dic["texture"] = TextureFactory.BULLET_GREEN_CIRCLE
            break
        case .BLUE:
            dic["force"] = GameViewController.SCREEN_HEIGHT * 3
            dic["delay"] = 600.0
            dic["num"] = 5
            dic["texture"] = TextureFactory.BULLET_BLUE_CIRCLE
            break
        case .ORANGE:
            dic["force"] = GameViewController.SCREEN_HEIGHT * 4
            dic["delay"] = 400.0
            dic["num"] = 6
            dic["texture"] = TextureFactory.BULLET_ORANGE_CIRCLE
            break
        }
        return dic
    }
    
    deinit {
//        print("BULLET DEINIIT")
    }
}


enum BulletType {
    case RED
    case GREEN
    case BLUE
    case ORANGE
}
