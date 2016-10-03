//
//  SongsViewController.swift
//  eminenceMusicPlayer
//
//  Created by Magfurul Abeer on 10/3/16.
//  Copyright © 2016 Magfurul Abeer. All rights reserved.
//

import UIKit
import MediaPlayer


class SongsViewController: MenuViewController, UITableViewDelegate, UITableViewDataSource {

    let musicManager = MusicManager.sharedManager
    var indexView: IndexView = UITableView()
    override var storedIndexView: IndexView? {  get { return indexView }    }
    override var index: Int {
        get {
            return 2
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.clear
        setUpIndexView()
    }
    
    func setUpIndexView() {
        guard let indexView = indexView as? UITableView else { return }
        
        indexView.delegate = self
        indexView.dataSource = self
        indexView.backgroundColor = UIColor.clear
        indexView.separatorStyle = UITableViewCellSeparatorStyle.none
        
//        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.longPress(sender:)))
//        longPressGestureRecognizer.minimumPressDuration = 0.3
//        indexView.addGestureRecognizer(longPressGestureRecognizer)
        
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
        
        if song == musicManager.itemNowPlaying && musicManager.currentQueue == MPMediaItemCollection(items: musicManager.songList) {
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
    

}
