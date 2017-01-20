//
//  EMMediaPlaylist+CoreDataClass.swift
//  eminenceMusicPlayer
//
//  Created by Magfurul Abeer on 1/19/17.
//  Copyright © 2017 Magfurul Abeer. All rights reserved.
//

import Foundation
import CoreData
import MediaPlayer

public class EMMediaPlaylist: NSManagedObject {
    func playlist() -> MPMediaPlaylist {
        guard let items = items else {
            return MPMediaPlaylist()
        }
        
        var songs = [MPMediaItem]()
        
        for element in items {
            guard let itemData = element as? EMMediaItem else { continue }
            
            let song = songWithPersistentId(persistentID: itemData.id)
            
            if song != nil {
                songs.append(song!)
            }
            
        }
        let list = MediaPlaylist(items: songs)
        list.id = self.id
        list.playlistName = self.name ?? "Unnamed Playlist"
        list.playlistCount = self.items?.count ?? 0
        list.songs = songs
        return list
    }
    
    func songWithPersistentId(persistentID: Int64) -> MPMediaItem? {
        let predicate = MPMediaPropertyPredicate(value: "\(persistentID)", forProperty: MPMediaItemPropertyPersistentID)
        let songQuery = MPMediaQuery()
        songQuery.addFilterPredicate(predicate)
        
        var song: MPMediaItem?
        if let items = songQuery.items , items.count > 0 {
            song = items[0]
        }
        return song
    }

}
