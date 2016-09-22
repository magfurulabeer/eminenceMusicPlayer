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
    
    var musicManager = MusicManager.sharedManager
    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        displayMediaData()
        playButton.isHidden = false
        pauseButton.isHidden = true
       
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
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        timer.invalidate()
        let duration: Double = (musicManager.itemNowPlaying?.playbackDuration)!
        let newTime: TimeInterval = Double(sender.value) * duration
        musicManager.player.currentPlaybackTime = newTime
        currentTimeLabel.text = musicManager.player.currentPlaybackTime.stringFormat()
        startTimer()
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
}
