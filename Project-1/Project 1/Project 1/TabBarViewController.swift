//
//  TabBarViewController.swift
//  Project 1
//
//  Created by Phong Nguyễn Hoàng on 29/07/2023.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.layer.cornerRadius = 50
        tabBar.layer.masksToBounds = true
        tabBar.isTranslucent = true
        tabBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        // Do any additional setup after loading the view.
    }
}
