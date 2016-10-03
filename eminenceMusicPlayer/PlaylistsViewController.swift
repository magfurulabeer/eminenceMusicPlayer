//
//  PlaylistsViewController.swift
//  eminenceMusicPlayer
//
//  Created by Magfurul Abeer on 10/3/16.
//  Copyright © 2016 Magfurul Abeer. All rights reserved.
//

import UIKit
import MediaPlayer

class PlaylistsViewController: MenuViewController, UITableViewDelegate, UITableViewDataSource {

    
    // MARK: Properties
    
    let musicManager = MusicManager.sharedManager
    var indexView: IndexView = UITableView(frame: .zero, style: .grouped)
    override var storedIndexView: IndexView? {  get { return indexView }    }
    
    
    // MARK: View Management Method

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.clear
        setUpIndexView()
    }
    
    
    // MARK: Setup Methods

    func setUpIndexView() {
        guard let indexView = indexView as? UITableView else { return }
        
//        tableView.frame = frame
        indexView.delegate = self
        indexView.dataSource = self
        indexView.backgroundColor = UIColor.clear
        indexView.separatorStyle = UITableViewCellSeparatorStyle.none
        
        //        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.longPress(sender:)))
        //        longPressGestureRecognizer.minimumPressDuration = 0.3
        //        indexView.addGestureRecognizer(longPressGestureRecognizer)
        
        indexView.register(QuickQueueCell.self, forCellReuseIdentifier: "QuickQueueCell")
        indexView.register(UINib(nibName: "BasicCell", bundle: Bundle.main), forCellReuseIdentifier: "BasicCell")
        
        constrainIndexView()
        
        indexView.reloadData()
    }
    
    // MARK: UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return musicManager.originalPlaylistList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "QuickQueueCell", for: indexPath)
            return cell
        } else {
            let playlist = musicManager.playlistList[indexPath.row]
            
            let cell =  tableView.dequeueReusableCell(withIdentifier: "BasicCell", for: indexPath) as! BasicCell
            //            cell.backgroundColor = UIColor.white.withAlphaComponent(0.5)
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            cell.backgroundColor = UIColor.clear
            cell.textLabel?.text = playlist.value(forProperty: MPMediaPlaylistPropertyName) as? String
            cell.detailTextLabel?.text = "\(playlist.count)"
            return cell
        }
    }
    
    // MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return view.frame.height/2 - FauxBarHeight - quickBarHeight
        } else {
            return SongCellHeight
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Quick Queue"
        }
        return "Playlists"
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else {
            return
        }
        header.backgroundView?.backgroundColor = UIColor.clear
        header.textLabel?.textColor = UIColor.white
        header.textLabel?.font = UIFont(name: "Avenir", size: 25)

    }
}
