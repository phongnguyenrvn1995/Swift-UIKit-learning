//
//  SizeConsts.swift
//  Project-29
//
//  Created by Phong Nguyễn Hoàng on 21/01/2024.
//

import UIKit

class SizeConsts {
    public static let HEIGHT: Int = Int(UIScreen.main.bounds.height)
    public static let WIDTH: Int = Int(UIScreen.main.bounds.width)
    public static let PLAYER_SIZE: CGSize = CGSize(width: SizeConsts.HEIGHT / 10, height: SizeConsts.HEIGHT / 10)
    public static let BANANA_SIZE: CGSize = CGSize(width: SizeConsts.HEIGHT / 30, height: SizeConsts.HEIGHT / 30)
}
