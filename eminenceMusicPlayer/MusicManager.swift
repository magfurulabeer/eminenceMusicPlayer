//
//  MusicManager.swift
//  eminenceMusicPlayer
//
//  Created by Magfurul Abeer on 9/21/16.
//  Copyright © 2016 Magfurul Abeer. All rights reserved.
//

import UIKit
import MediaPlayer

class MusicManager: NSObject {
    static let sharedManager = MusicManager()
    var songList: [MPMediaItem]
    var artistList: [MPMediaItemCollection]
    var player: MPMusicPlayerController
    var shuffleIsOn: Bool
    var volume = MPVolumeView().volumeSlider
    var currentlySampling = false
    var songListIsEmpty: Bool = false
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
    
    
    // When not authorized?
    var originalSongList: [MPMediaItem] {
        get {
            var songItems = [MPMediaItem]()
            let songsQuery = MPMediaQuery.songs()
            
            guard let mediaItemCollections = songsQuery.collections else {
                print("mediaItemCollections is nil")
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
    
    var originalArtistList: [MPMediaItemCollection] {
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
    
    override init() {
        self.songList = [MPMediaItem]()
        self.artistList = [MPMediaItemCollection]()
        self.player = MPMusicPlayerController.systemMusicPlayer()

        self.shuffleIsOn = player.shuffleMode == MPMusicShuffleMode.songs
        super.init()
        self.songList = self.originalSongList
        self.artistList = self.originalArtistList

        self.player.setQueue(with: MPMediaItemCollection(items: self.originalSongList))
        self.player.beginGeneratingPlaybackNotifications()

    }
    
    func refreshList() {
        self.songList = self.originalSongList
    }
}
