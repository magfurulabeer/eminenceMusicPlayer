//
//  PlaylistDetailsView.swift
//  eminenceMusicPlayer
//
//  Created by Magfurul Abeer on 10/5/16.
//  Copyright © 2016 Magfurul Abeer. All rights reserved.
//

import UIKit
import MediaPlayer

class PlaylistDetailsView: UIView, UITableViewDelegate, UITableViewDataSource, PreviewableDraggable {

    // MARK: Properties
    
    let musicManager = MusicManager.sharedManager
    var playlist: MPMediaPlaylist?
    weak var viewController: UIViewController?
    
    lazy var indexView: IndexView = {
        let tv = VolumeControllableTableView(frame: .zero, style: .grouped)
        tv.disableTwoFingerScroll()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = UIColor.clear
        tv.delegate = self
        tv.dataSource = self
        return tv
    }()
    
    // MARK: Previewable Properties
    
    var selectedCell: IndexViewCell?
    var selectedIndexPath: IndexPath?
    
    
    // MARK: Draggable Properties
    
    var cellSnapshot: UIView = UIView()
    var initialIndexPath: IndexPath?
    var currentlyDragging: Bool = false
    var deleteLabel: UILabel?
    
    
    // MARK: Init Methods
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpTableView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: Setup Methods
    
    func setUpTableView() {
        guard let indexView = indexView as? UITableView else { return }
        
        addSubview(indexView)
        indexView.register(UINib(nibName: "SongCell", bundle: Bundle.main), forCellReuseIdentifier: "SongCell")
        indexView.separatorStyle = .none
        
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.longPress(sender:)))
        longPressGestureRecognizer.minimumPressDuration = 0.3
        indexView.addGestureRecognizer(longPressGestureRecognizer)
        
        
        indexView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        indexView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        indexView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        indexView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    
    // MARK: TableViewDataSource Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        if let mediaPlaylist = playlist as? MediaPlaylist {
            count = mediaPlaylist.playlistCount
        } else {
            count = playlist?.count ?? 0
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

            var song: MPMediaItem? = MPMediaItem()
        
            if let mediaPlaylist = playlist as? MediaPlaylist {
                song = mediaPlaylist.songs[indexPath.row]
            } else {
                song = playlist?.items[indexPath.row]
            }
        
        
            let cell = tableView.dequeueReusableCell(withIdentifier: "SongCell", for: indexPath) as! SongCell
            cell.titleLabel.text = song?.title ?? "Unknown name"
            cell.artist = song?.artist ?? ""
            cell.album = song?.albumTitle! ?? ""
            cell.durationLabel.text = song?.playbackDuration.stringFormat() ?? ""
            cell.albumImage = song?.artwork?.image(at: CGSize(width: SongCellHeight, height: SongCellHeight)) ?? #imageLiteral(resourceName: "NoAlbumImage")
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            cell.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        
            return cell
    }
    
    
    // MARK: TableViewDelegate Methods
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

            musicManager.player.pause()
            musicManager.player.shuffleMode = MPMusicShuffleMode.off
            
            var song: MPMediaItem? = MPMediaItem()
            
            if let mediaPlaylist = playlist as? MediaPlaylist {
                song = mediaPlaylist.songs[indexPath.row]
            } else {
                song = playlist?.items[indexPath.row]
            }

        
            musicManager.player = MPMusicPlayerController.systemMusicPlayer()
            if let mediaPlaylist = playlist as? MediaPlaylist {
                musicManager.currentQueue = MPMediaItemCollection(items: mediaPlaylist.songs)
            } else {
                musicManager.currentQueue = playlist! //MPMediaItemCollection(items: playlist!.items)
                
            }
            musicManager.player.setQueue(with: musicManager.currentQueue!)
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return SongCellHeight * 0.8
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var title = "Unnamed Playlist"
        
        if let mediaPlaylist = playlist as? MediaPlaylist {
            title = mediaPlaylist.playlistName
        } else {
            title = playlist?.value(forProperty: MPMediaPlaylistPropertyName) as? String ?? "Unnamed Playlist"
        }
        
        return title
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else {
            return
        }
        header.backgroundView?.backgroundColor = UIColor.black.withAlphaComponent(0.95) //UIColor(red: 92/255.0, green: 46/255.0, blue: 46/255.0, alpha: 1)
        header.textLabel?.textColor = UIColor.white
        header.textLabel?.font = UIFont(name: "Avenir", size: 20)
        
    }
    
    
    // MARK: ScrollViewDelegate Methods
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let width = viewController?.view.frame.width ?? 0
        //        let height = self.bounds.width
        
        if scrollView.contentOffset.y <= -width * 0.215 {
            UIView.animate(withDuration: 0.3, animations: {
                self.center.y += self.frame.height
                }, completion: { (bool) in
                    let superView = self.superview
                    self.removeFromSuperview()
                    superView?.layoutIfNeeded()
            })
        }
        
        let scrollViewHeight = scrollView.frame.size.height
        let contentViewHeight = scrollView.contentSize.height
        let yOffset = scrollView.contentOffset.y
        if scrollViewHeight + yOffset > contentViewHeight + width * 0.215 {
            UIView.animate(withDuration: 0.3, animations: {
                self.center.y -= self.frame.height
                }, completion: { (bool) in
                    let superView = self.superview
                    self.removeFromSuperview()
                    superView?.layoutIfNeeded()
            })
        }
    }
    
    
    // MARK: Previewable Methods
    
    func selectedSongForPreview(indexPath: IndexPath) -> MPMediaItem {
        var song: MPMediaItem? = MPMediaItem()
        
        if let mediaPlaylist = playlist as? MediaPlaylist {
            song = mediaPlaylist.songs[indexPath.row]
        } else {
            song = playlist?.items[indexPath.row]
        }
        
        return song!
    }
    
    func setQueue(indexPath:IndexPath) {
        if let mediaPlaylist = playlist as? MediaPlaylist {
            musicManager.player.setQueue(with: MPMediaItemCollection(items: mediaPlaylist.songs))
        } else {
            musicManager.player.setQueue(with: playlist!)//MPMediaItemCollection(items: album!.items))
        }
        musicManager.player.beginGeneratingPlaybackNotifications()
        musicManager.player.stop()
    }
    
    func setNewQueue(indexPath:IndexPath) { }
    
    func indexPathIsExcluded(indexPath: IndexPath?) -> Bool {
        return false
    }
    
    func displayPreviewing(state: UIGestureRecognizerState, indexPath: IndexPath) {
        selectedCell?.cell.backgroundColor = UIColor(red: 92/255.0, green: 46/255.0, blue: 46/255.0, alpha: 0.9)
    }
    
    func revertVisuals() {
        selectedCell?.cell.backgroundColor = UIColor.black.withAlphaComponent(0.8)
    }
    
    func prepareForChange() {
        musicManager.player.pause()
        selectedCell?.cell.backgroundColor = UIColor.black.withAlphaComponent(0.8)
    }
    
    
    // MARK: Draggable Methods
    
    func draggingOffset() -> CGFloat {
        return SongCellHeight * 0.8
    }
    
    // MARK: Gesture Recognizer Methods
    
    func longPress(sender: UILongPressGestureRecognizer) {
        handleLongPress(sender: sender)
    }
    
    

}
