//
//  OpenTabBarController.swift
//  eminenceMusicPlayer
//
//  Created by Magfurul Abeer on 9/22/16.
//  Copyright © 2016 Magfurul Abeer. All rights reserved.
//

import UIKit

class OpenTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.backgroundImage = UIImage()
        self.tabBar.backgroundColor = QuickBarBackgroundColor
        self.tabBar.shadowImage = UIImage()
        self.tabBar.layer.zPosition = 0
        self.tabBar.tintColor = UIColor.blue
        UITabBar.appearance().barTintColor = QuickBarBackgroundColor
        UITabBar.appearance().tintColor = UIColor.white
    }

}
