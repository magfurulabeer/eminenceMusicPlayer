//
//  MediaAccessViewController.swift
//  eminenceMusicPlayer
//
//  Created by Magfurul Abeer on 1/18/17.
//  Copyright © 2017 Magfurul Abeer. All rights reserved.
//

import UIKit
import MediaPlayer

class MediaAccessViewController: UIViewController {

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black
    }

    override func viewDidAppear(_ animated: Bool) {
        if MPMediaLibrary.authorizationStatus() == MPMediaLibraryAuthorizationStatus.authorized {
            performSegue(withIdentifier: "GetSongsSegue", sender: nil)
        }
    }
}
