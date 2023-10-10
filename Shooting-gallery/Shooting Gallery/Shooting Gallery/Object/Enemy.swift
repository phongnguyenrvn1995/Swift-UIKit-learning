//
//  Enemy.swift
//  Shooting Gallery
//
//  Created by Phong Nguyễn Hoàng on 08/10/2023.
//

import SpriteKit

class Enemy: SKSpriteNode {
    var mySpeed = 1000.0
    var horizontalMode: Horizontal!
    var verticalMode: Vertical!
    var maxY: CGFloat!
    var minY: CGFloat!
    var verticalStep: CGFloat!
    var isTransformDone = false
    var backupPhysicBody: SKPhysicsBody!
    
    var moveDestination: CGPoint!
    var moveSource: CGPoint!
    @objc dynamic var isDied = false
    var isWaiting = true
    var body: SKSpriteNode!
    var justActionX = ActionMove.GEN
    var justActionY = ActionMove.GEN
    var displayLink: CADisplayLink!
    
    var move: ActionMove! {
        didSet {
            switch(move) {
            case .TO_BOTTOM: 
                backupPhysicBody?.velocity = CGVector(dx: 0, dy: -mySpeed)
                break
             
            case .TO_TOP:
                backupPhysicBody?.velocity = CGVector(dx: 0, dy: +mySpeed)
                break
                
            case .TO_LEFT:
                backupPhysicBody?.velocity = CGVector(dx: -mySpeed, dy: 0)
                xScale = 1.0
                break
                
            case .TO_RIGHT:
                backupPhysicBody?.velocity = CGVector(dx: mySpeed, dy: 0)
                xScale = -1.0
                break
            default:
                break
            }
        }
    }
    
    func configure(texture: SKTexture, 
                   hMode: Horizontal = .FULL,
                   vMode: Vertical = .TOP_TO_BOT,
                   minY: CGFloat = -100,
                   maxY: CGFloat = GameViewController.SCREEN_HEIGHT + 100,
                   verticalStep: CGFloat = 100,
                   mySpeed: CGFloat = GameViewController.SCREEN_HEIGHT
    ) {
        self.mySpeed = mySpeed
        horizontalMode = hMode
        verticalMode = vMode
        self.minY = minY
        self.maxY = maxY
        self.verticalStep = verticalStep
        body = SKSpriteNode(texture: texture)
        body.size = size
        backupPhysicBody = SKPhysicsBody(texture: body.texture!, size: body.size)
        backupPhysicBody?.categoryBitMask = GameViewController.CATEGORY_ENEMY
        name = "enemy_\(texture)"
        addChild(body)
        jet()
        backupPhysicBody?.linearDamping = 0
        backupPhysicBody?.angularDamping = 0
    
        move = verticalMode == .TOP_TO_BOT ? .TO_BOTTOM : .TO_TOP
        moveSource = CGPoint(x: position.x, y: position.y)
        moveDestination = CGPoint(x: position.x, y: position.y)
        
//        displayLink = CADisplayLink(target: self, selector: #selector(update))
//        displayLink.add(to: .main, forMode: .common)
//        backupPhysicBody = physicsBody
//        transform(isTransformIn: true)
    }
    
    override func removeFromParent() {
        super.removeFromParent()
        displayLink.invalidate()
        displayLink.remove(from: .main, forMode: .common)
    }
    
    func jet() {
        if let jet = SKEmitterNode(fileNamed: "enemy_jet") {
            jet.position.y = -(size.height / 3)
            jet.zPosition = body.zPosition + 1
            addChild(jet)
        }
    }
    
    func resetPosition(isRight: Bool) {
        position = moveSource
        moveDestination = moveSource
        move = verticalMode == .TOP_TO_BOT ? .TO_BOTTOM : .TO_TOP
        justActionX = isRight ? .TO_LEFT : .TO_RIGHT
        
        displayLink = CADisplayLink(target: self, selector: #selector(update))
        displayLink.add(to: .main, forMode: .common)
    }
    
    func transform(isTransformIn: Bool, speed: CGFloat = 1) {
        isTransformDone = false
        isWaiting = false
        physicsBody = nil
        if isTransformIn {
            run(SKAction.scale(to: 0, duration: 0))
            run(SKAction.scale(to: 1, duration: speed))
            run(SKAction.sequence([
                SKAction.fadeAlpha(to: 1.0, duration: speed),
                SKAction.run { [weak self] in
                    self?.physicsBody = self?.backupPhysicBody
                    self?.isTransformDone = true
                }
            ]))
        } else {
            run(SKAction.scale(to: 1.0, duration: 0))
            run(SKAction.scale(to: 0.0, duration: speed))
            run(SKAction.sequence([
                SKAction.fadeAlpha(to: 0.0, duration: speed),
                SKAction.run { [weak self] in
                    self?.isTransformDone = true
                    self?.isWaiting = true
                    self?.removeFromParent()
                }
            ]))
        }
    
    }
    
    deinit {
        print("ENEMY/FRIEND DEINIT")
    }
    
    private var lastSwing = Date().timeIntervalSince1970 * 1000
    private var swingInterval: Double = 300
    private var swingVelocity:CGFloat = 0
    @objc func update() {
//        print("HERE")
        if !isTransformDone {
            return
        }
        
        if isWaiting {
//            resetPosition()
//            transform(isTransformIn: true)
            return
        }
        
        if Date().timeIntervalSince1970 * 1000 >= lastSwing + swingInterval {
//            print("swingInterval")
            if swingVelocity == 0 {
                swingVelocity = GameViewController.SCREEN_HEIGHT / 39
            } else {
                swingVelocity = -swingVelocity
            }
            if move == .TO_LEFT || move == .TO_RIGHT {
                backupPhysicBody.velocity.dy = swingVelocity
            } else {
                backupPhysicBody.velocity.dx = swingVelocity
            }
            lastSwing = Date().timeIntervalSince1970 * 1000
        }
        
        if (position.y <= minY || position.y >= maxY) {
            transform(isTransformIn: false)
        }
        
        if move == ActionMove.TO_BOTTOM {
            if position.y <= moveDestination.y {
                if justActionX == ActionMove.TO_LEFT {
                    justActionX = ActionMove.TO_RIGHT
                    if horizontalMode == .FULL {
                        moveDestination = CGPoint(x: GameViewController.SCREEN_WIDTH, y: position.y)
                    } else if horizontalMode == .HALF_LEFT {
                        moveDestination = CGPoint(x: GameViewController.SCREEN_WIDTH * 1 / 3, y: position.y)
                    } else if horizontalMode == .HALF_RIGHT {
                        moveDestination = CGPoint(x: GameViewController.SCREEN_WIDTH, y: position.y)
                    }
                } else {
                    justActionX = ActionMove.TO_LEFT
                    if horizontalMode == .FULL {
                        moveDestination = CGPoint(x: 0, y: position.y)
                    } else if horizontalMode == .HALF_LEFT {
                        moveDestination = CGPoint(x: 0, y: position.y)
                    } else if horizontalMode == .HALF_RIGHT {
                        moveDestination = CGPoint(x: GameViewController.SCREEN_WIDTH * 2 / 3, y: position.y)
                    }
                }
                move = justActionX
            }
        }
        else if move == ActionMove.TO_TOP {
            if position.y >= moveDestination.y {
                if justActionX == ActionMove.TO_LEFT {
                    justActionX = ActionMove.TO_RIGHT
//                    moveDestination = CGPoint(x: GameViewController.SCREEN_WIDTH, y: position.y)
                    if horizontalMode == .FULL {
                        moveDestination = CGPoint(x: GameViewController.SCREEN_WIDTH, y: position.y)
                    } else if horizontalMode == .HALF_LEFT {
                        moveDestination = CGPoint(x: GameViewController.SCREEN_WIDTH * 1 / 3, y: position.y)
                    } else if horizontalMode == .HALF_RIGHT {
                        moveDestination = CGPoint(x: GameViewController.SCREEN_WIDTH, y: position.y)
                    }
                } else {
                    justActionX = ActionMove.TO_LEFT
//                    moveDestination = CGPoint(x: 0, y: position.y)
                    if horizontalMode == .FULL {
                        moveDestination = CGPoint(x: 0, y: position.y)
                    } else if horizontalMode == .HALF_LEFT {
                        moveDestination = CGPoint(x: 0, y: position.y)
                    } else if horizontalMode == .HALF_RIGHT {
                        moveDestination = CGPoint(x: GameViewController.SCREEN_WIDTH * 2 / 3, y: position.y)
                    }
                }
                move = justActionX
            }
        }
        else if move == ActionMove.TO_LEFT {
            if position.x <= moveDestination.x {
                justActionY = verticalMode == .TOP_TO_BOT ? .TO_BOTTOM : .TO_TOP
                let dy:CGFloat = verticalMode == .TOP_TO_BOT ? -verticalStep : verticalStep
                moveDestination = CGPoint(x: position.x, y: position.y + dy)
                move = justActionY
            }
        }
        else if move == ActionMove.TO_RIGHT {
            if position.x >= moveDestination.x {
                justActionY = verticalMode == .TOP_TO_BOT ? .TO_BOTTOM : .TO_TOP
                let dy:CGFloat = verticalMode == .TOP_TO_BOT ? -verticalStep : verticalStep
                moveDestination = CGPoint(x: position.x, y: position.y + dy)
                move = justActionY
            }
        }
    }
    
    enum ActionMove {
        case TO_LEFT
        case TO_RIGHT
        case TO_BOTTOM
        case TO_TOP
        case GEN
    }
    
    enum Horizontal {
        case FULL
        case HALF_RIGHT
        case HALF_LEFT
    }
    
    enum Vertical {
        case TOP_TO_BOT
        case BOT_TO_TOP
    }
}
