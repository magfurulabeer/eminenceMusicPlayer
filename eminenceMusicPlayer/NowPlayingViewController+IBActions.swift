//
//  NowPlayingViewController+IBActions.swift
//  eminenceMusicPlayer
//
//  Created by Magfurul Abeer on 9/21/16.
//  Copyright © 2016 Magfurul Abeer. All rights reserved.
//

import UIKit
import MediaPlayer

extension NowPlayingViewController {
    @IBAction func backButtonTapped(_ sender: UIButton) {
        dismiss(animated: true) {
            self.timer.invalidate()
        }
    }
    
    @IBAction func playButtonTapped(_ sender: UIButton) {
        playButton.isHidden = true
        pauseButton.isHidden = false
        musicManager.player.play()
        startTimer()
    }
    
    @IBAction func pauseButtonTapped(_ sender: UIButton) {
        playButton.isHidden = false
        pauseButton.isHidden = true
        musicManager.player.pause()
        timer.invalidate()
    }

    @IBAction func repeatButtonTapped(_ sender: UIButton) {
        let repeatMode = musicManager.player.repeatMode
        print(musicManager.player.repeatMode.rawValue)
        if repeatMode == MPMusicRepeatMode.none {
            musicManager.player.repeatMode = MPMusicRepeatMode.all
        } else if repeatMode == MPMusicRepeatMode.all {
            musicManager.player.repeatMode = MPMusicRepeatMode.one
        } else if repeatMode == MPMusicRepeatMode.one {
            musicManager.player.repeatMode = MPMusicRepeatMode.none
        }
        displayReplayStatus()
    }
    
    @IBAction func shuffleButtonTapped(_ sender: UIButton) {
        let shuffleMode = musicManager.player.shuffleMode
        if shuffleMode == MPMusicShuffleMode.off {
            musicManager.player.shuffleMode = MPMusicShuffleMode.songs
        } else {
            musicManager.player.shuffleMode = MPMusicShuffleMode.off
        }
        displayShuffleStatus()
    }
    
    
    
    @IBAction func rewindButtonTapped(_ sender: UIButton) {
        slider.value = 0
        let time = musicManager.player.currentPlaybackTime
        let duration = musicManager.itemNowPlaying?.playbackDuration
        let percent = time/duration!
        if duration! >= 10 && time >= 5 {
            musicManager.player.skipToBeginning()
        } else if duration! < 10 && percent < 0.5 {
            musicManager.player.skipToBeginning()
        } else {
            resetPlaybackSpeed()
            musicManager.player.skipToPreviousItem()
            
        }
        currentTimeLabel.text = musicManager.player.currentPlaybackTime.stringFormat()
    }
    
    @IBAction func fastForwardButtonTapped(_ sender: UIButton) {
        slider.value = 0
        resetPlaybackSpeed()
        musicManager.player.skipToNextItem()
        currentTimeLabel.text = musicManager.player.currentPlaybackTime.stringFormat()
    }
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        timer.invalidate()
        let duration: Double = (musicManager.itemNowPlaying?.playbackDuration)!
        let newTime: TimeInterval = Double(sender.value) * duration
        musicManager.player.currentPlaybackTime = newTime
        currentTimeLabel.text = musicManager.player.currentPlaybackTime.stringFormat()
        startTimer()
    }
    
    @IBAction func rewindButtonLongPressed(_ sender: UILongPressGestureRecognizer) {
        if (sender.state == UIGestureRecognizerState.began) {
            timer.invalidate()
            startRewindTimer()
            blurImage()
        } else if (sender.state == UIGestureRecognizerState.ended) {
            musicManager.player.endSeeking()
            timer.invalidate()
            startTimer()
            unblurImage()
        }
    }
    
    @IBAction func fastForwardButtonLongPressed(_ sender: UILongPressGestureRecognizer) {
        if (sender.state == UIGestureRecognizerState.began) {
            timer.invalidate()
            startFastForwardTimer()
            blurImage()
        } else if (sender.state == UIGestureRecognizerState.ended) {
            musicManager.player.endSeeking()
            timer.invalidate()
            startTimer()
            unblurImage()
        }
    }
    
    
    
    // MARK: Helper Methods
    
    func resetPlaybackSpeed() {
        speedButton.title = "1x"
        musicManager.player.currentPlaybackRate = 1
    }
}
