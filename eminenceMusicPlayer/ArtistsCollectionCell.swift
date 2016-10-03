//
//  ArtistsCollectionCell.swift
//  eminenceMusicPlayer
//
//  Created by Magfurul Abeer on 9/26/16.
//  Copyright © 2016 Magfurul Abeer. All rights reserved.
//

import UIKit
import MediaPlayer

class ArtistsCollectionCell: UICollectionViewCell, Previewable {
    
    var indexView: IndexView = UITableView()
    var selectedCell: IndexViewCell?
    var selectedIndexPath: IndexPath?
    
//    var tableView: UITableView = UITableView()
    weak var viewController: UIViewController?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
        setUpTableView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpTableView() {
        guard let indexView = indexView as? UITableView else { return }
        
        indexView.delegate = self
        indexView.dataSource = self
        indexView.backgroundColor = UIColor.clear
        contentView.addSubview(indexView)
        indexView.separatorStyle = UITableViewCellSeparatorStyle.none

        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.longPress(sender:)))
        longPressGestureRecognizer.minimumPressDuration = 0.3
        indexView.addGestureRecognizer(longPressGestureRecognizer)
        
        indexView.register(UINib(nibName: "ArtistCell", bundle: Bundle.main), forCellReuseIdentifier: "ArtistCell")

        indexView.translatesAutoresizingMaskIntoConstraints = false
        indexView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        indexView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        indexView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        indexView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        indexView.reloadData()
    }
    
    // MARK: Previewable Methods
    
    func selectedSongForPreview(indexPath: IndexPath) -> MPMediaItem {
        let artist = musicManager.artistList[indexPath.row]
        let randomNumber = arc4random_uniform(UInt32(artist.count))
        let song = artist.items[Int(randomNumber)]
        return song
    }
    
    func setQueue(indexPath:IndexPath) {
        let artist = musicManager.artistList[indexPath.row]
        musicManager.player.setQueue(with: MPMediaItemCollection(items: artist.items))
        musicManager.player.beginGeneratingPlaybackNotifications()
        musicManager.player.stop()
    }
    
    func setNewQueue(indexPath:IndexPath) {
        setQueue(indexPath: indexPath)
    }
    
    // MARK: Gesture Recognizer Methods
    
    func longPress(sender: UILongPressGestureRecognizer) {
        handleLongPress(sender: sender)
    }
    
}
