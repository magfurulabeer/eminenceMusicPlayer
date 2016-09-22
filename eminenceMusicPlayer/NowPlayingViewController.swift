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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        displayMediaData()
        playButton.isHidden = false
        pauseButton.isHidden = true
        displayReplayStatus()
        displayShuffleStatus()
        NotificationCenter.default.addObserver(self, selector: #selector(NowPlayingViewController.displayMediaData), name:NSNotification.Name.MPMusicPlayerControllerNowPlayingItemDidChange, object: nil)
        
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
    
    func displayMediaData() {
        let song = musicManager.itemNowPlaying
        print(song?.title)
        titleLabel.text = song?.title != nil ? song?.title! : "Unnamed"
        artistLabel.text = song?.artist != nil ? song?.artist! : "Unknown Artist"
        albumLabel.text = song?.albumTitle != nil ? song?.albumTitle! : "Unnamed Album"
        durationLabel.text = song?.playbackDuration.stringFormat()
        if let artwork = song?.artwork {
            albumImageView.image = artwork.image(at: albumImageView.bounds.size)
        } else {
            albumImageView.image = #imageLiteral(resourceName: "NoAlbumImage")
        }
        print(song?.title)
    }
    
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
    
    func startRewindTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true, block: { (timer) in
            print("rewind")
            var currentTime = self.musicManager.player.currentPlaybackTime
            let duration: Double = (self.musicManager.itemNowPlaying?.playbackDuration)!
            currentTime = currentTime - 5 < 0 ? 0 : currentTime - 5
            self.musicManager.player.currentPlaybackTime = currentTime
            self.currentTimeLabel.text = self.musicManager.player.currentPlaybackTime.stringFormat()
            self.slider.value = Float(currentTime/duration)
        })
    }
    
    func startFastForwardTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true, block: { (timer) in
            print("rewind")
            var currentTime = self.musicManager.player.currentPlaybackTime
            let duration: Double = (self.musicManager.itemNowPlaying?.playbackDuration)!
            currentTime = currentTime + 5 > duration ? duration : currentTime + 5
            self.musicManager.player.currentPlaybackTime = currentTime
            self.currentTimeLabel.text = self.musicManager.player.currentPlaybackTime.stringFormat()
            self.slider.value = Float(currentTime/duration)
        })
    }
    
    func displayReplayStatus() {
        func displayRepeatNone() {
            repeatButton.imageView?.image = #imageLiteral(resourceName: "repeat")
            repeatButton.setImage(#imageLiteral(resourceName: "repeat"), for: UIControlState.normal)
            repeatButton.alpha = 0.5
        }
        func displayRepeatAll() {
            repeatButton.alpha = 1
        }
        func displayRepeatOne() {
            repeatButton.imageView?.image = #imageLiteral(resourceName: "repeat1")
            repeatButton.setImage(#imageLiteral(resourceName: "repeat1"), for: UIControlState.normal)
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
    
    // TODO: DRY the portion of the codes that overlap with the Timer block
    @IBAction func rewindButtonLongPressed(_ sender: UILongPressGestureRecognizer) {
        if (sender.state == UIGestureRecognizerState.began) {
            timer.invalidate()
            startRewindTimer()
            timer.fire()
        } else if (sender.state == UIGestureRecognizerState.ended) {
            timer.invalidate()
            startTimer()
        }
    }
    
    @IBAction func fastForwardButtonLongPressed(_ sender: UILongPressGestureRecognizer) {
        if (sender.state == UIGestureRecognizerState.began) {
            timer.invalidate()
            startFastForwardTimer()
            timer.fire()
        } else if (sender.state == UIGestureRecognizerState.ended) {
            timer.invalidate()
            startTimer()
        }
    }
    
    
    
    
}
