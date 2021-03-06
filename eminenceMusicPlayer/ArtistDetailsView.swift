//
//  ArtistDetailsView.swift
//  eminenceMusicPlayer
//
//  Created by Magfurul Abeer on 1/12/17.
//  Copyright © 2017 Magfurul Abeer. All rights reserved.
//

import UIKit
import MediaPlayer
import CoreData

class ArtistDetailsView: UIView, UITableViewDataSource, UITableViewDelegate, PreviewableDraggable {

    // MARK: Properties
    
    let musicManager = MusicManager.sharedManager
    var artist: MPMediaItemCollection?
    weak var viewController: UIViewController?
    var summaryIsHidden = true
    
    lazy var indexView: IndexView = {
        let tv = VolumeControllableTableView()
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
        indexView.register(UINib(nibName: "AlbumImageCell", bundle: Bundle.main), forCellReuseIdentifier: "AlbumImageCell")
        indexView.register(UINib(nibName: "ArtistHeaderCell", bundle: Bundle.main), forCellReuseIdentifier: "ArtistHeaderCell")
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
        return (artist?.count ?? 0) + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//        ArtistHeaderCell
        if indexPath.row == 0 {
            print(artist?.representativeItem?.artistPersistentID)
            if let id = artist?.representativeItem?.artistPersistentID {
                let artistFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "EMArtist")
                artistFetchRequest.predicate = NSPredicate(format: "id == %llu", id)
                
                do {
                    let fetchedArtists = try musicManager.persistentContainer.viewContext.fetch(artistFetchRequest) as! [EMArtist]
                    
                    if let fetchedArtist = fetchedArtists.first {
                        let cell = tableView.dequeueReusableCell(withIdentifier: "ArtistHeaderCell", for: indexPath) as! ArtistHeaderCell
    
                        let filename = getDocumentsDirectory().appendingPathComponent("\(id).png")
                        if let data = try? Data(contentsOf: filename) {
                            cell.artistImageView.image = UIImage(data: data)!
                        } else {
                            let albumImageSize = CGSize(width: frame.width, height: frame.width)
                            cell.artistImageView.image = artist?.representativeItem?.artwork?.image(at: albumImageSize) ?? #imageLiteral(resourceName: "NoAlbumImage")
                        }
                        
                        cell.bioLabel.text = fetchedArtist.summary ?? "NO SUMMARY FOUND"

                        if summaryIsHidden {
                            cell.bioLabel.isHidden = true
                        } else {
                            cell.bioLabel.isHidden = false
                        }
                        cell.bioLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
                        return cell
                    } 
                    
                    
                } catch {
                    fatalError("Failed to fetch artist: \(error)")
                }

            }
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "AlbumImageCell", for: indexPath) as! AlbumImageCell
            let albumImageSize = CGSize(width: frame.width, height: frame.width)
            cell.albumImageView.image = artist?.representativeItem?.artwork?.image(at: albumImageSize) ?? #imageLiteral(resourceName: "NoAlbumImage")
            return cell
            
            
            
        } else {
            let song = artist?.items[indexPath.item - 1]
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
    }
    
    
    // MARK: TableViewDelegate Methods
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
//            let superView = superview
//            self.removeFromSuperview()
//            superView?.layoutIfNeeded()
            summaryIsHidden = !summaryIsHidden
            tableView.reloadData()
        } else {
            musicManager.player.pause()
            musicManager.player.shuffleMode = MPMusicShuffleMode.off
            
            let song = artist?.items[indexPath.row - 1]
            
            musicManager.player = MPMusicPlayerController.systemMusicPlayer()
            musicManager.currentQueue = MPMediaItemCollection(items: artist!.items)
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
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return frame.width
        }
        return SongCellHeight * 0.8
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
        //        print(contentViewHeight)
        //        print(scrollViewHeight)
        //        print(yOffset)
        //        print(scrollViewHeight + yOffset)
        //        print(contentViewHeight + scrollViewHeight * 0.15)
        //        print("\n\n")
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
        let song = artist!.items[indexPath.item - 1]
        return song
    }
    
    func setQueue(indexPath:IndexPath) {
        musicManager.player.setQueue(with: MPMediaItemCollection(items: artist!.items))
        musicManager.player.beginGeneratingPlaybackNotifications()
        musicManager.player.stop()
    }
    
    func setNewQueue(indexPath:IndexPath) { }
    
    func indexPathIsExcluded(indexPath: IndexPath?) -> Bool {
        guard let indexPath = indexPath else {  return true }
        if indexPath.row == 0 { return true }
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
