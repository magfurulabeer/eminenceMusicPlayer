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
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var fauxNavBar: UIView!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
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
        backButton.contentMode = UIViewContentMode.scaleAspectFit
        backButton.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        displayMediaData()
        playButton.isHidden = false
        pauseButton.isHidden = true
        view.backgroundColor = UIColor.clear
        setUpGradient()
        setUpFauxNavBar()
        
        // Shuffle is turned off whenever a cell is selected to ensure current song was picked
        // This just turns it back on if needed
        musicManager.player.shuffleMode = musicManager.shuffleIsOn ? .songs : .off
        
        displayReplayStatus()
        displayShuffleStatus()
        NotificationCenter.default.addObserver(self, selector: #selector(NowPlayingViewController.displayMediaData), name:NSNotification.Name.MPMusicPlayerControllerNowPlayingItemDidChange, object: nil)
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(NowPlayingViewController.detectDrag(sender:)))
        view.addGestureRecognizer(panGestureRecognizer)
        
        albumImageView.layer.borderColor = UIColor.white.withAlphaComponent(0.1).cgColor
        albumImageView.layer.borderWidth = 1
//        albumImageView.layer.shadowColor = UIColor.black.cgColor
//        albumImageView.layer.shadowOpacity = 1
//        albumImageView.layer.shadowOffset = CGSize.zero
//        albumImageView.layer.shadowRadius = 10
//        albumImageView.layer.shadowPath = UIBezierPath(rect: albumImageView.bounds).cgPath
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let currentTime: Double = self.musicManager.player.currentPlaybackTime
        let duration: Double = (self.musicManager.itemNowPlaying?.playbackDuration)!
        self.currentTimeLabel.text = self.musicManager.player.currentPlaybackTime.stringFormat()
        self.slider.value = Float(currentTime/duration)
    }
    
    override func viewWillLayoutSubviews() {
        if musicManager.player.playbackState == MPMusicPlaybackState.playing {
            playButton.isHidden = true
            pauseButton.isHidden = false
            startTimer()
        } else {
            playButton.isHidden = false
            pauseButton.isHidden = true
        }
    }
    
  
    
    
    func setUpFauxNavBar() {
        fauxNavBar.layer.shadowColor = UIColor.black.cgColor
        fauxNavBar.layer.shadowOpacity = 1
        fauxNavBar.layer.shadowOffset = CGSize.zero
        fauxNavBar.layer.shadowRadius = 10
        let rect = CGRect(x: 0, y: 0, width: view.frame.width, height: FauxBarHeight)
        fauxNavBar.layer.shadowPath = UIBezierPath(rect: rect).cgPath
        
        let border = UIView()
        border.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        fauxNavBar.addSubview(border)
        border.translatesAutoresizingMaskIntoConstraints = false
        border.bottomAnchor.constraint(equalTo: fauxNavBar.bottomAnchor).isActive = true
        border.leadingAnchor.constraint(equalTo: fauxNavBar.leadingAnchor).isActive = true
        border.trailingAnchor.constraint(equalTo: fauxNavBar.trailingAnchor).isActive = true
        border.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    func setUpGradient() {
        
        let gradient = CAGradientLayer()
        let startColor = UIColor(red: 47/255.0, green: 49/255.0, blue: 60/255.0, alpha: 1)
        let endColor = UIColor(red: 75/255.0, green: 47/255.0, blue: 51/255.0, alpha: 1)
        gradient.colors = [startColor.cgColor, endColor.cgColor]
        gradient.frame = self.view.frame
        let points = (CGPoint(x: 0, y: 0), CGPoint(x: 1, y: 1))
        gradient.startPoint = points.0
        gradient.endPoint = points.1
        view.layer.addSublayer(gradient)
        gradient.zPosition = -5
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
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches[touches.startIndex]
        self.lastLocation = touch.preciseLocation(in: view)
    }
}
