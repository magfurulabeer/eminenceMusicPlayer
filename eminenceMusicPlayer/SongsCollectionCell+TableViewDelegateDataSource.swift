//
//  SongsCollectionCell+TableViewDelegateDataSource.swift
//  eminenceMusicPlayer
//
//  Created by Magfurul Abeer on 9/26/16.
//  Copyright © 2016 Magfurul Abeer. All rights reserved.
//

import UIKit
import MediaPlayer

extension SongsCollectionCell: UITableViewDelegate, UITableViewDataSource {
    @objc(numberOfSectionsInTableView:)
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return musicManager.songList.count
        
    }
    
    @objc(tableView:cellForRowAtIndexPath:)
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let song = musicManager.songList[indexPath.row]
        
        if song == musicManager.itemNowPlaying {
            let cell =  tableView.dequeueReusableCell(withIdentifier: "SelectedSongCell", for: indexPath) as! SelectedSongCell
            cell.titleLabel.text = song.title
            cell.artist = song.artist != nil ? song.artist! : ""
            cell.album = song.albumTitle != nil ? song.albumTitle! : ""
            cell.durationLabel.text = song.playbackDuration.stringFormat()
            cell.albumImage = song.artwork?.image(at: CGSize(width: SongCellHeight, height: SongCellHeight))
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            cell.addGradient()
            return cell
        } else {
            let cell =  tableView.dequeueReusableCell(withIdentifier: "SongCell", for: indexPath) as! SongCell
            cell.titleLabel.text = song.title
            cell.artist = song.artist != nil ? song.artist! : ""
            cell.album = song.albumTitle != nil ? song.albumTitle! : ""
            cell.durationLabel.text = song.playbackDuration.stringFormat()
            cell.albumImage = song.artwork?.image(at: CGSize(width: SongCellHeight, height: SongCellHeight))
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            return cell
        }
        
    }
    
    
    @objc(tableView:didSelectRowAtIndexPath:)
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let song = musicManager.songList[indexPath.row]
        
        print(song.artwork != nil)
        musicManager.player = MPMusicPlayerController.systemMusicPlayer()
        musicManager.player.setQueue(with: MPMediaItemCollection(items: musicManager.originalSongList))
        musicManager.player.beginGeneratingPlaybackNotifications()
        musicManager.player.stop()
        musicManager.player.nowPlayingItem = nil
        musicManager.itemNowPlaying = musicManager.songList[indexPath.row]
        
        guard let viewController = viewController else {    return  }
        
        if let nowPlayingVC = viewController.storyboard!.instantiateViewController(withIdentifier: "NowPlayingViewController") as? NowPlayingViewController {
            nowPlayingVC.transitioningDelegate = self.viewController as! MusicPlayerViewController
            nowPlayingVC.interactor = (self.viewController as! MusicPlayerViewController).slideDownInteractor
            viewController.present(nowPlayingVC, animated: true, completion: nil)
        }
    }
    
    @objc(tableView:heightForRowAtIndexPath:)
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return SongCellHeight
    }

}
