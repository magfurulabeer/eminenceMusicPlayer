//
//  BasicSongCell.swift
//  eminenceMusicPlayer
//
//  Created by Magfurul Abeer on 9/21/16.
//  Copyright © 2016 Magfurul Abeer. All rights reserved.
//

import UIKit

class BasicSongCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var artistAlbumLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    
    
    var artist: String = "" {
        didSet {
            self.artistAlbumLabel.text = "\(self.artist) - \(self.album)"
        }
    }
    var album: String = "" {
        didSet {
            self.artistAlbumLabel.text = "\(self.artist) - \(self.album)"
        }
    }

}
