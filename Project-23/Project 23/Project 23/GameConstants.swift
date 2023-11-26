//
//  GameConstants.swift
//  Project 23
//
//  Created by Phong Nguyễn Hoàng on 26/11/2023.
//

import UIKit

class GameConstants: NSObject {
    static let SCREEN_WIDTH: CGFloat = UIScreen.main.bounds.width
    static let SCREEN_HEIGHT: CGFloat = UIScreen.main.bounds.height
    
    static let ENEMY_SIZE = CGSize(width: GameConstants.SCREEN_WIDTH / 15, height: GameConstants.SCREEN_WIDTH / 15)
    static let ENEMY_MIN_RAND_POS = 64
    static let ENEMY_MAX_RAND_POS = Int(GameConstants.SCREEN_WIDTH)
    
    static let ENEMY_MIN_ANGULAR_X_VELOCITY = CGFloat(-3.0)
    static let ENEMY_MAX_ANGULAR_X_VELOCITY = CGFloat(-3.0)
    
    static let ENEMY_MIN_LOW_X_VELOCITY = Int(3)
    static let ENEMY_MAX_LOW_X_VELOCITY = Int(GameConstants.SCREEN_HEIGHT) / 120
    static let ENEMY_MIN_HIGH_X_VELOCITY = Int(4)
    static let ENEMY_MAX_HIGH_X_VELOCITY = Int(GameConstants.SCREEN_WIDTH) / 60
    
    static let ENEMY_MIN_Y_VELOCITY = Int(GameConstants.SCREEN_HEIGHT / 23)
    static let ENEMY_MAX_Y_VELOCITY = Int(GameConstants.SCREEN_HEIGHT / 18)
    
    static let NORMAL_MULTIPLE_CONST = Int(GameConstants.SCREEN_HEIGHT) / 8
}
