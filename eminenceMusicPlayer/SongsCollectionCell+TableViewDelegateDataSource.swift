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
    
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        let song = musicManager.songList[indexPath.row]
//        
//        guard let cell = cell as? SongCell else {
//            return
//        }
//        
//        if song == musicManager.itemNowPlaying {
//            cell.addGradient()
//        }
//    }
//    
//    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        guard let cell = cell as? SongCell else {
//            return
//        }
//        
//        cell.removeGradientIfApplicable()
//    }
    
    
    @objc(tableView:didSelectRowAtIndexPath:)
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        musicManager.player.shuffleMode = MPMusicShuffleMode.off
        musicManager.player.nowPlayingItem = musicManager.songList[indexPath.row]
        musicManager.player.play()
        //        performSegue(withIdentifier: "NowPlayingSegue", sender: nil)
        
        guard let viewController = viewController else {    return  }
        
        if let nowPlayingVC = viewController.storyboard!.instantiateViewController(withIdentifier: "NowPlayingViewController") as? NowPlayingViewController {
            nowPlayingVC.transitioningDelegate = self
            nowPlayingVC.interactor = slideDownInteractor
            viewController.present(nowPlayingVC, animated: true, completion: nil)
        }
    }
    
    @objc(tableView:heightForRowAtIndexPath:)
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return SongCellHeight
    }

}