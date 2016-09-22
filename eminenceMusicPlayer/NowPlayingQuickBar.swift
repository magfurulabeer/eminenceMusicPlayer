//
//  NowPlayingQuickBar.swift
//  eminenceMusicPlayer
//
//  Created by Magfurul Abeer on 9/22/16.
//  Copyright © 2016 Magfurul Abeer. All rights reserved.
//

import UIKit
import MediaPlayer

protocol QuickBarDelegate {
    func quickBarWasTapped(sender: NowPlayingQuickBar)
}
let timerInterval = 0.01
class NowPlayingQuickBar: UIView {

    var musicManager = MusicManager.sharedManager
    var delegate: QuickBarDelegate?
    var albumThumbnail = UIImageView()
    var songTitleLabel = UILabel()
    var artistLabel = UILabel()
    var playButton = UIButton(type: UIButtonType.custom)
    var pauseButton = UIButton(type: UIButtonType.custom)
    var lastLocation: CGPoint = CGPoint(x: 0, y: 0)
    var initialDragBumpOver = false
    var volume: UISlider {
        get {
            return self.musicManager.volume
        }
    }
    var fadeTimer = Timer()
    var fadeAnimator = UIViewPropertyAnimator()
    var blackOverlay = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpAlbumThumbnail()
        setUpPlayButton()
        setUpPauseButton()
        setUpSongTitleLabel()
        setUpArtistLabel()
        setUpBlackOverlay()
        
        displayPlaybackButton()

        NotificationCenter.default.addObserver(self, selector: #selector(NowPlayingQuickBar.displayNowPlayingItemChanged), name: NSNotification.Name.MPMusicPlayerControllerNowPlayingItemDidChange, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(NowPlayingQuickBar.displayPlaybackButton), name:NSNotification.Name.MPMusicPlayerControllerPlaybackStateDidChange, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(NowPlayingQuickBar.fadeIn), name: NSNotification.Name(rawValue: "SamplingDidEnd"), object: nil)

        isUserInteractionEnabled = true

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(NowPlayingQuickBar.didTap(sender:)))
        addGestureRecognizer(tapGestureRecognizer)
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(NowPlayingQuickBar.detectDrag(sender:)))
        addGestureRecognizer(panGestureRecognizer)
    }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func displayPlaybackButton() {
        if musicManager.currentlySampling == false {
            if musicManager.player.playbackState == MPMusicPlaybackState.playing {
                playButton.isHidden = true
                pauseButton.isHidden = false
            } else {
                playButton.isHidden = false
                pauseButton.isHidden = true
            }
        } else {
            fadeOut()
        }
    }

    func displayNowPlayingItemChanged() {
        if musicManager.currentlySampling == false {
            songTitleLabel.text = musicManager.itemNowPlaying?.title
            artistLabel.text = musicManager.itemNowPlaying?.artist
            albumThumbnail.image = musicManager.itemNowPlaying?.artwork?.image(at: CGSize(width: self.bounds.height, height: self.bounds.height))
        }
    }
    
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
        print(delta)
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
        print("tap")
        delegate?.quickBarWasTapped(sender: self)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches[touches.startIndex]
        self.lastLocation = touch.preciseLocation(in: self)
    }
    
    func fadeOut() {
        fadeTimer.invalidate()
        let duration = fadeAnimator.fractionComplete
        fadeAnimator = UIViewPropertyAnimator(duration: TimeInterval(duration), curve: .easeOut) {
            self.blackOverlay.alpha = 0.3
        }
        fadeTimer = Timer.scheduledTimer(withTimeInterval: timerInterval, repeats: true, block: { (timer) in
            OperationQueue.main.addOperation {
                self.fadeAnimator.fractionComplete += 0.05 //CGFloat(timerInterval)
                if self.fadeAnimator.fractionComplete == 1.0 {
                    self.fadeTimer.invalidate()
                }
            }
        })
    }
    
    func fadeIn() {
        fadeTimer.invalidate()
        let duration = fadeAnimator.fractionComplete
        fadeAnimator = UIViewPropertyAnimator(duration: TimeInterval(duration), curve: .easeOut) {
            self.blackOverlay.alpha = 0.0
        }
        fadeTimer = Timer.scheduledTimer(withTimeInterval: timerInterval, repeats: true, block: { (timer) in
            OperationQueue.main.addOperation {
                self.fadeAnimator.fractionComplete += 0.05//CGFloat(timerInterval)
                if self.fadeAnimator.fractionComplete == 1.0 {
                    self.fadeTimer.invalidate()
                }
            }
        })
    }
    
}
