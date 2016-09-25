//
//  MusicViewController+TableViewDelegateDatasource.swift
//  eminenceMusicPlayer
//
//  Created by Magfurul Abeer on 9/21/16.
//  Copyright © 2016 Magfurul Abeer. All rights reserved.
//

import UIKit
import MediaPlayer

extension MusicViewController {
    
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
        
        let cell =  tableView.dequeueReusableCell(withIdentifier: "SongCell", for: indexPath) as! SongCell
        cell.titleLabel.text = song.title
        cell.artist = song.artist != nil ? song.artist! : ""
        cell.album = song.albumTitle != nil ? song.albumTitle! : ""
        cell.durationLabel.text = song.playbackDuration.stringFormat()
        cell.albumImage = song.artwork?.image(at: CGSize(width: SongCellHeight, height: SongCellHeight))
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        return cell
    }
    
    @objc(tableView:didSelectRowAtIndexPath:)
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        musicManager.player.shuffleMode = MPMusicShuffleMode.off
        musicManager.player.nowPlayingItem = musicManager.songList[indexPath.row]
        musicManager.player.play()
        performSegue(withIdentifier: "NowPlayingSegue", sender: nil)
    }
    
    @objc(tableView:heightForRowAtIndexPath:)
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return SongCellHeight
    }
}
