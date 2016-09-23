//
//  SettingsViewController.swift
//  eminenceMusicPlayer
//
//  Created by Magfurul Abeer on 9/21/16.
//  Copyright © 2016 Magfurul Abeer. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    let menuBar: MenuBar = {
        let mb = MenuBar()
        mb.translatesAutoresizingMaskIntoConstraints = false
        return mb
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpMenuBar()
    }
    
    private func setUpMenuBar() {
        view.addSubview(menuBar)
        menuBar.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        menuBar.heightAnchor.constraint(equalToConstant: 70).isActive = true
        menuBar.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        menuBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    }
    

}
