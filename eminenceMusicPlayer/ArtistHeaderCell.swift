//
//  ArtistHeaderCell.swift
//  eminenceMusicPlayer
//
//  Created by Magfurul Abeer on 1/24/17.
//  Copyright © 2017 Magfurul Abeer. All rights reserved.
//

import UIKit

class ArtistHeaderCell: UITableViewCell {

    
    
    @IBOutlet weak var artistImageView: UIImageView!
    @IBOutlet weak var bioLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
