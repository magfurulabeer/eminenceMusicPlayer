//
//  SongsCollectionCell.swift
//  eminenceMusicPlayer
//
//  Created by Magfurul Abeer on 9/26/16.
//  Copyright © 2016 Magfurul Abeer. All rights reserved.
//

import UIKit
import MediaPlayer

class SongsCollectionCell: UICollectionViewCell, Previewable {

    // MARK: Properties

    weak var viewController: UIViewController?
    let slideDownInteractor = SlideDownInteractor()
    
    // MARK: Previewable Properties
    var indexView: IndexView = UITableView()
    var selectedCell: IndexViewCell?
    var selectedIndexPath: IndexPath?
    
    
    var cellSnapshot: UIView? = UIView()
    var initialIndexPath: IndexPath? = IndexPath()
    var savedQueue: MPMediaItemCollection?
    
    // MARK: Init Methods

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpTableView()
        NotificationCenter.default.addObserver(self, selector: #selector(SongsCollectionCell.songDidChange), name: NSNotification.Name.MPMusicPlayerControllerNowPlayingItemDidChange, object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Set Up Methods
    
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
        
        indexView.register(UINib(nibName: "SongCell", bundle: Bundle.main), forCellReuseIdentifier: "SongCell")
        indexView.register(UINib(nibName: "SelectedSongCell", bundle: Bundle.main), forCellReuseIdentifier: "SelectedSongCell")
        
        indexView.translatesAutoresizingMaskIntoConstraints = false
        indexView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        indexView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        indexView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        indexView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        indexView.reloadData()
    }
    
    // MARK: Previewable Methods
    
    func selectedSongForPreview(indexPath: IndexPath) -> MPMediaItem {
        let song = musicManager.songList[indexPath.row]
        return song
    }
    
    func setQueue(indexPath:IndexPath) {
        musicManager.player.setQueue(with: MPMediaItemCollection(items: musicManager.originalSongList))
        musicManager.player.beginGeneratingPlaybackNotifications()
        musicManager.player.stop()
    }
    
    func setNewQueue(indexPath:IndexPath) { }
    
    // MARK: NotificationCenter Methods
    
    func songDidChange() {
        guard let indexView = indexView as? UITableView else { return }
        if musicManager.currentlySampling == false {
            indexView.reloadData()
        }
    }
    
    // MARK: Gesture Recognizer Methods
    
    func longPress(sender: UILongPressGestureRecognizer) {
        handleLongPress(sender: sender)
    }
}
