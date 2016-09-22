//
//  NowPlayingViewController.swift
//  eminenceMusicPlayer
//
//  Created by Magfurul Abeer on 9/21/16.
//  Copyright © 2016 Magfurul Abeer. All rights reserved.
//

import UIKit
import MediaPlayer

// TODO: When song starts, 00:01 is skipped and the timer starts it at 00:00
class NowPlayingViewController: UIViewController {

    
    @IBOutlet weak var albumImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var albumLabel: UILabel!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var controlsStackView: UIStackView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var repeatButton: UIButton!
    @IBOutlet weak var shuffleButton: UIButton!
    
    var musicManager = MusicManager.sharedManager
    var timer = Timer()
    var lastLocation: CGPoint = CGPoint(x: 0, y: 0)
    var volume: UISlider {
        get {
            return self.musicManager.volume
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        displayMediaData()
        playButton.isHidden = false
        pauseButton.isHidden = true
        
        // Shuffle is turned off whenever a cell is selected to ensure current song was picked
        // This just turns it back on if needed
        musicManager.player.shuffleMode = musicManager.shuffleIsOn ? .songs : .off
        
        displayReplayStatus()
        displayShuffleStatus()
        NotificationCenter.default.addObserver(self, selector: #selector(NowPlayingViewController.displayMediaData), name:NSNotification.Name.MPMusicPlayerControllerNowPlayingItemDidChange, object: nil)
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(NowPlayingViewController.detectDrag(sender:)))
        view.addGestureRecognizer(panGestureRecognizer)
    }
    
    func detectDrag(sender: UIPanGestureRecognizer) {
        let translation  = sender.translation(in: view)
        let distance = lastLocation.y - translation.y
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
    
    override func viewDidAppear(_ animated: Bool) {
        if musicManager.player.playbackState == MPMusicPlaybackState.playing {
            playButton.isHidden = true
            pauseButton.isHidden = false
            startTimer()
        } else {
            playButton.isHidden = false
            pauseButton.isHidden = true
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches[touches.startIndex]
        self.lastLocation = touch.preciseLocation(in: view)
    }
}
