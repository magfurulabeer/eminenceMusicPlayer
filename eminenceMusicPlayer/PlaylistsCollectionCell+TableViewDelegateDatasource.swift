//
//  PlaylistsCollectionCell+TableViewDelegateDatasource.swift
//  eminenceMusicPlayer
//
//  Created by Magfurul Abeer on 9/30/16.
//  Copyright © 2016 Magfurul Abeer. All rights reserved.
//

import UIKit
import MediaPlayer

extension PlaylistsCollectionCell: UITableViewDelegate, UITableViewDataSource {
    
    @objc(numberOfSectionsInTableView:)
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return musicManager.originalPlaylistList.count
        }
    }
    
    @objc(tableView:cellForRowAtIndexPath:)
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "QuickQueueCell", for: indexPath)
            return cell
        } else {
            let playlist = musicManager.playlistList[indexPath.row]
            
            let cell =  tableView.dequeueReusableCell(withIdentifier: "BasicCell", for: indexPath) as! BasicCell
//            cell.backgroundColor = UIColor.white.withAlphaComponent(0.5)
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            cell.backgroundColor = UIColor.clear
            cell.textLabel?.text = playlist.value(forProperty: MPMediaPlaylistPropertyName) as? String
            cell.detailTextLabel?.text = "\(playlist.count)"
            return cell
        }
        
    }
    
    @objc(tableView:didSelectRowAtIndexPath:)
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    @objc(tableView:heightForRowAtIndexPath:)
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return contentView.frame.height/2
        } else {
            return SongCellHeight
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Quick Queue"
        }
        return "Playlists"
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else {
            return
        }
        header.backgroundView?.backgroundColor = UIColor.clear
        header.textLabel?.textColor = UIColor.white
        header.textLabel?.font = UIFont(name: "Avenir", size: 25)
    }
}
