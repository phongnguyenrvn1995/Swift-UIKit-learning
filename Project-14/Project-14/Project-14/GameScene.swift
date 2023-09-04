//
//  GameScene.swift
//  Project-14
//
//  Created by Phong Nguyễn Hoàng on 27/08/2023.
//

import SpriteKit

class GameScene: SKScene {
    var roundGame = 0;
    let SCREEN_WIDTH = 1024
    let SCREEN_HEIGHT = 768
    var popupTime = 0.85
    
    var slots = [WhackSlot]()
    var gameScore: SKLabelNode!
    var score = 0 {
        didSet {
            gameScore.text = "Score: \(score)"
        }
    }
    
    override func didMove(to view: SKView) {
        let backGround = SKSpriteNode(imageNamed: "whackBackground")
        backGround.position = CGPoint(x: SCREEN_WIDTH/2, y: SCREEN_HEIGHT/2)
        backGround.zPosition = -1
        backGround.blendMode = .replace
        addChild(backGround)
        
        gameScore = SKLabelNode(fontNamed: "Chalkduster")
        gameScore.text = "Score: 0";
        gameScore.position = CGPoint(x: 8, y: 8)
        gameScore.horizontalAlignmentMode = .left
        gameScore.fontSize = 48
        addChild(gameScore)
        
        for i in 0..<5 { createSlot(at: CGPoint(x: 100 + 170 * i, y: 410)) }
        for i in 0..<4 { createSlot(at: CGPoint(x: 180 + 170 * i, y: 320)) }
        for i in 0..<5 { createSlot(at: CGPoint(x: 100 + 170 * i, y: 230)) }
        for i in 0..<4 { createSlot(at: CGPoint(x: 180 + 170 * i, y: 140)) }
        
//        createEnemy()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: { [weak self] in
            self?.createEnemy()
        })
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let tapNodes = nodes(at: location)
        
        for item in tapNodes {
            guard let whackSlot = item.parent?.parent as? WhackSlot else { continue }
            if !whackSlot.isVisible { continue }
            if whackSlot.isHit { continue }
            whackSlot.hit()
//            print(item.name)
            
            if(item.name == "penguinFriend") {
                score -= 5
                run(SKAction.playSoundFileNamed("whackBad.caf", waitForCompletion: false)) {
                    print("OK")
                }
            } else if(item.name == "penguinEnemy") {
                score += 1
                item.xScale = 0.85
                item.yScale = 0.85
                let sound = SKAction.playSoundFileNamed("whack.caf", waitForCompletion: false)
                run(sound)
            }
        }
    }
    
    func createSlot(at position: CGPoint) {
        let slot = WhackSlot()
        slot.configure(at: position)
        addChild(slot)
        slots.append(slot)
    }
    
    func createEnemy() {
        roundGame += 1
        if roundGame >= 30 {
            //hide all penguin
            slots.forEach { item in
                item.hide()
            }
            //game over label
            let gameOver = SKSpriteNode(imageNamed: "gameOver")
            gameOver.position = CGPoint(x: SCREEN_WIDTH/2, y: SCREEN_HEIGHT/2)
            gameOver.zPosition = 1
            addChild(gameOver)
            //score
            let scoreLabel = SKLabelNode(text: "Your score: \(score)")
            scoreLabel.fontName = "Chalkduster"
            scoreLabel.fontSize = 40
            scoreLabel.horizontalAlignmentMode = .center
            scoreLabel.verticalAlignmentMode = .center
            scoreLabel.position = CGPoint(x: SCREEN_WIDTH/2, y: SCREEN_HEIGHT/2 - 100)
            scoreLabel.zPosition = 1
            addChild(scoreLabel)
            
            run(SKAction.playSoundFileNamed("game-over.wav", waitForCompletion: false))
            return
        }
        
        popupTime *= 0.991
        slots.shuffle()
        
        if Int.random(in: 0...12) > 4 { slots[0].show(hideTime: popupTime) }
        if Int.random(in: 0...12) > 6 { slots[1].show(hideTime: popupTime) }
        if Int.random(in: 0...12) > 8 { slots[2].show(hideTime: popupTime) }
        if Int.random(in: 0...12) > 11 { slots[3].show(hideTime: popupTime) }
        
        let minPopup = popupTime / 2
        let maxPopup = popupTime * 2
        
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double.random(in: minPopup...maxPopup), execute: { [weak self] in
            self?.createEnemy()
        })
    }
}
