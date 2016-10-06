//
//  QuickQueueCell.swift
//  eminenceMusicPlayer
//
//  Created by Magfurul Abeer on 9/30/16.
//  Copyright © 2016 Magfurul Abeer. All rights reserved.
//

import UIKit
import MediaPlayer

class QuickQueueCell: UITableViewCell, UITableViewDataSource, UITableViewDelegate {

    var tableView: UITableView = UITableView()
    let musicManager = MusicManager.sharedManager
    weak var viewController: UIViewController?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor.clear
        setUpTableView()
        NotificationCenter.default.addObserver(self, selector: #selector(self.queueWasChanged), name: NSNotification.Name(rawValue: "AddedToQueue"), object: nil)
        
    }
    
    func queueWasChanged() {
        self.tableView.reloadData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        contentView.addSubview(tableView)
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        tableView.bounces = false
        tableView.register(UINib(nibName: "SongCell", bundle: Bundle.main), forCellReuseIdentifier: "SongCell")
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        tableView.reloadData()
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return musicManager.quickQueue.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let song = musicManager.quickQueue[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "SongCell", for: indexPath) as! SongCell
        cell.titleLabel.text = song.title
        cell.artist = song.artist != nil ? song.artist! : ""
        cell.album = song.albumTitle != nil ? song.albumTitle! : ""
        cell.durationLabel.text = song.playbackDuration.stringFormat()
        cell.albumImage = song.artwork?.image(at: CGSize(width: SongCellHeight, height: SongCellHeight))
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        musicManager.player.pause()
        musicManager.player.shuffleMode = MPMusicShuffleMode.off
        let song = musicManager.quickQueue[indexPath.row]

        musicManager.player = MPMusicPlayerController.systemMusicPlayer()
        musicManager.player.setQueue(with: MPMediaItemCollection(items: musicManager.quickQueue))
        musicManager.player.beginGeneratingPlaybackNotifications()
        musicManager.player.stop()
        musicManager.player.nowPlayingItem = nil
        musicManager.itemNowPlaying = song
        
        guard let viewController = viewController else {    return  }
        
        if let nowPlayingVC = viewController.storyboard!.instantiateViewController(withIdentifier: "NowPlayingViewController") as? NowPlayingViewController {
            nowPlayingVC.transitioningDelegate = self.viewController as! MusicPlayerViewController
            nowPlayingVC.interactor = (self.viewController as! MusicPlayerViewController).slideDownInteractor
            viewController.present(nowPlayingVC, animated: true, completion: nil)
        }
    }
}
