//
//  MPVolumeView+SliderAccess.swift
//  eminenceMusicPlayer
//
//  Created by Magfurul Abeer on 9/22/16.
//  Copyright © 2016 Magfurul Abeer. All rights reserved.
//

import UIKit
import MediaPlayer

/// This extension adds a slider interface to manage volume.
extension MPVolumeView {
    
    /// This slider directly controls the AVAudioSessions volume.
    public var volumeSlider:UISlider {
        self.showsRouteButton = false
        self.showsVolumeSlider = false
        self.isHidden = true
        var slider = UISlider()
        for subview in self.subviews {
            if subview.isKind(of: UISlider.self) {
                slider = subview as! UISlider
                slider.isContinuous = false
                (subview as! UISlider).value = AVAudioSession.sharedInstance().outputVolume
                return slider
            }
        }
        return slider
    }
}
