//
//  MPMediaPlaylist+NameInit.swift
//  eminenceMusicPlayer
//
//  Created by Magfurul Abeer on 1/19/17.
//  Copyright © 2017 Magfurul Abeer. All rights reserved.
//

import UIKit
import MediaPlayer

extension MPMediaPlaylist {
    convenience init(name: String, items: [MPMediaItem]) {
        self.init(items: items)
    }
}
