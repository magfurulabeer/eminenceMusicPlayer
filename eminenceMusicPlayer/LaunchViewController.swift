//
//  LaunchViewController.swift
//  eminenceMusicPlayer
//
//  Created by Magfurul Abeer on 9/25/16.
//  Copyright © 2016 Magfurul Abeer. All rights reserved.
//

import UIKit

/// This view controller simulates an extension of the LaunchScreen. It segues into the actual music player view controller once the songs are loaded
class LaunchViewController: UIViewController {
    
    
    
    // MARK: Properties
    
    
    
    /// Whether or not the view controller timed out
    var timedOut = false
    
    // Reference to MusicManager singleton's shared instance
    let musicManager = MusicManager.sharedManager
    
    // Use white text for status bar
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    
    // MARK: Methods
    
    
    
    /// Uses a while loop to attempt to get songs. If it gets the songs, it segues to the music player. If no songs after a certain time, an alert is shown.
    override func viewDidAppear(_ animated: Bool) {
        Timer.scheduledTimer(withTimeInterval: TimeOutDuration, repeats: false) { (timer) in
            self.timedOut = true
        }
        while musicManager.songList.count == 0 && !timedOut {
            musicManager.refreshList()
        }
        
        if timedOut {
            let controller = UIAlertController(title: "Timed Out", message: "Error: No songs were found. Did you allow access to your songs?", preferredStyle: UIAlertControllerStyle.alert)
            let ok = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil)
            controller.addAction(ok)
            present(controller, animated: true, completion: nil)
        } else {
            performSegue(withIdentifier: "StartAppSegue", sender: nil)
        }
    }


}
