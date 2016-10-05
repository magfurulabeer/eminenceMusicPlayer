//
//  NowPlayingViewController+DisplayMethods.swift
//  eminenceMusicPlayer
//
//  Created by Magfurul Abeer on 9/22/16.
//  Copyright © 2016 Magfurul Abeer. All rights reserved.
//

import UIKit
import MediaPlayer

extension NowPlayingViewController {
    func displayMediaData() {
        let song = musicManager.itemNowPlaying
        titleLabel.text = song?.title != nil ? song?.title! : "Unnamed"
        artistLabel.text = song?.artist != nil ? song?.artist! : "Unknown Artist"
        albumLabel.text = song?.albumTitle != nil ? song?.albumTitle! : "Unnamed Album"
        durationLabel.text = song?.playbackDuration.stringFormat()
        if let artwork = song?.artwork {
            albumImageView.image = artwork.image(at: albumImageView.bounds.size)
        } else {
            albumImageView.image = #imageLiteral(resourceName: "NoAlbumImage")
        }
    }
    
    func displayReplayStatus() {
        func displayRepeatNone() {
            repeatButton.imageView?.image = #imageLiteral(resourceName: "repeat")
            repeatButton.setImage(#imageLiteral(resourceName: "repeat"), for: UIControlState.normal)
            repeatButton.alpha = 0.5
        }
        func displayRepeatAll() {
            repeatButton.imageView?.image = #imageLiteral(resourceName: "repeat")
            repeatButton.setImage(#imageLiteral(resourceName: "repeat"), for: UIControlState.normal)
            repeatButton.alpha = 1
        }
        func displayRepeatOne() {
            repeatButton.imageView?.image = #imageLiteral(resourceName: "repeat1")
            repeatButton.setImage(#imageLiteral(resourceName: "repeat1"), for: UIControlState.normal)
            repeatButton.alpha = 1
        }
        
        if musicManager.player.repeatMode == MPMusicRepeatMode.none {
            displayRepeatNone()
        } else if musicManager.player.repeatMode == MPMusicRepeatMode.all {
            displayRepeatAll()
        } else if musicManager.player.repeatMode == MPMusicRepeatMode.one {
            displayRepeatOne()
        }
    }
    
    func displayShuffleStatus() {
        if musicManager.player.shuffleMode == MPMusicShuffleMode.off {
            shuffleButton.alpha = 0.5
        } else if musicManager.player.shuffleMode == MPMusicShuffleMode.songs {
            shuffleButton.alpha = 1.0
        } else {
            print("Shuffle mode is on albums??")
        }
    }
    
    func blurredAlbumImage() -> UIImage? {
        let context = CIContext(options: nil)

//        CIGaussianBlur
        if let currentFilter = CIFilter(name: "CIMotionBlur") {
            
            let beginImage = CIImage(image: albumImageView.image!)
            currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
            currentFilter.setValue(8, forKey: kCIInputRadiusKey)

            if let output = currentFilter.outputImage {
                if let cgimg = context.createCGImage(output, from: beginImage!.extent) {
                    let processedImage = UIImage(cgImage: cgimg)
                    return processedImage
                }
            }
        }
        return nil
    }
    
    func blurImage() {
        UIView.transition(with: albumImageView, duration: 0.5, options: [.transitionCrossDissolve, .curveEaseIn], animations: {
            self.albumImageView.image = self.blurredAlbumImage()
            }, completion: nil)
    }
    
    func unblurImage() {
        UIView.transition(with: albumImageView, duration: 0.5, options: [.transitionCrossDissolve, .curveEaseOut], animations: {
            self.albumImageView.image = self.musicManager.itemNowPlaying?.artwork?.image(at: CGSize(width: self.view.frame.width, height: self.view.frame.width)) ?? #imageLiteral(resourceName: "NoAlbumImage")
            }, completion: nil)
    }

}
