//
//  Previewable.swift
//  eminenceMusicPlayer
//
//  Created by Magfurul Abeer on 10/2/16.
//  Copyright © 2016 Magfurul Abeer. All rights reserved.
//

import UIKit
import MediaPlayer

/// This protocol is for any class that ONLY needs it's displayed songs to be previewable. Holding onto the song should preview it. If it requires dragging as well, then the PreviewableDraggable protocol should be used instead.
protocol Previewable: class {
    
    
    
    // MARK: Properties
    
    
    
    /// Reference to the MusicManager singleton instance.
    var musicManager: MusicManager { get }
    
    /// ndex View (TableView or CollectionView) that needs it's items to be previewable.
    var indexView: IndexView { get set }
    
    /// Cell/Item being previewed.
    var selectedCell: IndexViewCell? { get set }
    
    /// Index path of the cell/item being previewed.
    var selectedIndexPath: IndexPath? { get set }

    
    
    // MARK: Methods
    
    
    
    /**
     Handles whether to end previewing or to continute to next handler
     
     - Parameters:
     - sender: Activated long press gesture recognizer
     */
    func handleLongPress(sender: UILongPressGestureRecognizer)
    
    
    /**
     Decides and prepares for whether to begin, change, or end previewing.
     
     - Parameters:
     - sender: Activated long press gesture recognizer
     - indexPath: IndexPath of the selected cell/item
     */
    func handleLongPressPreviewing(sender: UILongPressGestureRecognizer, indexPath: IndexPath)
    
    
    /**
     Starts previewing the song. Posts a PreviewingDidBegin notification.
     
     - Parameters:
     - indexPath: IndexPath of the selected cell/item
     */
    func startPreviewingMusic(atIndexPath indexPath: IndexPath)
    
    
    /**
     Changes the song being previewed.
     
     - Parameters:
     - indexPath: IndexPath of the selected cell/item
     */
    func changePreviewingMusic(atIndexPath indexPath: IndexPath)
    
    
    /**
     Ends previewing the song. Posts a PreviewingDidEnd notification.
     
     - Parameters:
     - indexPath: IndexPath of the selected cell/item
     */
    func endPreviewingMusic()
    
    
    /**
     Returns the Media Item that is about to be previewed.
     
     - Parameters:
     - indexPath: IndexPath of the selected cell/item
     
     - Returns: The Media Item that is about to be previewed
     */
    func selectedSongForPreview(indexPath: IndexPath) -> MPMediaItem
    
    
    /**
     Sets the queue for previewing. The queue would be unique to the Previewable object.
     
     - Parameters:
     - indexPath: IndexPath of the selected cell/item
     */
    func setQueue(indexPath:IndexPath)
    
    
    /**
     Sets a new queue when changing the previewing song. Depending on the Previewable object, can be empty.
     
     - Parameters:
     - indexPath: IndexPath of the selected cell/item
     */
    func setNewQueue(indexPath:IndexPath)
    
    
    /**
     Whether or not the given index path is nonpreviewable.
     
     - Parameters:
     - indexPath: IndexPath of the selected cell/item
     
     - Returns: Boolean representing whether or not the index path is exluded from previewing
     */
    func indexPathIsExcluded(indexPath: IndexPath?) -> Bool
    
    
    /**
     Displays visual changes to show which cell/item is being previewed
     
     - Parameters:
     - state: State of the activated long press gesture recognizer
     - indexPath: IndexPath of the selected cell/item
     */
    func displayPreviewing(state: UIGestureRecognizerState, indexPath: IndexPath)
    
    
    /**
     Go back to the visuals before previewing.
    */
    func revertVisuals()
    
    
    /**
     Any necessary actions before changing preview songs can be taken here
     */
    func prepareForChange()
}


/// This protocol contains the general template and defaults for handling Previewing.
extension Previewable {
    
    /// Reference to the MusicManager singleton instance.
    var musicManager: MusicManager {
        return MusicManager.sharedManager
    }
    
    /**
     Handles whether to end previewing or to continute to next handler
     
     - Parameters:
     - sender: Activated long press gesture recognizer
     */
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
    
    
    /**
     Decides and prepares for whether to begin, change, or end previewing.
     
     - Parameters:
     - sender: Activated long press gesture recognizer
     - indexPath: IndexPath of the selected cell/item
     */
    final func handleLongPressPreviewing(sender: UILongPressGestureRecognizer, indexPath: IndexPath) {
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

    
    /**
     Starts previewing the song. Posts a PreviewingDidBegin notification.
     
     - Parameters:
     - indexPath: IndexPath of the selected cell/item
     */
    final func startPreviewingMusic(atIndexPath indexPath: IndexPath) {
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
        musicManager.itemNowPlaying = song
        musicManager.player.currentPlaybackTime = song.playbackDuration/2
    }

    
    /**
     Changes the song being previewed.
     
     - Parameters:
     - indexPath: IndexPath of the selected cell/item
     */
    final func changePreviewingMusic(atIndexPath indexPath: IndexPath) {
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
    
    
    /**
      Ends previewing the song. Posts a PreviewingDidEnd notification.
     
     - Parameters:
     - indexPath: IndexPath of the selected cell/item
     */
    final func endPreviewingMusic() {
        musicManager.player.pause()  // Prevents abrupt playing when changing songs
        musicManager.currentlyPreviewing = false
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "PreviewingDidEnd"), object: nil)
        
        revertVisuals()
        revertPlayer()
        releaseSavedProperties()
    }
    
    
    
    // MARK: Helper Methods
    
    
    
    /**
     Set all audio players settings back to pre-previewing settings.
     */
    final func revertPlayer() {
        musicManager.player.shuffleMode = musicManager.shuffleIsOn ? .songs : .off
        musicManager.player.repeatMode = musicManager.savedRepeatMode ?? .none
        musicManager.player = MPMusicPlayerController.systemMusicPlayer()
        if let savedSong = musicManager.savedSong {
            let currentQueue = musicManager.currentQueue ?? MPMediaItemCollection(items: [savedSong])
            musicManager.player.setQueue(with: currentQueue)
        } else {
            musicManager.player.setQueue(with: MPMediaItemCollection(items: []))
        }
        
        musicManager.player.beginGeneratingPlaybackNotifications()
        musicManager.player.stop()
        musicManager.player.nowPlayingItem = nil
        
        musicManager.player.nowPlayingItem = musicManager.savedSong
        musicManager.player.currentPlaybackTime = musicManager.savedTime ?? 0
        musicManager.player.prepareToPlay()
        
        if musicManager.savedPlayerIsPlaying?.rawValue == MPMusicPlaybackState.playing.rawValue {
            musicManager.player.play()
        }else {
            musicManager.player.pause()
        }
    }
    
    
    /**
     Set all saved properties to nil
     */
    final func releaseSavedProperties() {
        musicManager.savedPlayerIsPlaying = nil
        musicManager.savedRepeatMode = nil
        musicManager.savedTime = nil
        //        musicManager.savedSong = nil
        selectedIndexPath = nil
        selectedCell = nil
        musicManager.savedPlayerIsPlaying = nil
    }
    
    
    /**
     Ends previewing the song. Posts a PreviewingDidEnd notification.
     
     - Parameters:
     - state: State of the activated long press gesture recognizer
     - indexPath: IndexPath of the selected cell/item
     */
    func displayPreviewing(state: UIGestureRecognizerState, indexPath: IndexPath) {
        if state == .began {
            indexView.forEachVisibleCell { (indexCell) in
                indexCell.cell.alpha = 0.5
            }
        }
        
        selectedCell?.cell.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        selectedCell?.cell.alpha = 1
    }
    
    
    /**
     Go back to the visuals before previewing.
     */
    func revertVisuals() {
        selectedCell?.cell.backgroundColor = UIColor.clear
        
        indexView.forEachVisibleCell { (indexCell) in
            indexCell.cell.alpha = 1
        }
    }
    
    
    /**
     Any necessary actions before changing preview songs can be taken here
     */
    func prepareForChange() {
        musicManager.player.pause()
        selectedCell?.cell.backgroundColor = UIColor.clear
        selectedCell?.cell.alpha = 0.5
        selectedCell?.contentBackgroundColor = UIColor.clear
    }
}
