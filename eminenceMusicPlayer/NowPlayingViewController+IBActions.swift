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

    @IBAction func previousButtonTapped(_ sender: UIButton) {
        musicManager.player.skipToPreviousItem()
        displayMediaData()
    }
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        musicManager.player.skipToNextItem()
        displayMediaData()
    }
}
