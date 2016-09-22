//
//  MusicViewController.swift
//  eminenceMusicPlayer
//
//  Created by Magfurul Abeer on 9/21/16.
//  Copyright © 2016 Magfurul Abeer. All rights reserved.
//

import UIKit
import MediaPlayer

class MusicViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, QuickBarDelegate {
    
    var musicManager = MusicManager.sharedManager
    var tableView = UITableView()
    var selectedCell: UITableViewCell?
    var selectedIndexPath: IndexPath?
    var savedSong: MPMediaItem?
    var savedTime: TimeInterval?
    var savedRepeatMode: MPMusicRepeatMode?
    var savedPlayerIsPlaying: MPMusicPlaybackState?
    var quickBar: NowPlayingQuickBar?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 42/255.0, green: 44/255.0, blue: 56/255.0, alpha: 1.0)
        setUpQuickBar()
        setUpTableView()
        quickBar?.delegate = self
    }
    
    func setUpQuickBar() {
        quickBar = NowPlayingQuickBar(frame: CGRect(x: 0, y: view.frame.height - tabBarHeight - quickBarHeight, width: view.frame.width, height: quickBarHeight))
        quickBar!.backgroundColor = UIColor.red
        view.addSubview(quickBar!)
        quickBar!.translatesAutoresizingMaskIntoConstraints = false
        quickBar!.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor).isActive = true
        quickBar!.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        quickBar!.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        quickBar!.heightAnchor.constraint(equalToConstant: quickBarHeight).isActive = true
    }
    
    func setUpTableView() {
        tableView.backgroundColor = UIColor.clear
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(MusicViewController.handleLongPress(sender:)))
        tableView.addGestureRecognizer(longPressGestureRecognizer)
        tableView.register(UINib(nibName: "BasicSongCell", bundle: Bundle.main), forCellReuseIdentifier: "BasicCell")
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        //tableView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: quickBar!.topAnchor).isActive = true
        tableView.reloadData()
    }
    func handleLongPress(sender: UILongPressGestureRecognizer) {
        if sender.state == UIGestureRecognizerState.began {
            // Will be needed at the end
            savedPlayerIsPlaying = musicManager.player.playbackState
            print(savedPlayerIsPlaying?.rawValue)
            musicManager.player.pause()
            let point = sender.location(in: tableView)
            let indexPath = tableView.indexPathForRow(at: point)!
            startSamplingMusic(atIndexPath: indexPath)
        }
        if sender.state == UIGestureRecognizerState.changed {
            let point = sender.location(in: tableView)
            let indexPath = tableView.indexPathForRow(at: point)!
            if indexPath != selectedIndexPath {
                musicManager.player.pause()
                selectedCell?.backgroundColor = UIColor.clear
                startSamplingMusic(atIndexPath: indexPath)
            }
        }
        if sender.state == UIGestureRecognizerState.ended || sender.state == UIGestureRecognizerState.cancelled {
            endSamplingMusic()
        }
        
    }
    
    func startSamplingMusic(atIndexPath indexPath: IndexPath) {
        //This is needed if touch moves to another cell
        NotificationCenter.default.post(name: NSNotification.Name.MPMusicPlayerControllerNowPlayingItemDidChange, object: nil)        
        musicManager.currentlySampling = true
        selectedIndexPath = indexPath
        
        // These will be needed when the touch ends
        savedSong = musicManager.player.nowPlayingItem
        savedTime = musicManager.player.currentPlaybackTime
        savedRepeatMode = musicManager.player.repeatMode
        selectedCell = tableView.cellForRow(at: indexPath)
        
        // Visuals
        selectedCell?.backgroundColor = UIColor.black
        
        // Audio
        let song = musicManager.songList[indexPath.row]
        musicManager.player.shuffleMode = MPMusicShuffleMode.off
        musicManager.player.repeatMode = MPMusicRepeatMode.one // In case held till end of song
        musicManager.player.nowPlayingItem = song
        musicManager.player.currentPlaybackTime = song.playbackDuration/2
        musicManager.player.prepareToPlay()
        musicManager.player.play()
    }
    
    func changeSamplingMusic(atIndexPath indexPath: IndexPath) {
        //This is needed if touch moves to another cell
        selectedIndexPath = indexPath
        
        // Visuals
        selectedCell?.backgroundColor = UIColor.black
        
        // Audio
        let song = musicManager.songList[indexPath.row]
        musicManager.player.nowPlayingItem = song
        musicManager.player.currentPlaybackTime = song.playbackDuration/2
        musicManager.player.prepareToPlay()
        musicManager.player.play()

    }
    
    func endSamplingMusic() {
        musicManager.currentlySampling = false
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SamplingDidEnd"), object: nil)
        // Return visual to normal
        selectedCell?.backgroundColor = UIColor.clear
        
        // Return audio to normal
        musicManager.player.pause()
        musicManager.player.shuffleMode = musicManager.shuffleIsOn ? .songs : .off
        musicManager.player.repeatMode = savedRepeatMode!
        musicManager.player.nowPlayingItem = savedSong
        musicManager.player.currentPlaybackTime = savedTime!
        if savedPlayerIsPlaying == MPMusicPlaybackState.playing {
            musicManager.player.play()
        } else if savedPlayerIsPlaying == MPMusicPlaybackState.stopped {
            musicManager.player.stop()
        }
        
        // Release all saved properties
        savedPlayerIsPlaying = nil
        savedRepeatMode = nil
        savedTime = nil
        savedSong = nil
        selectedIndexPath = nil
        selectedCell = nil
        savedPlayerIsPlaying = nil
    }
    
    func quickBarWasTapped(sender: NowPlayingQuickBar) {
        performSegue(withIdentifier: "NowPlayingSegue", sender: nil)
    }
    

}
