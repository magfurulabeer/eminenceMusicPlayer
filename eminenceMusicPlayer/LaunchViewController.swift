//
//  LaunchViewController.swift
//  eminenceMusicPlayer
//
//  Created by Magfurul Abeer on 9/25/16.
//  Copyright © 2016 Magfurul Abeer. All rights reserved.
//

import UIKit

class LaunchViewController: UIViewController {

    let musicManager = MusicManager.sharedManager
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        

        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // Headache. What am I doing? Fix this later
        while musicManager.songList.count == 0 {//&& !musicManager.songListIsEmpty {
            musicManager.refreshList()
        }
//        performSegue(withIdentifier: "StartAppSegue", sender: nil)
        performSegue(withIdentifier: "StartAppSegue", sender: nil)
    }


}
