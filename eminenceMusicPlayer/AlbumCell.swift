//
//  AlbumCell.swift
//  eminenceMusicPlayer
//
//  Created by Magfurul Abeer on 9/30/16.
//  Copyright © 2016 Magfurul Abeer. All rights reserved.
//

import UIKit

class AlbumCell: UICollectionViewCell {

    @IBOutlet weak var albumImageView: UIImageView!
  
    @IBOutlet weak var albumTitleLabel: UILabel!
    
    @IBOutlet weak var albumArtistLabel: UILabel!

    var hasBorder = false
    
    var albumImage: UIImage {
        get {
            return self.albumImageView.image!
        }
        set {
            self.albumImageView.image = newValue
        }
    }
    
    var albumTitle: String {
        get {
            return self.albumTitleLabel.text!
        }
        set {
            self.albumTitleLabel.text = newValue
        }
    }
    
    var artist: String {
        get {
            return self.albumArtistLabel.text!
        }
        set {
            self.albumArtistLabel.text = newValue
        }
    }
    

}
