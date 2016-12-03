//
//  MenuViewController.swift
//  eminenceMusicPlayer
//
//  Created by Magfurul Abeer on 10/3/16.
//  Copyright © 2016 Magfurul Abeer. All rights reserved.
//

import UIKit

/// Base view controller for all view controllers that display songs
class MenuViewController: UIViewController {

    
    
    // MARK: Properties

    
    
    /// Reference to container MusicPlayerViewController.
    weak var viewController: UIViewController?
    
    /// Makes sure the index view doesn't go under the nav bar.
    final var topPadding = FauxBarHeight
    
    /// Makes sure the index view doesn't go under the quick bar.
    final var bottomPadding = -quickBarHeight
    
    /// To be overidden by subclasses to return the appropriate index view whether it be a tableview or collectionview.
    var storedIndexView: IndexView? {
        get {
            return UITableView()
        }
    }

    
    
    // MARK: Methods

    
    
    /**
     Whenever the view appears, it's index view gets reloaded.
     
     - Parameters:
     - sender: Activated long press gesture recognizer
     */
    override func viewDidAppear(_ animated: Bool) {
        storedIndexView!.reload()
    }

    
    /**
     Constrains the index view to take all the screen real estate between the faux navbar and the quickbar.
     */
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
