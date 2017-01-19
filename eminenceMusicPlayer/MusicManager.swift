//
//  MusicManager.swift
//  eminenceMusicPlayer
//
//  Created by Magfurul Abeer on 9/21/16.
//  Copyright © 2016 Magfurul Abeer. All rights reserved.
//

import UIKit
import MediaPlayer
import CoreData

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
    
    /// Returns playlists including playlists from core data
    var playlistList: [MPMediaPlaylist] {
        get {
            let playlistQuery = MPMediaQuery.playlists()
            
            guard let playlists = playlistQuery.collections else {
                print("playlistCollections is nil")
                songListIsEmpty = true
                return savedPlaylists
            }
            
            let list: [MPMediaPlaylist] = playlists as! [MPMediaPlaylist] + savedPlaylists
            
            return list
        }
    }
    
    
    var savedPlaylists: [MPMediaPlaylist] {
        get {
            var userMadePlaylists = [MPMediaPlaylist]()
            
            let playlistsFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "EMMediaPlaylist")
            
            do {
                let fetchedPlaylists = try persistentContainer.viewContext.fetch(playlistsFetchRequest) as! [EMMediaPlaylist]
                for playlist in fetchedPlaylists {
                    userMadePlaylists.append(playlist.playlist())
                }
                
            } catch {
                fatalError("Failed to fetch employees: \(error)")
            }

            return userMadePlaylists
        }
    }
    
    
    // MARK: Methods
    
    
    
    /**
     Initializes a new MusicManager. Made private because only the singleton sharedInstance method should call it.
     
     - Returns: A new MusicManager object with all of it's lists created. The player should be set to the system player and should start sending notifications. Shuffle is set to songs.
     */
    private override init() {
        self.player = MPMusicPlayerController.systemMusicPlayer()
        self.playbackSpeed = 1.0
        self.shuffleIsOn = player.shuffleMode == MPMusicShuffleMode.songs
        super.init()
        
        // This is for when a core data mistake is made by the developer
//        deleteContextData()
        self.player.beginGeneratingPlaybackNotifications()
    }
    
    
    
    // MARK: - Core Data stack
    
    
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "DataModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    
    
    // MARK: - Core Data Saving support
    
    
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    
    func deleteContextData() {
        let context = persistentContainer.viewContext

        let playlistsFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "EMMediaPlaylist")
        
        do {
            let fetchedPlaylists = try context.fetch(playlistsFetchRequest) as! [EMMediaPlaylist]
            
            for playlist in fetchedPlaylists {
                context.delete(playlist)
                print("DELETING PLAYLIST")
            }
            
        } catch {
            fatalError("Failed to fetch playlists: \(error)")
        }
        
        do {
            try context.save()
        } catch {
            print("\n\n COULDN'T SAVE CONTEXT \n\n")
        }
        
    }


}
