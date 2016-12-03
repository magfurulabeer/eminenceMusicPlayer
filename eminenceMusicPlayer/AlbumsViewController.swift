//
//  AlbumsViewController.swift
//  eminenceMusicPlayer
//
//  Created by Magfurul Abeer on 10/3/16.
//  Copyright © 2016 Magfurul Abeer. All rights reserved.
//

import UIKit
import MediaPlayer

// TODO: Share setUpIndexView code between the menuviewcontrollers


/// View controller that shows a table of all the albums
class AlbumsViewController: MenuViewController, UICollectionViewDelegateFlowLayout,UICollectionViewDataSource, UICollectionViewDelegate, Previewable {

    
    
    // MARK: Properties
    
    
    /// The index View (CollectionView) that needs it's items to be previewable.
    var indexView: IndexView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    /// Allows base class methods to have access to indexView
    override var storedIndexView: IndexView? {  get { return indexView }    }
    
    
    // MARK: Previewable Properties
    
    /// Cell/Item being previewed.
    var selectedCell: IndexViewCell?
    
    /// Index path of the cell/item being previewed.
    var selectedIndexPath: IndexPath?
    
    
    // MARK: View Management Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.clear
        setUpIndexView()
    }
    
    
    // MARK: Setup Methods
    
    func setUpIndexView() {
        guard let indexView = indexView as? UICollectionView else { return }
        
        let viewWidth = view.frame.width
        let dimension = (viewWidth - 10)/2
        
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
        indexView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        indexView.scrollIndicatorInsets = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.longPress(sender:)))
        longPressGestureRecognizer.minimumPressDuration = 0.3
        indexView.addGestureRecognizer(longPressGestureRecognizer)
        
        indexView.register(UINib(nibName: "AlbumCell", bundle: Bundle.main), forCellWithReuseIdentifier: "AlbumCell")
        
        constrainIndexView()
        
        indexView.reloadData()
    }
    

    
    // MARK: UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return musicManager.albumList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let viewWidth = view.frame.width
        let album = musicManager.albumList[indexPath.item]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AlbumCell", for: indexPath) as! AlbumCell
        cell.albumImage = album.representativeItem?.artwork?.image(at: CGSize(width: viewWidth/2, height: viewWidth/2)) ?? #imageLiteral(resourceName: "NoAlbumImage")
        cell.albumTitle = album.representativeItem!.albumTitle ?? "Untitled Album"
        cell.artist = album.representativeItem!.albumArtist ?? album.representativeItem!.artist ?? "Unknown Artist"
        cell.contentView.layer.borderColor = UIColor.white.withAlphaComponent(0.3).cgColor
        cell.contentView.layer.borderWidth = 1
        return cell
        
    }
    
    // MARK: UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let size = view.frame.size
        let rect = CGRect(x: topPadding, y: 0, width: size.width, height: size.height - topPadding - bottomPadding)
        let albumDetails = AlbumDetailsView(frame: rect)
        albumDetails.album = musicManager.albumList[indexPath.item]
        albumDetails.viewController = viewController
        view.addSubview(albumDetails)
        albumDetails.translatesAutoresizingMaskIntoConstraints = false
        albumDetails.topAnchor.constraint(equalTo: view.topAnchor, constant: topPadding).isActive = true
        albumDetails.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: bottomPadding).isActive = true
        albumDetails.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        albumDetails.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
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
    
    func indexPathIsExcluded(indexPath: IndexPath?) -> Bool {
        return false
    }
    
    // MARK: Gesture Recognizer Methods
    
    func longPress(sender: UILongPressGestureRecognizer) {
        handleLongPress(sender: sender)
    }

}
