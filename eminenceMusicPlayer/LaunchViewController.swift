//
//  LaunchViewController.swift
//  eminenceMusicPlayer
//
//  Created by Magfurul Abeer on 9/25/16.
//  Copyright © 2016 Magfurul Abeer. All rights reserved.
//

import UIKit
import MediaPlayer

/// This view controller simulates an extension of the LaunchScreen. It segues into the actual music player view controller once the songs are loaded
class LaunchViewController: UIViewController {
    
    
    
    // MARK: Properties
    
    // Reference to MusicManager singleton's shared instance
    let musicManager = MusicManager.sharedManager
    
    // Use white text for status bar
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    
    // MARK: Methods
    
    
    
    /// Uses a while loop to attempt to get songs. If it gets the songs, it segues to the music player. If no songs after a certain time, an alert is shown.
    override func viewDidAppear(_ animated: Bool) {

        let _ = musicManager.songList // Asks for authorization on first launch
        while MPMediaLibrary.authorizationStatus() == .notDetermined  {}
        
        if MPMediaLibrary.authorizationStatus() == MPMediaLibraryAuthorizationStatus.authorized {
            performSegue(withIdentifier: "StartAppSegue", sender: nil)
        } else {
            performSegue(withIdentifier: "MediaAccessSegue", sender: nil)
        }
        

    }


}
