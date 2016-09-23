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
        if musicManager.currentlySampling == false {
            musicManager.player.play()
        }
    }
    
    func pauseButtonTapped(sender: UIButton) {
        if musicManager.currentlySampling == false {
            musicManager.player.pause()
        }
    }
    
    func detectDrag(sender: UIPanGestureRecognizer) {
        if sender.state == UIGestureRecognizerState.ended {
            initialDragBumpOver = false
            return
        }
        
        let translation  = sender.translation(in: self)
        let distance =  translation.x - lastLocation.x
        var delta = Float(distance / 250)
        if (delta > 0.1 || delta < -0.1) && initialDragBumpOver == false {
            initialDragBumpOver = true
            delta = 0.0
        }
        lastLocation = translation
        
        let currentValue = volume.value
        var newValue = currentValue + delta
        if newValue > 1.0 {
            newValue = 1.0
        } else if newValue < 0.0 {
            newValue = 0.0
        }
        
        volume.value = newValue
    }
    
    func didTap(sender: UITapGestureRecognizer) {
        delegate?.quickBarWasTapped(sender: self)
    }
    
}
