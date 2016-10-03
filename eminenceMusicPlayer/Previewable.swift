//
//  Previewable.swift
//  eminenceMusicPlayer
//
//  Created by Magfurul Abeer on 10/2/16.
//  Copyright © 2016 Magfurul Abeer. All rights reserved.
//

import UIKit
import MediaPlayer

protocol Previewable: class {
//    var musicManager: MusicManager { get }
    var indexView: IndexView { get set }
    var selectedCell: IndexViewCell? { get set }
    var selectedIndexPath: IndexPath? { get set }
    var savedSong: MPMediaItem? { get set }
    var savedTime: TimeInterval? { get set }
    var savedRepeatMode: MPMusicRepeatMode? { get set }
    var savedPlayerIsPlaying: MPMusicPlaybackState? { get set }
    var cellSnapshot: UIView? { get set }
    var initialIndexPath: IndexPath? { get set }

    func handleLongPress(sender: UILongPressGestureRecognizer)
    func handleLongPressSampling(sender: UILongPressGestureRecognizer, indexPath: IndexPath)
    func startSamplingMusic(atIndexPath indexPath: IndexPath)
    func changeSamplingMusic(atIndexPath indexPath: IndexPath)
    func endSamplingMusic()
    func selectedSongForPreview(indexPath: IndexPath) -> MPMediaItem
}

extension Previewable {
    var musicManager: MusicManager {
        return MusicManager.sharedManager
    }
    
    func handleLongPress(sender: UILongPressGestureRecognizer) {
        let point = sender.location(in: indexView.view)
        let indexPath = indexView.indexPathForCell(at: point)
        
        handleLongPressSampling(sender: sender, indexPath: indexPath!)
    }
    
    func handleLongPressSampling(sender: UILongPressGestureRecognizer, indexPath: IndexPath) {
        if sender.state == UIGestureRecognizerState.began {
            // Will be needed at the end
            savedPlayerIsPlaying = musicManager.player.playbackState
            musicManager.player.pause()
            
            startSamplingMusic(atIndexPath: indexPath)
        }
        if sender.state == UIGestureRecognizerState.changed {
            if indexPath != selectedIndexPath {
                musicManager.player.pause()
                selectedCell?.cell.backgroundColor = UIColor.clear
                selectedCell?.cell.alpha = 0.5
                selectedCell?.contentBackgroundColor = UIColor.clear
                changeSamplingMusic(atIndexPath: indexPath)
            }
        }
        if sender.state == UIGestureRecognizerState.ended || sender.state == UIGestureRecognizerState.cancelled {
            musicManager.player.pause()
            endSamplingMusic()
        }
    }

    func startSamplingMusic(atIndexPath indexPath: IndexPath) {
        //This is needed if touch moves to another cell
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SamplingDidBegin"), object: nil)
        musicManager.currentlySampling = true
        selectedIndexPath = indexPath
        
        // These will be needed when the touch ends
        savedSong = musicManager.player.nowPlayingItem
        
        savedTime = musicManager.player.currentPlaybackTime
        savedRepeatMode = musicManager.player.repeatMode
        
        // Visuals
        selectedCell = indexView.cell(atIndexPath: indexPath)
        selectedCell?.cell.backgroundColor = UIColor.black
        
        indexView.forEachVisibleCell { (indexCell) in
            indexCell.cell.alpha = 0.5
        }
        
        // Audio
//        let song = musicManager.songList[indexPath.row]
        let song = selectedSongForPreview(indexPath: indexPath)
        ////// CHANGE ABOVE LINE TO FUNCTION CALL //////
        musicManager.player.shuffleMode = MPMusicShuffleMode.off
        musicManager.player.repeatMode = MPMusicRepeatMode.one // In case held till end of song
        musicManager.player = MPMusicPlayerController.systemMusicPlayer()
        musicManager.player.setQueue(with: MPMediaItemCollection(items: musicManager.originalSongList))
        musicManager.player.beginGeneratingPlaybackNotifications()
        musicManager.player.stop()
        musicManager.player.nowPlayingItem = nil
        
        musicManager.itemNowPlaying = musicManager.songList[indexPath.row]
        musicManager.player.currentPlaybackTime = song.playbackDuration/2
    }

    func changeSamplingMusic(atIndexPath indexPath: IndexPath) {
        //This is needed if touch moves to another cell
        selectedIndexPath = indexPath
        
        // Visuals
        selectedCell = indexView.cell(atIndexPath: indexPath)
        selectedCell?.cell.backgroundColor = UIColor.black
        selectedCell?.cell.alpha = 1
        
        // Audio
        let song = musicManager.songList[indexPath.row]
        musicManager.itemNowPlaying = musicManager.songList[indexPath.row]
        musicManager.player.currentPlaybackTime = song.playbackDuration/2
    }
    
    func endSamplingMusic() {
        musicManager.player.pause()
        
        musicManager.currentlySampling = false
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SamplingDidEnd"), object: nil)
        // Return visual to normal
        selectedCell?.cell.backgroundColor = UIColor.clear
        
        indexView.forEachVisibleCell { (indexCell) in
            indexCell.cell.alpha = 1
        }
        
        // Return audio to normal
        musicManager.player.nowPlayingItem = savedSong
        musicManager.player.prepareToPlay()
        
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
