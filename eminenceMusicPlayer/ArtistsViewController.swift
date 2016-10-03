//
//  ArtistsViewController.swift
//  eminenceMusicPlayer
//
//  Created by Magfurul Abeer on 10/3/16.
//  Copyright © 2016 Magfurul Abeer. All rights reserved.
//

import UIKit
import MediaPlayer

class ArtistsViewController: MenuViewController, UITableViewDelegate, UITableViewDataSource, Previewable {

    
    // MARK: Properties 
    
    let musicManager = MusicManager.sharedManager
    var indexView: IndexView = UITableView()
    override var storedIndexView: IndexView? {  get { return indexView }    }
    
    
    // MARK: Previewable Properties

    var selectedCell: IndexViewCell?
    var selectedIndexPath: IndexPath?
    
    
    // MARK: View Management Methods

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
        
        indexView.register(UINib(nibName: "ArtistCell", bundle: Bundle.main), forCellReuseIdentifier: "ArtistCell")

        constrainIndexView()
        
        indexView.reloadData()
    }
    
    // MARK: UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return musicManager.artistList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let artist = musicManager.artistList[indexPath.row]
        
        let cell =  tableView.dequeueReusableCell(withIdentifier: "ArtistCell", for: indexPath) as! ArtistCell
        cell.artistLabel?.text = artist.representativeItem?.artist
        cell.albumImageView?.image = artist.representativeItem?.artwork?.image(at: CGSize(width: SongCellHeight, height: SongCellHeight))
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.backgroundColor = UIColor.clear
        
        return cell
    }
    
    // MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return SongCellHeight
    }
    
    // MARK: Previewable Methods
    
    func selectedSongForPreview(indexPath: IndexPath) -> MPMediaItem {
        let artist = musicManager.artistList[indexPath.row]
        let randomNumber = arc4random_uniform(UInt32(artist.count))
        let song = artist.items[Int(randomNumber)]
        return song
    }
    
    func setQueue(indexPath:IndexPath) {
        let artist = musicManager.artistList[indexPath.row]
        musicManager.player.setQueue(with: MPMediaItemCollection(items: artist.items))
        musicManager.player.beginGeneratingPlaybackNotifications()
        musicManager.player.stop()
    }
    
    func setNewQueue(indexPath:IndexPath) {
        setQueue(indexPath: indexPath)
    }
    
    func indexPathIsExcluded(indexPath: IndexPath) -> Bool {
        return false
    }
    
    // MARK: Gesture Recognizer Methods
    
    func longPress(sender: UILongPressGestureRecognizer) {
        handleLongPress(sender: sender)
    }

}
