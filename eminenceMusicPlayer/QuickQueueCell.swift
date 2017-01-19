//
//  QuickQueueCell.swift
//  eminenceMusicPlayer
//
//  Created by Magfurul Abeer on 9/30/16.
//  Copyright © 2016 Magfurul Abeer. All rights reserved.
//

import UIKit
import MediaPlayer

class QuickQueueCell: UITableViewCell, UITableViewDataSource, UITableViewDelegate, PreviewableDraggable {

    var indexView: IndexView = UITableView()
    let musicManager = MusicManager.sharedManager
    weak var viewController: UIViewController? {
        didSet {
            self.setUpDeleteLabel()
        }
    }
    
    // MARK: Previewable Properties
    
    var selectedCell: IndexViewCell?
    var selectedIndexPath: IndexPath?
    
    
    // MARK: Draggable Properties
    
    var cellSnapshot: UIView = UIView()
    var initialIndexPath: IndexPath?
    var currentlyDragging: Bool = false
    var deleteLabel: UILabel? = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor.clear
        setUpTableView()
        NotificationCenter.default.addObserver(self, selector: #selector(self.queueWasChanged), name: NSNotification.Name(rawValue: "AddedToQueue"), object: nil)
    }
    
    func queueWasChanged() {
        indexView.reload()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpTableView() {
        guard let indexView = indexView as? UITableView else { return }

        indexView.delegate = self
        indexView.dataSource = self
        indexView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        contentView.addSubview(indexView)
        indexView.separatorStyle = UITableViewCellSeparatorStyle.none
        indexView.bounces = false
        indexView.register(UINib(nibName: "SongCell", bundle: Bundle.main), forCellReuseIdentifier: "SongCell")
        
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.longPress(sender:)))
        longPressGestureRecognizer.minimumPressDuration = 0.3
        indexView.addGestureRecognizer(longPressGestureRecognizer)
        
        indexView.translatesAutoresizingMaskIntoConstraints = false
        indexView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        indexView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        indexView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        indexView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        indexView.reloadData()
    }
    
    func setUpDeleteLabel() {
        guard let view = viewController?.view else { return }
        guard let deleteLabel = self.deleteLabel else { return }
        
        deleteLabel.text = "DELETE"
        deleteLabel.backgroundColor = #colorLiteral(red: 0.3176470697, green: 0.07450980693, blue: 0.02745098062, alpha: 1)
        deleteLabel.textColor = UIColor.white.withAlphaComponent(0.8)
        deleteLabel.textAlignment = .center
        deleteLabel.font = UIFont(name: "Avenir", size: 20)
        
        view.addSubview(deleteLabel)
        deleteLabel.translatesAutoresizingMaskIntoConstraints = false
        deleteLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        deleteLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        deleteLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        deleteLabel.heightAnchor.constraint(equalToConstant: quickBarHeight).isActive = true
        deleteLabel.isHidden = true
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return musicManager.quickQueue.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let song = musicManager.quickQueue[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "SongCell", for: indexPath) as! SongCell
        cell.titleLabel.text = song.title
        cell.artist = song.artist != nil ? song.artist! : ""
        cell.album = song.albumTitle != nil ? song.albumTitle! : ""
        cell.durationLabel.text = song.playbackDuration.stringFormat()
        cell.albumImage = song.artwork?.image(at: CGSize(width: SongCellHeight, height: SongCellHeight))
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        musicManager.player.pause()
        musicManager.player.shuffleMode = MPMusicShuffleMode.off
        let song = musicManager.quickQueue[indexPath.row]

        musicManager.player = MPMusicPlayerController.systemMusicPlayer()
        musicManager.player.setQueue(with: MPMediaItemCollection(items: musicManager.quickQueue))
        musicManager.player.beginGeneratingPlaybackNotifications()
        musicManager.player.stop()
        musicManager.player.nowPlayingItem = nil
        musicManager.itemNowPlaying = song
        
        guard let viewController = viewController else {    return  }
        
        if let nowPlayingVC = viewController.storyboard!.instantiateViewController(withIdentifier: "NowPlayingViewController") as? NowPlayingViewController {
            nowPlayingVC.transitioningDelegate = self.viewController as! MusicPlayerViewController
            nowPlayingVC.interactor = (self.viewController as! MusicPlayerViewController).slideDownInteractor
            viewController.present(nowPlayingVC, animated: true, completion: nil)
        }
    }
    
    // MARK: Previewable Methods
    
    func selectedSongForPreview(indexPath: IndexPath) -> MPMediaItem {
        let song = musicManager.quickQueue[indexPath.row]
        return song
    }
    
    func setQueue(indexPath:IndexPath) {
        musicManager.player.setQueue(with: MPMediaItemCollection(items: musicManager.songList))
        musicManager.player.beginGeneratingPlaybackNotifications()
        musicManager.player.stop()
    }
    
    func setNewQueue(indexPath:IndexPath) { }
    
    func indexPathIsExcluded(indexPath: IndexPath?) -> Bool {
        return false
    }
    
    // MARK: Draggable Methods
    
    func draggingOffset() -> CGFloat {
        return SongCellHeight * 0.9
    }
    
    func canDelete() -> Bool {
        return true
    }
    
    func didDeleteItemAtPath(indexPath: IndexPath) {
        guard let indexView = indexView as? UITableView else { return }
        guard let deleteLabel = deleteLabel else { return }
        
        let playingSongWasDeleted = musicManager.itemNowPlaying == musicManager.quickQueue[indexPath.row]
        musicManager.quickQueue.remove(at: indexPath.row)
        indexView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
        indexView.reloadData()
        deleteLabel.isHidden = true

        guard playingSongWasDeleted else { return }
        musicManager.player.nowPlayingItem = nil
        musicManager.player.setQueue(with: MPMediaItemCollection(items: musicManager.quickQueue))
        if musicManager.quickQueue.count > indexPath.row {
            musicManager.player.nowPlayingItem = musicManager.quickQueue[indexPath.row]
        } else {
            musicManager.player.stop()
        }
    }
    
    
    // MARK: Gesture Recognizer Methods
    
    func longPress(sender: UILongPressGestureRecognizer) {
        handleLongPress(sender: sender)
    }
}
