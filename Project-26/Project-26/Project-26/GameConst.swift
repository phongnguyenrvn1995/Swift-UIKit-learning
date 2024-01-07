//
//  GameConst.swift
//  Project-26
//
//  Created by Phong Nguyễn Hoàng on 26/12/2023.
//

import UIKit

class GameConst: NSObject {
    public static let UNIT_SIZE_WIDTH = GameViewController.SCREEN_WIDTH / 16
    public static let UNIT_SIZE_HEIGHT = GameViewController.SCREEN_HEIGHT / 12
    public static let UNIT_SIZE_GENERAL = min(UNIT_SIZE_WIDTH, UNIT_SIZE_HEIGHT)
}
