//
//  MusicPlayerViewController.swift
//  eminenceMusicPlayer
//
//  Created by Magfurul Abeer on 10/3/16.
//  Copyright © 2016 Magfurul Abeer. All rights reserved.
//

import UIKit
import MediaPlayer

/// This view controller is the main interface which the user will interact with. It's simply a collection view controller with the views of the 4 menu view controllers on each cell.
class MusicPlayerViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, QuickBarDelegate {
    
    
    
    // MARK: Properties
    
    
    
    /// The 4 menu view controllers in order
    var menuPages = [MenuViewController]()
    
    /// The menu bar (nav bar) on top
    var menuBar: MenuBar = MenuBar()
    
    /// The quick bar (now playing bar) on the bottom
    var quickBar: NowPlayingQuickBar?
    
    /// Transition interactor that allows the now playing view controller to be dragged down
    let slideDownInteractor = SlideDownInteractor()
    
    /// Reference to the MusicManager singleton instance.
    var musicManager = MusicManager.sharedManager
    
    // Use white text for status bar
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    
    // MARK: Lifecycle Methods
    
    
    
    /**
     Add the menu view controllers and set their delegate to self. Call setup methods from Setup extension.
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        menuPages.append(PlaylistsViewController())
        menuPages.append(SongsViewController())
        menuPages.append(ArtistsViewController())
        menuPages.append(AlbumsViewController())
        
        for menuVC in menuPages {
            menuVC.viewController = self
        }
        setUpCollectionView()
        setUpGradient()
        setUpMenuBar()
        setUpQuickBar()
        
    }
    
    
    
    // MARK: UIScrollViewDelegate Methods
    
    
    
    /**
     Returns the Media Item that is about to be previewed.
     */
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        menuBar.horizontalBarLeadingConstraint?.constant = scrollView.contentOffset.x/4 + view.frame.width/16
    }
    
    
    /**
     Move to another cell if scrolled enough
     */
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let currentPageIndex = targetContentOffset.pointee.x / view.frame.width
        menuBar.selectItemAtIndex(index: Int(currentPageIndex))
    }
    
    
    
    // MARK: UICollectionViewDataSource Methods
    
    
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menuPages.count
    }

    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FullScreenCell", for: indexPath) as! ViewControllerCollectionCell
        cell.backgroundColor = UIColor.clear
        cell.addView(view: menuPages[indexPath.item].view)
        return cell
    }
    
    
    
    // MARK: UICollectionViewDelegateFlowLayout Methods
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return view.frame.size
    }
    
    
    
    // MARK: QuickBarDelegate Methods
    
    
    /**
     If there's a now playing song (playing or paused), go to NowPlayingViewController
     
     - Parameters:
     - sender: The quick bar that was tapped
     */
    func quickBarWasTapped(sender: NowPlayingQuickBar) {
        guard musicManager.itemNowPlaying != nil else { return }
        
        if let nowPlayingVC = storyboard!.instantiateViewController(withIdentifier: "NowPlayingViewController") as? NowPlayingViewController {
            nowPlayingVC.transitioningDelegate = self
            nowPlayingVC.interactor = slideDownInteractor
            present(nowPlayingVC, animated: true, completion: nil)
        }
        
        
    }
    
    
    
    // MARK: Helper Methods
    
    
    /**
     A simplification for scrolling the collection view to certain cells
     
     - Parameters:
     - index: The index of the cell to scroll to
     */
    func scrollToMenuIndex(index: Int) {
        let path = IndexPath(item: index, section: 0)
        collectionView?.scrollToItem(at: path, at: .centeredHorizontally, animated: true)
    }

}
