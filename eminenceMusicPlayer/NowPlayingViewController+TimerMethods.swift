//
//  NowPlayingViewController+TimerMethods.swift
//  eminenceMusicPlayer
//
//  Created by Magfurul Abeer on 9/22/16.
//  Copyright © 2016 Magfurul Abeer. All rights reserved.
//

import UIKit
import MediaPlayer

extension NowPlayingViewController {
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer) in
            OperationQueue.main.addOperation {
                let currentTime: Double = self.musicManager.player.currentPlaybackTime
                let duration: Double = (self.musicManager.itemNowPlaying?.playbackDuration)!
                self.currentTimeLabel.text = self.musicManager.player.currentPlaybackTime.stringFormat()
                self.slider.value = Float(currentTime/duration)
            }
        })
    }
    
    // TODO: DRY the portion of the codes that overlap with the Timer block
    func startRewindTimer() {
        musicManager.player.beginSeekingBackward()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true, block: { (timer) in
            self.currentTimeLabel.text = self.musicManager.player.currentPlaybackTime.stringFormat()
            var currentTime = self.musicManager.player.currentPlaybackTime
            let duration: Double = (self.musicManager.itemNowPlaying?.playbackDuration)!
            currentTime = currentTime - 5 < 0 ? 0 : currentTime - 5
//            self.musicManager.player.currentPlaybackTime = currentTime
            self.slider.value = Float(currentTime/duration)
        })
    }
    
    // TODO: DRY the portion of the codes that overlap with the Timer block
    func startFastForwardTimer() {
        musicManager.player.beginSeekingForward()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true, block: { (timer) in
            self.currentTimeLabel.text = self.musicManager.player.currentPlaybackTime.stringFormat()
            var currentTime = self.musicManager.player.currentPlaybackTime
            let duration: Double = (self.musicManager.itemNowPlaying?.playbackDuration)!
            currentTime = currentTime + 5 > duration ? duration : currentTime + 5
//            self.musicManager.player.currentPlaybackTime = currentTime
            self.slider.value = Float(currentTime/duration)
        })
    }
}
