//
//  NowPlayingQuickBar+Actions.swift
//  eminenceMusicPlayer
//
//  Created by Magfurul Abeer on 9/22/16.
//  Copyright © 2016 Magfurul Abeer. All rights reserved.
//

import UIKit

extension NowPlayingQuickBar {
    func playButtonTapped(sender: UIButton) {
        if musicManager.currentlyPreviewing == false {
            musicManager.player.play()
        }
    }
    
    func pauseButtonTapped(sender: UIButton) {
        if musicManager.currentlyPreviewing == false {
            musicManager.player.pause()
        }
    }
    
    func didTap(sender: UITapGestureRecognizer) {
        delegate?.quickBarWasTapped(sender: self)
    }
    
    func swipeLeft(sender: UISwipeGestureRecognizer) {
        if musicManager.currentlyPreviewing == false {
            musicManager.player.skipToNextItem()
        }
    }
    
    func swipeRight(sender: UISwipeGestureRecognizer) {
        if musicManager.currentlyPreviewing == false {
            musicManager.player.skipToPreviousItem()
        }
    }
    
}
