//
//  MusicManager.swift
//  eminenceMusicPlayer
//
//  Created by Magfurul Abeer on 9/21/16.
//  Copyright © 2016 Magfurul Abeer. All rights reserved.
//

import UIKit
import MediaPlayer


// TODO: Consider changing shuffleIsOn's setter to actually change the music players shuffle setting
// TODO: See if refreshList() is necessary. Scrap if not.


/// This singleton manages the music, lists of media items, volume, etc.
class MusicManager: NSObject {
    
    
    
    // MARK: Properties
    
    
    
    /// This is the singleton shared instance.
    static let sharedManager = MusicManager()

    /// The audio player.
    var player: MPMusicPlayerController
    
    /// Whether or not shuffle is on.
    var shuffleIsOn: Bool
    
    /// A hidden UISlider representing the volume.
    var volume = MPVolumeView().volumeSlider
    
    /// Boolean representing whether the app is currently previewing a song.
    var currentlyPreviewing = false
    
    /// Boolean representing that the current queue is empty.
    var songListIsEmpty: Bool = false
    
    /// A collection of songs that acts as an on-the-fly playlist.
    var quickQueue = [MPMediaItem]()
    
    /// The current queue of songs playing.
    var currentQueue: MPMediaItemCollection?
    
    
    
    // MARK: Previewable Properties
    // These properties are relied upon by the Previewable Protocol.
    
    
    /// The song playing before previewing.
    var savedSong: MPMediaItem?
    
    /// The time the song was at before previewing.
    var savedTime: TimeInterval?
    
    /// What the repeat setting was before previewing. This is necessary because repeat is changed to Repeat-One while previewing so that 1-3 second audio clips repeat rather than go to another media item.
    var savedRepeatMode: MPMusicRepeatMode?
    
    /// Whether or not a song was playing before previewing.
    var savedPlayerIsPlaying: MPMusicPlaybackState?
    
    /// The active queue before previewing.
    var savedQueue: MPMediaItemCollection?

    /// The currect song. Setting it also plays the song if it's not nil.
    var itemNowPlaying: MPMediaItem? {
        get {
            return player.nowPlayingItem
        }
        set {
            player.nowPlayingItem = newValue
            if newValue != nil {
                player.prepareToPlay()
                player.play()
            } else {
                player.stop()
            }
        }
    }
    
    var playbackSpeed: Float {
        didSet {
            player.currentPlaybackRate = self.playbackSpeed
        }
    }
    
    
    
    /// Returns all the songs.
    var songList: [MPMediaItem] {
        get {
            var songItems = [MPMediaItem]()
            let songsQuery = MPMediaQuery.songs()
            
            guard let mediaItemCollections = songsQuery.collections else {
                songListIsEmpty = true
                return []
            }
            
            for collection in mediaItemCollections {
                for possibleSong in collection.items {
                    if possibleSong.mediaType == MPMediaType.music {
                        songItems.append(possibleSong)
                    }
                }
            }
            
            return songItems
        }
    }
    
    /// Returns artists as collections of songs.
    var artistList: [MPMediaItemCollection] {
        get {
            let artistsQuery = MPMediaQuery.artists()
            
            guard let artistCollections = artistsQuery.collections else {
                print("artistCollections is nil")
                songListIsEmpty = true
                return []
            }
            
            return artistCollections
        }
    }
    
    /// Returns albums as collections of songs.
    var albumList: [MPMediaItemCollection] {
        get {
            let albumQuery = MPMediaQuery.albums()
            
            guard let albumCollections = albumQuery.collections else {
                print("albumCollections is nil")
                songListIsEmpty = true
                return []
            }
            
            return albumCollections
        }
    }
    
    /// Returns playlists.
    var playlistList: [MPMediaPlaylist] {
        get {
            let playlistQuery = MPMediaQuery.playlists()
            
            guard let playlists = playlistQuery.collections else {
                print("playlistCollections is nil")
                songListIsEmpty = true
                return []
            }
            
            return playlists as! [MPMediaPlaylist]
        }
    }
    
    
    
    // MARK: Methods
    
    
    
    /**
     Initializes a new MusicManager. Made private because only the singleton sharedInstance method should call it.
     
     - Returns: A new MusicManager object with all of it's lists created. The player should be set to the system player and should start sending notifications. Shuffle is set to songs.
     */
    private override init() {
        // FIXME: 'self.songList' not initialized at super.init call  -- Find a better way to solve this
        self.player = MPMusicPlayerController.systemMusicPlayer()
        self.playbackSpeed = 1.0
        self.shuffleIsOn = player.shuffleMode == MPMusicShuffleMode.songs
        super.init()
        
        self.player.beginGeneratingPlaybackNotifications()
    }

}
