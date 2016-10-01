//
//  AlbumDetailsView.swift
//  eminenceMusicPlayer
//
//  Created by Magfurul Abeer on 9/30/16.
//  Copyright © 2016 Magfurul Abeer. All rights reserved.
//

import UIKit
import MediaPlayer

class AlbumDetailsView: UIView , UITableViewDataSource, UITableViewDelegate {

    let musicManager = MusicManager.sharedManager
    var album: MPMediaItemCollection?
    weak var viewController: UIViewController?

    lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = UIColor.clear
        tv.delegate = self
        tv.dataSource = self
        return tv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.black.withAlphaComponent(0.3)
        setUpTableView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setUpTableView() {
        addSubview(tableView)
        tableView.register(UINib(nibName: "SongCell", bundle: Bundle.main), forCellReuseIdentifier: "SongCell")
        tableView.register(UINib(nibName: "AlbumImageCell", bundle: Bundle.main), forCellReuseIdentifier: "AlbumImageCell")
        
        tableView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (album?.count ?? 0) + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AlbumImageCell", for: indexPath) as! AlbumImageCell
            let width = viewController?.view.frame.width ?? 0
            cell.albumImageView.image = album?.representativeItem?.artwork?.image(at: CGSize(width: width, height: width)) ?? #imageLiteral(resourceName: "NoAlbumImage")
            return cell
        } else {
            let song = album?.items[indexPath.item - 1]
            let cell = tableView.dequeueReusableCell(withIdentifier: "SongCell", for: indexPath) as! SongCell
            cell.titleLabel.text = song?.title ?? "Unknown name"
            cell.artist = song?.artist ?? ""
            cell.album = song?.albumTitle! ?? ""
            cell.durationLabel.text = song?.playbackDuration.stringFormat() ?? ""
            cell.albumImage = song?.artwork?.image(at: CGSize(width: SongCellHeight, height: SongCellHeight)) ?? #imageLiteral(resourceName: "NoAlbumImage")
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            cell.backgroundColor = UIColor.black.withAlphaComponent(0.8)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let superView = superview
            self.removeFromSuperview()
            superView?.layoutIfNeeded()
        } else {
            musicManager.player.pause()
            musicManager.player.shuffleMode = MPMusicShuffleMode.off
            
            let song = album?.items[indexPath.row - 1]
            
            musicManager.player = MPMusicPlayerController.systemMusicPlayer()
            musicManager.player.setQueue(with: MPMediaItemCollection(items: album!.items))
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            let width = viewController?.view.frame.width ?? 0
            return width
        }
        return SongCellHeight * 0.8
    }


}
