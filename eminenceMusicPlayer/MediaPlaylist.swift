//
//  MediaPlaylist.swift
//  eminenceMusicPlayer
//
//  Created by Magfurul Abeer on 1/19/17.
//  Copyright © 2017 Magfurul Abeer. All rights reserved.
//

import UIKit
import MediaPlayer

class MediaPlaylist: MPMediaPlaylist {
    var playlistName = "Unnamed Playlist"
    var playlistCount = 0
    var songs = [MPMediaItem]()
    var id: Int64 = 0
}
