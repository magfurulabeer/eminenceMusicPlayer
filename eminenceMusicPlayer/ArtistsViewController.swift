//
//  ArtistsViewController.swift
//  eminenceMusicPlayer
//
//  Created by Magfurul Abeer on 10/3/16.
//  Copyright © 2016 Magfurul Abeer. All rights reserved.
//

import UIKit

class ArtistsViewController: MenuViewController, UITableViewDelegate, UITableViewDataSource {

    let musicManager = MusicManager.sharedManager
    var indexView: IndexView = UITableView()
    override var storedIndexView: IndexView? {  get { return indexView }    }
    
    override var index: Int {
        get {
            return 1
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

}
