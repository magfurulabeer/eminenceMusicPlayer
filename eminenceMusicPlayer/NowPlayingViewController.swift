//
//  NowPlayingViewController.swift
//  eminenceMusicPlayer
//
//  Created by Magfurul Abeer on 9/21/16.
//  Copyright © 2016 Magfurul Abeer. All rights reserved.
//

import UIKit
import MediaPlayer
import CoreData

// TODO: When song starts, 00:01 is skipped and the timer starts it at 00:00
class NowPlayingViewController: UIViewController, SeekbarDelegate, VolumeControllable {

    
    @IBOutlet weak var albumImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var albumLabel: UILabel!
    @IBOutlet weak var slider: Seekbar!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var controlsStackView: UIStackView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var repeatButton: UIButton!
    @IBOutlet weak var shuffleButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var fauxNavBar: UIView!
    @IBOutlet weak var speedButton: UIButton!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    var musicManager = MusicManager.sharedManager
    var timer = Timer()
    var interactor: SlideDownInteractor? //= SlideDownInteractor()
    var sliderWasJustChanged = false
    
    
    
    // MARK: VolumeControllable Properties
    
    
    
    /// Reference to view
    var controllableView: UIView { get { return view } }
    
    /// The last location of the drag
    var lastLocation: CGPoint = CGPoint(x: 0, y: 0)

    
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
        slider.setThumbImage(#imageLiteral(resourceName: "Thumb"), for: UIControlState.normal)
        slider.setThumbImage(#imageLiteral(resourceName: "Thumb"), for: UIControlState.highlighted)
        slider.delegate = self
        // Shuffle is turned off whenever a cell is selected to ensure current song was picked
        // This just turns it back on if needed
        musicManager.player.shuffleMode = musicManager.shuffleIsOn ? .songs : .off
        
        displayReplayStatus()
        displayShuffleStatus()
        NotificationCenter.default.addObserver(self, selector: #selector(NowPlayingViewController.displayMediaData), name:NSNotification.Name.MPMusicPlayerControllerNowPlayingItemDidChange, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(NowPlayingViewController.displayPlaybackButton), name:NSNotification.Name.MPMusicPlayerControllerPlaybackStateDidChange, object: nil)

        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(NowPlayingViewController.detectDrag(sender:)))
        panGestureRecognizer.minimumNumberOfTouches = 2;
        view.addGestureRecognizer(panGestureRecognizer)
        
        albumImageView.layer.borderColor = UIColor.white.withAlphaComponent(0.1).cgColor
        albumImageView.layer.borderWidth = 1
        
        albumImageView.isUserInteractionEnabled = true
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(albumImageWasDoubleTapped(sender:)))
        doubleTap.numberOfTapsRequired = 2
        albumImageView.addGestureRecognizer(doubleTap)
        
//        let artistFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "EMArtist")
//        
//        do {
//            print("do statement")
//            let fetchedArtists = try musicManager.persistentContainer.viewContext.fetch(artistFetchRequest) as! [EMArtist]
//            for artist in fetchedArtists {
//                print("ARTIST: \(artist.id)")
//            }
//        } catch {
//            fatalError("Failed to fetch employees: \(error)")
//        }

    }
    
    func albumImageWasDoubleTapped(sender: UITapGestureRecognizer) {
        print("DOUBLE TAP")
        guard let item = musicManager.itemNowPlaying else { return }
        let artwork = item.artwork?.image(at: albumImageView.frame.size)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        let currentTime: Double = self.musicManager.player.currentPlaybackTime
        let duration: Double = (self.musicManager.itemNowPlaying?.playbackDuration)!
        self.currentTimeLabel.text = self.musicManager.player.currentPlaybackTime.stringFormat()
        self.slider.value = Float(currentTime/duration)
        displayPlaybackButton()
        displayPlaybackRate()
    }

    func displayPlaybackButton() {
        if musicManager.player.playbackState == MPMusicPlaybackState.playing {
            playButton.isHidden = true
            pauseButton.isHidden = false
            startTimer()
        } else {
            playButton.isHidden = false
            pauseButton.isHidden = true
        }
    }
    
    func displayPlaybackRate() {
        switch musicManager.player.currentPlaybackRate {
        case 0.5:
            speedButton.title = "0.5x"
            break
        case 1:
            speedButton.title = "1x"
            break
        case 1.5:
            speedButton.title = "1.5x"
            break
        case 2:
            speedButton.title = "2x"
            break
        default:
            break
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
        didTwoFingerDrag(sender: sender)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches[touches.startIndex]
        self.lastLocation = touch.preciseLocation(in: view)
    }
    
    
    @IBAction func fauxNavBarWasDragged(_ sender: UIPanGestureRecognizer) {
        let threshold: CGFloat = 0.3
        
        // convert y-position to downward pull progress (percentage)
        let translation = sender.translation(in: view)
        let verticalDisplacement = translation.y / view.bounds.height
        let downwardMovement = fmaxf(Float(verticalDisplacement), 0.0)
        let downwardMovementPercent = fminf(downwardMovement, 1.0)
        let progress = CGFloat(downwardMovementPercent)
        
        guard let interactor = interactor else {
            return
        }
        
        switch sender.state {
        case .began:
            interactor.hasStarted = true
            dismiss(animated: true, completion: nil)
            break
        case .changed:
            interactor.shouldFinish = progress > threshold
            interactor.update(progress)
            break
        case .cancelled:
            interactor.hasStarted = false
            interactor.cancel()
            break
        case .ended:
            interactor.hasStarted = false
            interactor.shouldFinish
                ? interactor.finish()
                : interactor.cancel()
            break
            
        default:
            break
        }
    }
    
    @IBAction func speedButtonWasTapped(_ sender: UIButton) {
        switch speedButton.titleLabel!.text! {
        case "1x":
            speedButton.title = "1.5x"
            musicManager.player.currentPlaybackRate = 1.5
            break
        case "1.5x":
            speedButton.title = "2x"
            musicManager.player.currentPlaybackRate = 2
            break
        case "2x":
            speedButton.title = "0.5x"
            musicManager.player.currentPlaybackRate = 0.5
            break
        case "0.5x":
            speedButton.title = "1x"
            musicManager.player.currentPlaybackRate = 1
            break
        default:
            break
        }
        if musicManager.player.playbackState != .playing {
            musicManager.player.pause()
        }
    }
    
    func seekbarWillChangeValue() {
        timer.invalidate()
        sliderWasJustChanged = true
    }
    
    func seekbarDidChangeValue() {
        sliderValueChanged(slider)
    }
}
