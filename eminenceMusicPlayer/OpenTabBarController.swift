//
//  OpenTabBarController.swift
//  eminenceMusicPlayer
//
//  Created by Magfurul Abeer on 9/22/16.
//  Copyright © 2016 Magfurul Abeer. All rights reserved.
//

import UIKit

class OpenTabBarController: UITabBarController {

    var quickBar: NowPlayingQuickBar?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.backgroundImage = UIImage()
        self.tabBar.backgroundColor = QuickBarBackgroundColor
        self.tabBar.shadowImage = UIImage()
        self.tabBar.layer.zPosition = 0
        UITabBar.appearance().barTintColor = QuickBarBackgroundColor //UIColor(red: 27/255.0, green: 28/255.0, blue: 43/255.0, alpha: 0)
        UITabBar.appearance().tintColor = UIColor.white
    }

}
