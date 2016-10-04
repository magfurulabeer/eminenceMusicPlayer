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
    var musicManager: MusicManager { get }
    var indexView: IndexView { get set }
    var selectedCell: IndexViewCell? { get set }
    var selectedIndexPath: IndexPath? { get set }

    func handleLongPress(sender: UILongPressGestureRecognizer)
    func handleLongPressPreviewing(sender: UILongPressGestureRecognizer, indexPath: IndexPath)
    func startPreviewingMusic(atIndexPath indexPath: IndexPath)
    func changePreviewingMusic(atIndexPath indexPath: IndexPath)
    func endPreviewingMusic()
    func selectedSongForPreview(indexPath: IndexPath) -> MPMediaItem
    func setQueue(indexPath:IndexPath)
    func setNewQueue(indexPath:IndexPath)
    func indexPathIsExcluded(indexPath: IndexPath?) -> Bool
    func displayPreviewing(state: UIGestureRecognizerState, indexPath: IndexPath)
    func revertVisuals()
    func prepareForChange()
}

extension Previewable {
    var musicManager: MusicManager {
        return MusicManager.sharedManager
    }
    
    func handleLongPress(sender: UILongPressGestureRecognizer) {
        let point = sender.location(in: indexView.view)
        let indexPath = indexView.indexPathForCell(at: point)
        
        guard indexPath != nil else {
            if musicManager.currentlyPreviewing && sender.state == .ended {
                musicManager.player.pause()
                endPreviewingMusic()
            }
            return
        }
        
        guard !indexPathIsExcluded(indexPath: indexPath!) else {
            if musicManager.currentlyPreviewing {
                musicManager.player.pause()
                endPreviewingMusic()
            }
            return
        }
                
        handleLongPressPreviewing(sender: sender, indexPath: indexPath!)
    }
    
    func handleLongPressPreviewing(sender: UILongPressGestureRecognizer, indexPath: IndexPath) {
        if sender.state == UIGestureRecognizerState.began {
            // Will be needed at the end
            musicManager.savedPlayerIsPlaying = musicManager.player.playbackState
            musicManager.player.pause()
            
            startPreviewingMusic(atIndexPath: indexPath)
        }
        if sender.state == UIGestureRecognizerState.changed {
            if indexPath != selectedIndexPath {
                prepareForChange()
                changePreviewingMusic(atIndexPath: indexPath)
            }
        }
        if sender.state == UIGestureRecognizerState.ended || sender.state == UIGestureRecognizerState.cancelled {
            musicManager.player.pause()
            endPreviewingMusic()
        }
    }

    func startPreviewingMusic(atIndexPath indexPath: IndexPath) {
        //This is needed if touch moves to another cell
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "PreviewingDidBegin"), object: nil)
        musicManager.currentlyPreviewing = true
        selectedIndexPath = indexPath
        
        // These will be needed when the touch ends
        musicManager.savedSong = musicManager.player.nowPlayingItem
        
        musicManager.savedTime = musicManager.player.currentPlaybackTime
        musicManager.savedRepeatMode = musicManager.player.repeatMode

        selectedCell = indexView.cell(atIndexPath: indexPath)

        // Visuals
        displayPreviewing(state: .began, indexPath: indexPath)
        
        // Audio
        let song = selectedSongForPreview(indexPath: indexPath)
        musicManager.player.shuffleMode = MPMusicShuffleMode.off
        musicManager.player.repeatMode = MPMusicRepeatMode.one // In case held till end of song
        musicManager.player = MPMusicPlayerController.systemMusicPlayer()
        
        setQueue(indexPath: indexPath)
        
        musicManager.player.nowPlayingItem = nil
        
        musicManager.itemNowPlaying = song
        musicManager.player.currentPlaybackTime = song.playbackDuration/2
    }

    func changePreviewingMusic(atIndexPath indexPath: IndexPath) {
        //This is needed if touch moves to another cell
        selectedIndexPath = indexPath

        selectedCell = indexView.cell(atIndexPath: indexPath)

        // Visuals
        displayPreviewing(state: .changed, indexPath: indexPath)
        
        musicManager.player.pause()
        
        setNewQueue(indexPath: indexPath)
        
        // Audio
        let song = selectedSongForPreview(indexPath: indexPath)
        musicManager.itemNowPlaying = song
        musicManager.player.currentPlaybackTime = song.playbackDuration/2
    }
    
    func endPreviewingMusic() {
        print("\n\nend\n\n")
        musicManager.player.pause()
        
        musicManager.currentlyPreviewing = false
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "PreviewingDidEnd"), object: nil)
        
        // Return visual to normal
        revertVisuals()
        
        // Return audio to normal
        musicManager.player = MPMusicPlayerController.systemMusicPlayer()
        if let currentQueue = musicManager.currentQueue {
            musicManager.player.setQueue(with: currentQueue)
        } else {
            // TODO: If you start the app and don't choose a song, there's no saved current queue
            // This means that there is no queue and can cause issues
            musicManager.player.setQueue(with: MPMediaItemCollection(items: musicManager.songList))
        }
        musicManager.player.beginGeneratingPlaybackNotifications()
        musicManager.player.stop()
        musicManager.player.nowPlayingItem = musicManager.savedSong
        musicManager.player.prepareToPlay()
        
        musicManager.player.shuffleMode = musicManager.shuffleIsOn ? .songs : .off
        musicManager.player.repeatMode = musicManager.savedRepeatMode ?? .none
        musicManager.player.currentPlaybackTime = musicManager.savedTime ?? 0
        
        if musicManager.savedPlayerIsPlaying?.rawValue == MPMusicPlaybackState.playing.rawValue {
            musicManager.player.play()
        } else if musicManager.savedPlayerIsPlaying?.rawValue == MPMusicPlaybackState.stopped.rawValue {
            musicManager.player.stop()
        } else if musicManager.savedPlayerIsPlaying?.rawValue == MPMusicPlaybackState.paused.rawValue {
            musicManager.player.pause()
        }
        
        // Release all saved properties
        musicManager.savedPlayerIsPlaying = nil
        musicManager.savedRepeatMode = nil
        musicManager.savedTime = nil
        musicManager.savedSong = nil
        selectedIndexPath = nil
        selectedCell = nil
        musicManager.savedPlayerIsPlaying = nil
    }
    
    func displayPreviewing(state: UIGestureRecognizerState, indexPath: IndexPath) {
        if state == .began {
            indexView.forEachVisibleCell { (indexCell) in
                indexCell.cell.alpha = 0.5
            }
        }
        
        selectedCell?.cell.backgroundColor = UIColor.black
        selectedCell?.cell.alpha = 1
    }
    
    func revertVisuals() {
        selectedCell?.cell.backgroundColor = UIColor.clear
        
        indexView.forEachVisibleCell { (indexCell) in
            indexCell.cell.alpha = 1
        }
    }
    
    func prepareForChange() {
        musicManager.player.pause()
        selectedCell?.cell.backgroundColor = UIColor.clear
        selectedCell?.cell.alpha = 0.5
        selectedCell?.contentBackgroundColor = UIColor.clear
    }
}
