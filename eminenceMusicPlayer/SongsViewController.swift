//
//  SongsViewController.swift
//  eminenceMusicPlayer
//
//  Created by Magfurul Abeer on 10/3/16.
//  Copyright © 2016 Magfurul Abeer. All rights reserved.
//

import UIKit
import MediaPlayer

// TODO: Share setUpIndexView code between the menuviewcontrollers


/// View controller that shows a table of all the songs
class SongsViewController: MenuViewController, UITableViewDelegate, UITableViewDataSource, PreviewableDraggable {

    
    
    // MARK: Properties
    
    
    
    /// Reference to the MusicManager singleton instance.
    let musicManager = MusicManager.sharedManager
    
    /// The index View (TableView) that needs it's items to be previewable.    
    var indexView: IndexView = VolumeControllableTableView()
    
    /// Allows base class methods to have access to indexView
    override var storedIndexView: IndexView? {  get { return indexView }    }

    
    
    // MARK: Previewable Properties
    
    
    
    /// Cell/Item being previewed.
    var selectedCell: IndexViewCell?
    
    /// Index path of the cell/item being previewed.
    var selectedIndexPath: IndexPath?
    
    
    
    // MARK: Draggable Properties
    
    
    
    /// A snapshot taken of the cell mainly to drag around.
    var cellSnapshot: UIView = UIView()
    
    /// The index path of cell being dragged.
    var initialIndexPath: IndexPath?
    
    /// Whether or not a cell is being dragged.
    var currentlyDragging: Bool = false
    
    /// A label that functions as a delete button.
    var deleteLabel: UILabel?
    
    
    
    // MARK: View Management Method
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.clear
        setUpIndexView()
        NotificationCenter.default.addObserver(self, selector: #selector(itemDidChange), name: NSNotification.Name.MPMusicPlayerControllerNowPlayingItemDidChange, object: nil)
    }
    
    
    
    // MARK: Setup Methods

    /**
     Constrain index view. Sets its delegates, color, constraints, and gestures. Then reloads it.
     */
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
//        let song = musicManager.songList[indexPath.row]
        
//        print(song.artwork != nil)
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
    
    
    
    /**
     Returns the Media Item that is about to be previewed.
     
     - Parameters:
     - indexPath: IndexPath of the selected cell/item
     
     - Returns: The Media Item that is about to be previewed
     */
    func selectedSongForPreview(indexPath: IndexPath) -> MPMediaItem {
        let song = musicManager.songList[indexPath.row]
        return song
    }
    
    
    /**
     Sets the queue for previewing. The queue would be unique to the Previewable object.
     
     - Parameters:
     - indexPath: IndexPath of the selected cell/item
     */
    func setQueue(indexPath:IndexPath) {
        musicManager.player.setQueue(with: MPMediaItemCollection(items: musicManager.originalSongList))
        musicManager.player.beginGeneratingPlaybackNotifications()
        musicManager.player.stop()
    }
    
    
    /**
     Sets a new queue when changing the previewing song. Depending on the Previewable object, can be empty.
     
     - Parameters:
     - indexPath: IndexPath of the selected cell/item
     */
    func setNewQueue(indexPath:IndexPath) { }
    
    
    /**
     Whether or not the given index path is nonpreviewable. No index paths are excluded.
     
     - Parameters:
     - indexPath: IndexPath of the selected cell/item
     
     - Returns: Boolean representing whether or not the index path is exluded from previewing
     */
    func indexPathIsExcluded(indexPath: IndexPath?) -> Bool { return false }
    
    
    
    // MARK: Draggable Methods
    
    
    
    /**
     Offset of the cell that can trigger a drag AKA contains the album image.
     
     - Returns: CGFloat of the offset that contains the album image
     */
    func draggingOffset() -> CGFloat {
        return SongCellHeight * 0.9
    }
    
    
    
    // MARK: Gesture Recognizer & Notification Methods
    
    func itemDidChange() {
        indexView.reload()
    }
    
    func longPress(sender: UILongPressGestureRecognizer) {
        handleLongPress(sender: sender)
    }

}
