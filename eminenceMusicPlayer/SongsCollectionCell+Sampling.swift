//
//  SongsCollectionCell+Sampling.swift
//  eminenceMusicPlayer
//
//  Created by Magfurul Abeer on 9/26/16.
//  Copyright © 2016 Magfurul Abeer. All rights reserved.
//

import MediaPlayer
import UIKit

extension SongsCollectionCell {
    func handleLongPress(sender: UILongPressGestureRecognizer) {
        if sender.state == UIGestureRecognizerState.began {
            // Will be needed at the end
            savedPlayerIsPlaying = musicManager.player.playbackState
            musicManager.player.pause()
            let point = sender.location(in: tableView)
            let indexPath = tableView.indexPathForRow(at: point)!
            startSamplingMusic(atIndexPath: indexPath)
        }
        if sender.state == UIGestureRecognizerState.changed {
            let point = sender.location(in: tableView)
            let indexPath = tableView.indexPathForRow(at: point)!
            if indexPath != selectedIndexPath {
                musicManager.player.pause()
                selectedCell?.backgroundColor = UIColor.clear
                selectedCell?.alpha = 0.5
                selectedCell?.contentView.backgroundColor = UIColor.clear
                changeSamplingMusic(atIndexPath: indexPath)
            }
        }
        if sender.state == UIGestureRecognizerState.ended || sender.state == UIGestureRecognizerState.cancelled {
            musicManager.player.pause()
            endSamplingMusic()
        }
        
    }
    
    func startSamplingMusic(atIndexPath indexPath: IndexPath) {
        print("start")

        //This is needed if touch moves to another cell
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SamplingDidBegin"), object: nil)
        musicManager.currentlySampling = true
        selectedIndexPath = indexPath
        print("Row is \(indexPath.row)")
        print(musicManager.songList[indexPath.row].title)
        
        // These will be needed when the touch ends
        savedSong = musicManager.player.nowPlayingItem

//        print(savedSong?.title)
        savedTime = musicManager.player.currentPlaybackTime
        savedRepeatMode = musicManager.player.repeatMode
        
        // Visuals
        selectedCell = tableView.cellForRow(at: indexPath)
        selectedCell?.backgroundColor = UIColor.black
        
        for cell in tableView.visibleCells {
            if cell != selectedCell {
                cell.alpha = 0.5
            }
        }
        
        // Audio
        let song = musicManager.songList[indexPath.row]
        print("song title is \(song.title)")
        musicManager.player.shuffleMode = MPMusicShuffleMode.off
        musicManager.player.repeatMode = MPMusicRepeatMode.one // In case held till end of song
        musicManager.player = MPMusicPlayerController.systemMusicPlayer()

        musicManager.player.nowPlayingItem = song
        musicManager.player.prepareToPlay()
        musicManager.player.currentPlaybackTime = song.playbackDuration/2
        musicManager.player.play()
        print("what's actually playing is \(musicManager.player.nowPlayingItem?.title)")
        print("song title is \(song.title)")
    }
    
    func changeSamplingMusic(atIndexPath indexPath: IndexPath) {
        print("change")

        //This is needed if touch moves to another cell
        selectedIndexPath = indexPath
        
        // Visuals
        selectedCell = tableView.cellForRow(at: indexPath)
        selectedCell?.backgroundColor = UIColor.black
        selectedCell?.alpha = 1
        
        // Audio
        let song = musicManager.songList[indexPath.row]
        musicManager.player.nowPlayingItem = song
        musicManager.player.currentPlaybackTime = song.playbackDuration/2
        musicManager.player.prepareToPlay()
        musicManager.player.play()
    }
    
    func endSamplingMusic() {
        print("end")
        musicManager.player.pause()

        musicManager.currentlySampling = false
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SamplingDidEnd"), object: nil)
        // Return visual to normal
        selectedCell?.backgroundColor = UIColor.clear
        
        for cell in tableView.visibleCells {
            cell.alpha = 1
        }
        
        // Return audio to normal
        musicManager.itemNowPlaying = savedSong
        musicManager.player.prepareToPlay()
        musicManager.player.nowPlayingItem = savedSong
        musicManager.player.shuffleMode = musicManager.shuffleIsOn ? .songs : .off
        musicManager.player.repeatMode = savedRepeatMode!
        musicManager.player.currentPlaybackTime = savedTime!
        
        if savedPlayerIsPlaying?.rawValue == MPMusicPlaybackState.playing.rawValue {
            musicManager.player.play()
        } else if savedPlayerIsPlaying?.rawValue == MPMusicPlaybackState.stopped.rawValue {
            musicManager.player.stop()
        } else if savedPlayerIsPlaying?.rawValue == MPMusicPlaybackState.paused.rawValue {
            musicManager.player.pause()
        }
        
        // Release all saved properties
        savedPlayerIsPlaying = nil
        savedRepeatMode = nil
        savedTime = nil
        savedSong = nil
        selectedIndexPath = nil
        selectedCell = nil
        savedPlayerIsPlaying = nil
    }

}
