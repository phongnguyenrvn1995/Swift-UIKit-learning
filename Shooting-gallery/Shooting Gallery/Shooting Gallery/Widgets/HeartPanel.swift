//
//  HeartPanel.swift
//  Shooting Gallery
//
//  Created by Phong Nguyễn Hoàng on 12/10/2023.
//

import UIKit
import SpriteKit

class HeartPanel: SKSpriteNode {
    var hearts: [SKSpriteNode] = []
    let positive = TextureFactory.OTHER_RED_HEART
    let negative = TextureFactory.OTHER_BLACK_HEART
    var health = 0
    var delegate: HeartPanelDelegate? = nil
    var currentHealth = 0 {
        didSet {
            for i in 0 ..< health {
                if i < currentHealth {
                    hearts[i].texture = positive
                } else {
                    hearts[i].texture = negative                }
            }
        }
    }
    
    func configure(num: Int, itemSize: CGFloat) {
//        size = CGSize(width: 300, height: 50)
        health = num
        for _ in 0 ..< num {
            let heart = SKSpriteNode(texture: positive)
            heart.size = CGSize(width: itemSize, height: itemSize)
            hearts.append(heart)
        }
        
        let startPositon = -(itemSize  + itemSize / 3) / 2 * CGFloat((hearts.count - 1) > 0 ? (hearts.count - 1) : 0)
        
        for index in 0 ..< hearts.count {
            let heart = hearts[index]
            heart.position = CGPoint(x: startPositon + (itemSize  + itemSize / 3) * CGFloat(index), y: 0)
            addChild(heart)        }
        currentHealth = num
    }
    
    func reset() {
        currentHealth = health
    }
    
    func decrease() {
        if !isRunOut() {
            currentHealth -= 1
        }
        if isRunOut() {
            print("RUN OUT")
            delegate?.onRunOut()
        }
    }
    
    func increase() {
        if isFull() {
            currentHealth += 1
        }
        if isFull() { delegate?.onFull() }
    }
    
    func isFull() -> Bool {
        return currentHealth == health
    }
    
    func isRunOut() -> Bool {
        return currentHealth <= 0
    }
}

protocol HeartPanelDelegate {
    func onFull()
    func onRunOut()
}
