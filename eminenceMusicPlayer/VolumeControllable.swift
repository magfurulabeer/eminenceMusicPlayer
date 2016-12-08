//
//  VolumeControllable.swift
//  eminenceMusicPlayer
//
//  Created by Magfurul Abeer on 12/6/16.
//  Copyright © 2016 Magfurul Abeer. All rights reserved.
//

import UIKit

/// This protocol is for any class that allows a two finger drag up & down to change the volume
protocol VolumeControllable: class {
    
    
    /// A hidden UISlider representing the volume.
    var volume: UISlider { get }
    
    /// Reference to view 
    var controllableView: UIView { get }
    
    /// The last location of the drag
    var lastLocation: CGPoint { get set }
    
    func didTwoFingerDrag(sender: UIPanGestureRecognizer)
}

/// This protocol provides the volume property and the setup and drag callback functions
extension VolumeControllable {
    
    /// A hidden UISlider representing the volume.
    var volume: UISlider {
        get {
            return MusicManager.sharedManager.volume
        }
    }

    func didTwoFingerDrag(sender: UIPanGestureRecognizer) {
        let translation  = sender.translation(in: controllableView)
        let distance = self.lastLocation.y - translation.y
        var delta = Float(distance / 250)
        if delta > 0.5 {
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
    
}
