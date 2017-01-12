//
//  ArtistsViewController.swift
//  eminenceMusicPlayer
//
//  Created by Magfurul Abeer on 10/3/16.
//  Copyright © 2016 Magfurul Abeer. All rights reserved.
//

import UIKit
import MediaPlayer

// TODO: Share setUpIndexView code between the menuviewcontrollers
// TODO: Have gesture point directly to handleLongPress

/// View controller that shows a table of all the artists
class ArtistsViewController: MenuViewController, UITableViewDelegate, UITableViewDataSource, Previewable {

    
    
    // MARK: Properties 
    
    
    
    /// Reference to the MusicManager singleton instance.
    let musicManager = MusicManager.sharedManager
    
    /// Allows base class methods to have access to indexView
    var indexView: IndexView = VolumeControllableTableView()
    
    /// Allows base class methods to have access to indexView
    override var storedIndexView: IndexView? {  get { return indexView }    }
    
    
    
    // MARK: Previewable Properties

    
    
    /// Cell/Item being previewed.
    var selectedCell: IndexViewCell?
    
    /// Index path of the cell/item being previewed.
    var selectedIndexPath: IndexPath?
    
    
    // MARK: View Management Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.clear
        setUpIndexView()
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
        
        indexView.register(UINib(nibName: "ArtistCell", bundle: Bundle.main), forCellReuseIdentifier: "ArtistCell")

        constrainIndexView()
        
        indexView.reloadData()
    }
    
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
        cell.albumImageView?.image = artist.representativeItem?.artwork?.image(at: CGSize(width: SongCellHeight, height: SongCellHeight)) ?? #imageLiteral(resourceName: "NoAlbumImage")
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.backgroundColor = UIColor.clear
        
        return cell
    }
    
    
    
    // MARK: UITableViewDelegate
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return SongCellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let artist = musicManager.artistList[indexPath.row]
        
        let size = view.frame.size
        let rect = CGRect(x: topPadding, y: 0, width: size.width, height: size.height - topPadding - bottomPadding)
        let artistDetailsView = ArtistDetailsView(frame: rect)
        artistDetailsView.artist = artist
        artistDetailsView.viewController = viewController
        view.addSubview(artistDetailsView)

        artistDetailsView.translatesAutoresizingMaskIntoConstraints = false
        artistDetailsView.topAnchor.constraint(equalTo: view.topAnchor, constant: topPadding).isActive = true
        artistDetailsView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: bottomPadding).isActive = true
        artistDetailsView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        artistDetailsView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true

    }
    
    
    // MARK: Previewable Methods
    
    
    
    /**
     Returns the Media Item that is about to be previewed.
     
     - Parameters:
     - indexPath: IndexPath of the selected cell/item
     
     - Returns: The Media Item that is about to be previewed
     */
    func selectedSongForPreview(indexPath: IndexPath) -> MPMediaItem {
        let artist = musicManager.artistList[indexPath.row]
        let randomNumber = arc4random_uniform(UInt32(artist.count))
        let song = artist.items[Int(randomNumber)]
        return song
    }
    
    
    /**
     Sets the queue for previewing. The queue would be unique to the Previewable object.
     
     - Parameters:
     - indexPath: IndexPath of the selected cell/item
     */
    func setQueue(indexPath:IndexPath) {
        let artist = musicManager.artistList[indexPath.row]
        musicManager.player.setQueue(with: MPMediaItemCollection(items: artist.items))
        musicManager.player.beginGeneratingPlaybackNotifications()
        musicManager.player.stop()
    }
    
    
    /**
     Sets a new queue when changing the previewing song. Depending on the Previewable object, can be empty.
     
     - Parameters:
     - indexPath: IndexPath of the selected cell/item
     */
    func setNewQueue(indexPath:IndexPath) {
        setQueue(indexPath: indexPath)
    }
    
    
    /**
     Whether or not the given index path is nonpreviewable. No index paths are excluded.
     
     - Parameters:
     - indexPath: IndexPath of the selected cell/item
     
     - Returns: Boolean representing whether or not the index path is exluded from previewing
     */
    func indexPathIsExcluded(indexPath: IndexPath?) -> Bool {
        return false
    }
    
    // MARK: Gesture Recognizer Methods
    
    func longPress(sender: UILongPressGestureRecognizer) {
        handleLongPress(sender: sender)
    }

}
