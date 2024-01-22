//
//  GameViewController.swift
//  Project-29
//
//  Created by Phong Nguyễn Hoàng on 21/01/2024.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    var currentGame: GameScene?
    
    @IBOutlet var windLable: UILabel!
    @IBOutlet var btnPlayAgain: UIButton!
    @IBOutlet var p2ScoreLable: UILabel!
    @IBOutlet var p1ScoreLable: UILabel!
    @IBOutlet var angleLable: UILabel!
    @IBOutlet var angleSlider: UISlider!
    @IBOutlet var velocityLabel: UILabel!
    @IBOutlet var velocitySlider: UISlider!
    @IBOutlet var playerNumber: UILabel!
    @IBOutlet var btnLaunch: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        startGamePlay()
    }
    
    func startGamePlay() {
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                scene.size.height = CGFloat(SizeConsts.HEIGHT)
                scene.size.width = CGFloat(SizeConsts.WIDTH)
                // Present the scene
                view.presentScene(scene, transition: SKTransition.fade(withDuration: 2))                
                currentGame = scene as? GameScene
                currentGame?.gameViewController = self
                currentGame?.p1Score = 0
                currentGame?.p2Score = 0
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
            
            angleChanged(self)
            velocityChanged(self)
            p2ScoreLable.isHidden = false
            p1ScoreLable.isHidden = false
            angleLable.isHidden = false
            angleSlider.isHidden = false
            velocityLabel.isHidden = false
            velocitySlider.isHidden = false
            playerNumber.isHidden = false
            btnLaunch.isHidden = false
            windLable.isHidden = false
            btnPlayAgain.isHidden = true
        }
    }

    func gameOver(winnerPlayer: Int) {
        if let view = self.view as? SKView {
            if let scene = SKScene(fileNamed: "GameOverScene") {
                scene.scaleMode = .aspectFill
                scene.size.height = CGFloat(SizeConsts.HEIGHT)
                scene.size.width = CGFloat(SizeConsts.WIDTH)
                let scene_ = scene as? GameOverScene
                scene_?.winner = winnerPlayer
                view.presentScene(scene, transition: SKTransition.fade(withDuration: 2))
            }
            
            view.ignoresSiblingOrder = true
            view.showsFPS = true
            view.showsNodeCount = true
            
            p2ScoreLable.isHidden = true
            p1ScoreLable.isHidden = true
            angleLable.isHidden = true
            angleSlider.isHidden = true
            velocityLabel.isHidden = true
            velocitySlider.isHidden = true
            playerNumber.isHidden = true
            btnLaunch.isHidden = true
            windLable.isHidden = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.1, execute: DispatchWorkItem(block: { [weak self] in
                self?.btnPlayAgain.isHidden = false
            }))
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
    
    @IBAction func angleChanged(_ sender: Any) {
        angleLable.text = "Angle: \(Int(angleSlider.value))°"
    }
    
    @IBAction func velocityChanged(_ sender: Any) {
        velocityLabel.text = "Velocity: \(Int(velocitySlider.value))"
    }
    
    @IBAction func launch(_ sender: Any) {
        angleLable.isHidden = true
        angleSlider.isHidden = true
        velocityLabel.isHidden = true
        velocitySlider.isHidden = true
        btnLaunch.isHidden = true
        
        currentGame?.launch(angle: Int(angleSlider.value), velocity: Int(velocitySlider.value))
    }
    
    func activePlayer(number: Int) {
        if number == 1 {
            playerNumber.text = "<<< PLAYER ONE"
        } else {
            playerNumber.text = "PLAYER TWO >>>"
        }
        angleLable.isHidden = false
        angleSlider.isHidden = false
        velocityLabel.isHidden = false
        velocitySlider.isHidden = false
        btnLaunch.isHidden = false
    }
    
    @IBAction func playAgainTapped(_ sender: Any) {
        startGamePlay()
    }
}
