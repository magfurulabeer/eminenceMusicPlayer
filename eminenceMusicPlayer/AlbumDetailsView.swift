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

    
    var albumImageView = UIImageView(image: #imageLiteral(resourceName: "NoAlbumImage"))
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
        setUpImageView()
        setUpTableView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpImageView() {
        addSubview(albumImageView)
        albumImageView.translatesAutoresizingMaskIntoConstraints = false
        albumImageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        albumImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        albumImageView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        albumImageView.heightAnchor.constraint(equalTo: widthAnchor).isActive = true
        albumImageView.contentMode = .scaleAspectFill
        albumImageView.clipsToBounds = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(AlbumDetailsView.imageViewWasTapped))
        albumImageView.isUserInteractionEnabled = true
        albumImageView.addGestureRecognizer(tapGesture)
    }
    
    func imageViewWasTapped() {
        let superView = superview
        self.removeFromSuperview()
        superView?.layoutIfNeeded()
    }

    func setUpTableView() {
        addSubview(tableView)
        tableView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        tableView.register(UINib(nibName: "SongCell", bundle: Bundle.main), forCellReuseIdentifier: "SongCell")
        tableView.topAnchor.constraint(equalTo: albumImageView.bottomAnchor, constant: 0).isActive = true
        tableView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        tableView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return album?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let song = album?.items[indexPath.item] ?? nil
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        musicManager.player.pause()
        musicManager.player.shuffleMode = MPMusicShuffleMode.off
        
        let song = album?.items[indexPath.row]
        
        musicManager.player = MPMusicPlayerController.systemMusicPlayer()
        musicManager.player.setQueue(with: MPMediaItemCollection(items: album!.items))
        musicManager.player.beginGeneratingPlaybackNotifications()
        musicManager.player.stop()
        musicManager.player.nowPlayingItem = nil
        musicManager.itemNowPlaying = song

        
//        guard let viewController = viewController else {    return  }
        
//        if let nowPlayingVC = viewController.storyboard!.instantiateViewController(withIdentifier: "NowPlayingViewController") as? NowPlayingViewController {
//            nowPlayingVC.transitioningDelegate = self.viewController as! MusicPlayerViewController
//            nowPlayingVC.interactor = (self.viewController as! MusicPlayerViewController).slideDownInteractor
//            viewController.present(nowPlayingVC, animated: true, completion: nil)
//        }
    }


}
