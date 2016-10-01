//
//  AlbumCollectionCell.swift
//  eminenceMusicPlayer
//
//  Created by Magfurul Abeer on 9/30/16.
//  Copyright © 2016 Magfurul Abeer. All rights reserved.
//

import UIKit

class AlbumCollectionCell: UICollectionViewCell, UICollectionViewDelegateFlowLayout,UICollectionViewDataSource, UICollectionViewDelegate {
    
//    var collectionView: UICollectionView?
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    let musicManager = MusicManager.sharedManager
    weak var viewController: UIViewController?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpCollectionView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpCollectionView() {
        let contentViewWidth = contentView.frame.width
        let dimension = (contentViewWidth - 10)/2
        
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .vertical
            flowLayout.minimumLineSpacing = 10
            flowLayout.minimumInteritemSpacing = 10
            flowLayout.itemSize = CGSize(width: dimension, height: dimension)
        }
    
        collectionView.isPrefetchingEnabled = false
        collectionView.backgroundColor = UIColor.clear
        contentView.addSubview(collectionView)
        
        collectionView.register(UINib(nibName: "AlbumCell", bundle: Bundle.main), forCellWithReuseIdentifier: "AlbumCell")
        
        collectionView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        collectionView.reloadData()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return musicManager.albumList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let contentViewWidth = contentView.frame.width
        let album = musicManager.albumList[indexPath.item]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AlbumCell", for: indexPath) as! AlbumCell
        cell.albumImage = album.representativeItem?.artwork?.image(at: CGSize(width: contentViewWidth/2, height: contentViewWidth/2)) ?? #imageLiteral(resourceName: "NoAlbumImage")
        cell.albumTitle = album.representativeItem!.albumTitle ?? "Untitled Album"
        cell.artist = album.representativeItem!.albumArtist ?? album.representativeItem!.artist ?? "Unknown Artist"
        cell.contentView.layer.borderColor = UIColor.white.withAlphaComponent(0.3).cgColor
        cell.contentView.layer.borderWidth = 1
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let size = contentView.frame.size
        let rect = CGRect(x: size.width * 0.05, y: 0, width: size.width * 0.3, height: size.height)
        let albumDetails = AlbumDetailsView(frame: rect)
        albumDetails.album = musicManager.albumList[indexPath.item]
//        albumDetails.albumImageView.image = albumDetails.album!.representativeItem?.artwork?.image(at: CGSize(width: frame.width, height: frame.width)) ?? #imageLiteral(resourceName: "NoAlbumImage")
        albumDetails.viewController = viewController
        addSubview(albumDetails)
        albumDetails.translatesAutoresizingMaskIntoConstraints = false
        albumDetails.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        albumDetails.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        albumDetails.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        albumDetails.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true

    }

}
