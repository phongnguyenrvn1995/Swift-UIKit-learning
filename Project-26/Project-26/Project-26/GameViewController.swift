//
//  GameViewController.swift
//  Project-26
//
//  Created by Phong Nguyễn Hoàng on 26/12/2023.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    static let SCREEN_HEIGHT = UIScreen.main.bounds.height
    static let SCREEN_WIDTH = UIScreen.main.bounds.width
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                scene.size.height = GameViewController.SCREEN_HEIGHT
                scene.size.width = GameViewController.SCREEN_WIDTH
                
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
