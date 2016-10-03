//
//  AlbumCollectionCell+CollectionViewDelegateDatasource.swift
//  eminenceMusicPlayer
//
//  Created by Magfurul Abeer on 10/2/16.
//  Copyright © 2016 Magfurul Abeer. All rights reserved.
//

import UIKit

extension AlbumCollectionCell: UICollectionViewDelegateFlowLayout,UICollectionViewDataSource, UICollectionViewDelegate {
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
        albumDetails.viewController = viewController
        addSubview(albumDetails)
        albumDetails.translatesAutoresizingMaskIntoConstraints = false
        albumDetails.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        albumDetails.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        albumDetails.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        albumDetails.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        
    }
}
