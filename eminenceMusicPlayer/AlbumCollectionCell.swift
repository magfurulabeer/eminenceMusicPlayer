//
//  AlbumCollectionCell.swift
//  eminenceMusicPlayer
//
//  Created by Magfurul Abeer on 9/30/16.
//  Copyright © 2016 Magfurul Abeer. All rights reserved.
//

import UIKit
import MediaPlayer

class AlbumCollectionCell: UICollectionViewCell, Previewable {
    
    // MARK: Properties
//    lazy var collectionView: UICollectionView = {
//        let layout = UICollectionViewFlowLayout()
//        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
//        cv.delegate = self
//        cv.dataSource = self
//        cv.translatesAutoresizingMaskIntoConstraints = false
//        return cv
//    }()
//    let musicManager = MusicManager.sharedManager
    weak var viewController: UIViewController?
    
    // MARK: Previewable Properties
    
    var selectedCell: IndexViewCell?
    var selectedIndexPath: IndexPath?
    var savedSong: MPMediaItem?
    var savedTime: TimeInterval?
    var savedRepeatMode: MPMusicRepeatMode?
    var savedPlayerIsPlaying: MPMusicPlaybackState?
    var cellSnapshot: UIView? = UIView()
    var initialIndexPath: IndexPath? = IndexPath()
    var indexView: IndexView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    // MARK: Init Methods
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpCollectionView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: SetUp Methods
    
    func setUpCollectionView() {
        guard let indexView = indexView as? UICollectionView else { return }
        
        let contentViewWidth = contentView.frame.width
        let dimension = (contentViewWidth - 10)/2
        
        if let flowLayout = indexView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .vertical
            flowLayout.minimumLineSpacing = 10
            flowLayout.minimumInteritemSpacing = 10
            flowLayout.itemSize = CGSize(width: dimension, height: dimension)
        }
    
        indexView.isPrefetchingEnabled = false
        indexView.backgroundColor = UIColor.clear
        indexView.delegate = self
        indexView.dataSource = self
        contentView.addSubview(indexView)
        
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.longPress(sender:)))
        longPressGestureRecognizer.minimumPressDuration = 0.3
        indexView.addGestureRecognizer(longPressGestureRecognizer)
        
        indexView.register(UINib(nibName: "AlbumCell", bundle: Bundle.main), forCellWithReuseIdentifier: "AlbumCell")
        
        indexView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        indexView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        indexView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        indexView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        indexView.reloadData()
    }
    
    // MARK: Previewable Methods
    
    func selectedSongForPreview(indexPath: IndexPath) -> MPMediaItem {
        let album = musicManager.albumList[indexPath.item]
        let randomNumber = arc4random_uniform(UInt32(album.count))
        let song = album.items[Int(randomNumber)]
        return song
    }
    
    func setQueue(indexPath:IndexPath) {
        let album = musicManager.albumList[indexPath.item]
        musicManager.player.setQueue(with: MPMediaItemCollection(items: album.items))
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
