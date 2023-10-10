//
//  GameViewController.swift
//  Shooting Gallery
//
//  Created by Phong Nguyễn Hoàng on 07/10/2023.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    static var SCREEN_WIDTH = 1792.0
    static var SCREEN_HEIGHT = 828.0
    static var CATEGORY_ENEMY: UInt32 = 0b00000001
    static var CATEGORY_FRIEND: UInt32 = 0b00000010
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(UIScreen.main.nativeBounds.width)
        if (UIScreen.main.nativeBounds.height <= 1334) { // iphone < X
            GameViewController.SCREEN_WIDTH = 1334
            GameViewController.SCREEN_HEIGHT = 750
        }
            
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.size.width = GameViewController.SCREEN_WIDTH
                scene.size.height = GameViewController.SCREEN_HEIGHT
                scene.scaleMode = .fill
                
                // Present the scene
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
