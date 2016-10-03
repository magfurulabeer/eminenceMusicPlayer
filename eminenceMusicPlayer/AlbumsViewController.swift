//
//  AlbumsViewController.swift
//  eminenceMusicPlayer
//
//  Created by Magfurul Abeer on 10/3/16.
//  Copyright © 2016 Magfurul Abeer. All rights reserved.
//

import UIKit

class AlbumsViewController: MenuViewController, UICollectionViewDelegateFlowLayout,UICollectionViewDataSource, UICollectionViewDelegate {

    let musicManager = MusicManager.sharedManager
    var indexView: IndexView? = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    override var storedIndexView: IndexView? {  get { return indexView }    }
    override var index: Int {
        get {
            return 3
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.clear
        setUpIndexView()
    }
    
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
        
        //        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.longPress(sender:)))
        //        longPressGestureRecognizer.minimumPressDuration = 0.3
        //        indexView.addGestureRecognizer(longPressGestureRecognizer)
        
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
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let size = contentView.frame.size
//        let rect = CGRect(x: size.width * 0.05, y: 0, width: size.width * 0.3, height: size.height)
//        let albumDetails = AlbumDetailsView(frame: rect)
//        albumDetails.album = musicManager.albumList[indexPath.item]
//        albumDetails.viewController = viewController
//        addSubview(albumDetails)
//        albumDetails.translatesAutoresizingMaskIntoConstraints = false
//        albumDetails.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
//        albumDetails.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
//        albumDetails.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
//        albumDetails.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
//    }

}
