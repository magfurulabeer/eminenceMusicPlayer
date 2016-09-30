//
//  PlaylistsCollectionCell+TableViewDelegateDatasource.swift
//  eminenceMusicPlayer
//
//  Created by Magfurul Abeer on 9/30/16.
//  Copyright © 2016 Magfurul Abeer. All rights reserved.
//

import UIKit

extension PlaylistsCollectionCell: UITableViewDelegate, UITableViewDataSource {
    
    @objc(numberOfSectionsInTableView:)
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return musicManager.artistList.count
        
    }
    
    @objc(tableView:cellForRowAtIndexPath:)
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let artist = musicManager.artistList[indexPath.row]
        
        let cell =  tableView.dequeueReusableCell(withIdentifier: "ArtistCell", for: indexPath) as! ArtistCell
        cell.artistLabel?.text = artist.representativeItem?.artist
        cell.albumImageView?.image = artist.representativeItem?.artwork?.image(at: CGSize(width: SongCellHeight, height: SongCellHeight))
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.backgroundColor = UIColor.clear
        
        return cell
    }
    
    @objc(tableView:didSelectRowAtIndexPath:)
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    @objc(tableView:heightForRowAtIndexPath:)
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return SongCellHeight
    }
}
