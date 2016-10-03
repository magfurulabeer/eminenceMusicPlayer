//
//  SongsViewController.swift
//  eminenceMusicPlayer
//
//  Created by Magfurul Abeer on 10/3/16.
//  Copyright © 2016 Magfurul Abeer. All rights reserved.
//

import UIKit
import MediaPlayer


class SongsViewController: MenuViewController, UITableViewDelegate, UITableViewDataSource, PreviewableDraggable {

    
    // MARK: Properties
    
    let musicManager = MusicManager.sharedManager
    var indexView: IndexView = UITableView()
    override var storedIndexView: IndexView? {  get { return indexView }    }

    
    // MARK: Previewable Properties
    
    var selectedCell: IndexViewCell?
    var selectedIndexPath: IndexPath?
    
    
    // MARK: Draggable Properties
    var cellSnapshot: UIView = UIView()
    var initialIndexPath: IndexPath?
   
    // MARK: View Management Method
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.clear
        setUpIndexView()
    }
    
    // MARK: Setup Methods

    func setUpIndexView() {
        guard let indexView = indexView as? UITableView else { return }
        
        indexView.delegate = self
        indexView.dataSource = self
        indexView.backgroundColor = UIColor.clear
        indexView.separatorStyle = UITableViewCellSeparatorStyle.none
        
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.longPress(sender:)))
        longPressGestureRecognizer.minimumPressDuration = 0.3
        indexView.addGestureRecognizer(longPressGestureRecognizer)
        
        indexView.register(UINib(nibName: "SongCell", bundle: Bundle.main), forCellReuseIdentifier: "SongCell")
        indexView.register(UINib(nibName: "SelectedSongCell", bundle: Bundle.main), forCellReuseIdentifier: "SelectedSongCell")
        
        constrainIndexView()
        
        indexView.reloadData()
    }
    
    // MARK: UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return musicManager.songList.count
    }
    
    // TODO: DRY this code. Perhaps make SelectedSongCell inherit from SongCell and downcast it when necessary?
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let song = musicManager.songList[indexPath.row]
        
        if song == musicManager.itemNowPlaying {
            let cell =  tableView.dequeueReusableCell(withIdentifier: "SelectedSongCell", for: indexPath) as! SelectedSongCell
            cell.titleLabel.text = song.title
            cell.artist = song.artist != nil ? song.artist! : ""
            cell.album = song.albumTitle != nil ? song.albumTitle! : ""
            cell.durationLabel.text = song.playbackDuration.stringFormat()
            cell.albumImage = song.artwork?.image(at: CGSize(width: SongCellHeight, height: SongCellHeight))
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            cell.addGradient()
            return cell
        } else {
            let cell =  tableView.dequeueReusableCell(withIdentifier: "SongCell", for: indexPath) as! SongCell
            cell.titleLabel.text = song.title
            cell.artist = song.artist != nil ? song.artist! : ""
            cell.album = song.albumTitle != nil ? song.albumTitle! : ""
            cell.durationLabel.text = song.playbackDuration.stringFormat()
            cell.albumImage = song.artwork?.image(at: CGSize(width: SongCellHeight, height: SongCellHeight))
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            return cell
        }
    }
    
    // MARK: UITableViewDelegate

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return SongCellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let song = musicManager.songList[indexPath.row]
        
        print(song.artwork != nil)
        musicManager.player = MPMusicPlayerController.systemMusicPlayer()
        musicManager.currentQueue = MPMediaItemCollection(items: musicManager.originalSongList)
        musicManager.player.setQueue(with: musicManager.currentQueue!)
        musicManager.player.beginGeneratingPlaybackNotifications()
        musicManager.player.stop()
        musicManager.player.nowPlayingItem = nil
        musicManager.itemNowPlaying = musicManager.songList[indexPath.row]
        
        guard let viewController = viewController else {    return  }
        
        if let nowPlayingVC = viewController.storyboard!.instantiateViewController(withIdentifier: "NowPlayingViewController") as? NowPlayingViewController {
            nowPlayingVC.transitioningDelegate = self.viewController as! MusicPlayerViewController
            nowPlayingVC.interactor = (self.viewController as! MusicPlayerViewController).slideDownInteractor
            viewController.present(nowPlayingVC, animated: true, completion: nil)
        }
    }
    
    // MARK: Previewable Methods
    
    func selectedSongForPreview(indexPath: IndexPath) -> MPMediaItem {
        let song = musicManager.songList[indexPath.row]
        return song
    }
    
    func setQueue(indexPath:IndexPath) {
        musicManager.player.setQueue(with: MPMediaItemCollection(items: musicManager.originalSongList))
        musicManager.player.beginGeneratingPlaybackNotifications()
        musicManager.player.stop()
    }
    
    func setNewQueue(indexPath:IndexPath) { }
    
    func indexPathIsExcluded(indexPath: IndexPath) -> Bool {
        return false
    }
    
    // MARK: Draggable Methods
    
    func draggingOffset() -> CGFloat {
        return SongCellHeight * 0.9
    }
    
    // MARK: Gesture Recognizer Methods
    
    func longPress(sender: UILongPressGestureRecognizer) {
        handleLongPress(sender: sender)
    }

}
