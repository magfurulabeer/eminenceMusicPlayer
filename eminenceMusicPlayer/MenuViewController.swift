//
//  MenuViewController.swift
//  eminenceMusicPlayer
//
//  Created by Magfurul Abeer on 10/3/16.
//  Copyright © 2016 Magfurul Abeer. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    weak var viewController: UIViewController?
    final var topPadding = FauxBarHeight
    final var bottomPadding = -quickBarHeight
    var storedIndexView: IndexView? {
        get {
            return UITableView()
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        storedIndexView!.reload()
    }

    
    final func constrainIndexView() {
        guard let storedIndexView = storedIndexView as? UIView else { return }
        
        view.addSubview(storedIndexView)
        storedIndexView.translatesAutoresizingMaskIntoConstraints = false
        storedIndexView.topAnchor.constraint(equalTo: view.topAnchor, constant: topPadding).isActive = true
        storedIndexView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        storedIndexView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        storedIndexView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: bottomPadding).isActive = true
    }

}
