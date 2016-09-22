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
        
        let cell =  tableView.dequeueReusableCell(withIdentifier: "BasicCell", for: indexPath) as! BasicSongCell
        cell.titleLabel.text = song.title
        cell.artist = song.artist != nil ? song.artist! : ""
        cell.album = song.albumTitle != nil ? song.albumTitle! : ""
        cell.durationLabel.text = song.playbackDuration.stringFormat()
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        return cell
    }
    
    @objc(tableView:didSelectRowAtIndexPath:)
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        musicManager.player.shuffleMode = MPMusicShuffleMode.off
        musicManager.itemNowPlaying = musicManager.songList[indexPath.row]
        performSegue(withIdentifier: "NowPlayingSegue", sender: nil)
    }
}
