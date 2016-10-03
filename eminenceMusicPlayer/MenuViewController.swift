//
//  MenuViewController.swift
//  eminenceMusicPlayer
//
//  Created by Magfurul Abeer on 10/3/16.
//  Copyright © 2016 Magfurul Abeer. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    var topPadding = FauxBarHeight
    var bottomPadding = -quickBarHeight
    var storedIndexView: IndexView? {
        get {
            return UITableView()
        }
    }
    var index: Int {
        get {
            return -5
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
//    
//    func setUpIndexView() {
////        guard let indexView = indexView as? indexViewType else { return }
//        
//        indexView.delegate = self
//        indexView.dataSource = self
//        indexView.backgroundColor = UIColor.clear
////        contentView.addSubview(indexView)
//        indexView.separatorStyle = UITableViewCellSeparatorStyle.none
//        
//        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.longPress(sender:)))
//        longPressGestureRecognizer.minimumPressDuration = 0.3
//        indexView.addGestureRecognizer(longPressGestureRecognizer)
//        
//        indexView.register(UINib(nibName: "SongCell", bundle: Bundle.main), forCellReuseIdentifier: "SongCell")
//        indexView.register(UINib(nibName: "SelectedSongCell", bundle: Bundle.main), forCellReuseIdentifier: "SelectedSongCell")
//        
//        
//        indexView.reloadData()
//    }
    
    func constrainIndexView() {
        guard let storedIndexView = storedIndexView as? UIView else { return }
        
        view.addSubview(storedIndexView)
        storedIndexView.translatesAutoresizingMaskIntoConstraints = false
        storedIndexView.topAnchor.constraint(equalTo: view.topAnchor, constant: topPadding).isActive = true
        storedIndexView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        storedIndexView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        storedIndexView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: bottomPadding).isActive = true
    }

}
