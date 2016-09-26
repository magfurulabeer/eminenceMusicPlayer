//
//  NowPlayingQuickBar+SetUp.swift
//  eminenceMusicPlayer
//
//  Created by Magfurul Abeer on 9/22/16.
//  Copyright © 2016 Magfurul Abeer. All rights reserved.
//

import UIKit
import CoreGraphics

extension NowPlayingQuickBar {
    func setUpAlbumThumbnail() {
        albumThumbnail.image = musicManager.itemNowPlaying?.artwork?.image(at: CGSize(width: self.bounds.height, height: self.bounds.height))
        albumThumbnail.image = albumThumbnail.image == nil ? #imageLiteral(resourceName: "NoAlbumImage") : albumThumbnail.image
        albumThumbnail.contentMode = UIViewContentMode.scaleAspectFill
        albumThumbnail.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(self.albumThumbnail)
        
        albumThumbnail.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.8).isActive = true
        
//        albumThumbnail.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.9).isActive = true
        albumThumbnail.widthAnchor.constraint(equalTo: heightAnchor, multiplier: 0.8).isActive = true
        albumThumbnail.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        albumThumbnail.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15).isActive = true
    }
    
    func setUpSongTitleLabel() {
        songTitleLabel.text = musicManager.itemNowPlaying?.title
        songTitleLabel.textColor = UIColor.white
        songTitleLabel.font = UIFont(name: "Avenir", size: 20)
        songTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(self.songTitleLabel)
        
        songTitleLabel.leadingAnchor.constraint(equalTo: self.albumThumbnail.trailingAnchor, constant: 8).isActive = true
        songTitleLabel.trailingAnchor.constraint(equalTo: self.playButton.leadingAnchor, constant: -8).isActive = true
        songTitleLabel.centerYAnchor.constraint(equalTo: self.albumThumbnail.centerYAnchor, constant: -8).isActive = true
        songTitleLabel.heightAnchor.constraint(equalToConstant: 22).isActive = true
    }
    
    
    func setUpArtistLabel() {
        artistLabel.text = musicManager.itemNowPlaying?.artist
        artistLabel.textColor = UIColor.white.withAlphaComponent(0.8)
        artistLabel.font = UIFont(name: "Avenir", size: 16)
        artistLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(self.artistLabel)
        
        artistLabel.leadingAnchor.constraint(equalTo: self.songTitleLabel.leadingAnchor).isActive = true
        artistLabel.trailingAnchor.constraint(equalTo: self.songTitleLabel.trailingAnchor).isActive = true
        artistLabel.topAnchor.constraint(equalTo: self.songTitleLabel.bottomAnchor).isActive = true
        artistLabel.heightAnchor.constraint(equalToConstant: 17).isActive = true
    }
    
    func setUpPlayButton() {
        playButton.imageView?.image = #imageLiteral(resourceName: "quickPlayIcon")
        playButton.setImage(#imageLiteral(resourceName: "quickPlayIcon"), for: UIControlState.normal)
        playButton.contentMode = UIViewContentMode.scaleAspectFit
        playButton.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        playButton.addTarget(self, action: #selector(NowPlayingQuickBar.playButtonTapped(sender:)), for: UIControlEvents.touchUpInside)
        playButton.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(playButton)
        
        playButton.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5).isActive = true
        playButton.widthAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5).isActive = true
        playButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
//        playButton.centerYAnchor.constraint(equalTo: albumThumbnail.centerYAnchor, constant: -3).isActive = true
        playButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -18).isActive = true
    }
    
    func setUpPauseButton() {
        pauseButton.imageView?.image = #imageLiteral(resourceName: "quickPauseIcon")
        pauseButton.setImage(#imageLiteral(resourceName: "quickPauseIcon"), for: UIControlState.normal)
        pauseButton.contentMode = UIViewContentMode.scaleAspectFit
        pauseButton.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        pauseButton.addTarget(self, action: #selector(NowPlayingQuickBar.pauseButtonTapped(sender:)), for: UIControlEvents.touchUpInside)
        pauseButton.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(pauseButton)
        
        pauseButton.heightAnchor.constraint(equalTo: self.playButton.heightAnchor).isActive = true
        pauseButton.widthAnchor.constraint(equalTo: self.playButton.widthAnchor).isActive = true
        pauseButton.centerYAnchor.constraint(equalTo: self.playButton.centerYAnchor).isActive = true
        pauseButton.trailingAnchor.constraint(equalTo: self.playButton.trailingAnchor).isActive = true
    }
    
    func setUpGradient() {
        let gradient = CAGradientLayer()
        let startColor = UIColor(red: 73/255.0, green: 68/255.0, blue: 78/255.0, alpha: 1)
//        let endColor = UIColor(red: 42/255.0, green: 44/255.0, blue: 56/255.0, alpha: 1.0)
        let endColor = UIColor(red: 54/255.0, green: 49/255.0, blue: 58/255.0, alpha: 1.0)
        gradient.colors = [startColor.cgColor, endColor.cgColor]
        gradient.frame = frame
        let points = (CGPoint(x: 0.5, y: 0), CGPoint(x: 0.5, y: 1))
        gradient.startPoint = points.0
        gradient.endPoint = points.1
        layer.addSublayer(gradient)
        gradient.zPosition = 5
    }
    
    func setUpShadow() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 1
        layer.shadowOffset = CGSize.zero
        layer.shadowRadius = 10
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
//        layer.shouldRasterize = true
    }
    
    func setUpTopBorder() {
        border.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        addSubview(border)
        border.translatesAutoresizingMaskIntoConstraints = false
        border.topAnchor.constraint(equalTo: topAnchor).isActive = true
        border.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        border.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        border.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
}
