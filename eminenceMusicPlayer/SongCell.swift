//
//  SongCell.swift
//  eminenceMusicPlayer
//
//  Created by Magfurul Abeer on 9/25/16.
//  Copyright © 2016 Magfurul Abeer. All rights reserved.
//

import UIKit

class SongCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var artistAlbumLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var albumImageView: UIImageView!
    
    var hasGradient = false
    
    var albumImage: UIImage? = #imageLiteral(resourceName: "NoAlbumImage") {
        didSet {
            if self.albumImage != nil {
                self.albumImageView.image = self.albumImage
            } else {
                self.albumImageView.image = #imageLiteral(resourceName: "NoAlbumImage")
            }
        }
    }
    
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
