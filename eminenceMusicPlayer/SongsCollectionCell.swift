//
//  SongsCollectionCell.swift
//  eminenceMusicPlayer
//
//  Created by Magfurul Abeer on 9/26/16.
//  Copyright © 2016 Magfurul Abeer. All rights reserved.
//

import UIKit
import MediaPlayer

class SongsCollectionCell: UICollectionViewCell {
    
    var musicManager = MusicManager.sharedManager
    weak var viewController: UIViewController?
    var tableView: UITableView = UITableView()
    let slideDownInteractor = SlideDownInteractor()

    /////// SAMPLING PROPERTIES ////////
    var selectedCell: UITableViewCell?
    var selectedIndexPath: IndexPath?
    var savedSong: MPMediaItem?
    var savedTime: TimeInterval?
    var savedRepeatMode: MPMusicRepeatMode?
    var savedPlayerIsPlaying: MPMusicPlaybackState?
    ///////////////////////////////////
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpTableView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.clear
        contentView.addSubview(tableView)
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongPress(sender:)))
        tableView.addGestureRecognizer(longPressGestureRecognizer)
        tableView.register(UINib(nibName: "SongCell", bundle: Bundle.main), forCellReuseIdentifier: "SongCell")
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        tableView.reloadData()
    }
}
