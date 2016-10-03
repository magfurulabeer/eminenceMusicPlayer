//
//  MusicPlayerViewController.swift
//  eminenceMusicPlayer
//
//  Created by Magfurul Abeer on 10/3/16.
//  Copyright © 2016 Magfurul Abeer. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class MusicPlayerViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    var menuPages = [UIViewController]()
    var menuBar: MenuBar = MenuBar()
    var quickBar: NowPlayingQuickBar?
    let slideDownInteractor = SlideDownInteractor()
    var musicManager = MusicManager.sharedManager
    var currentIndex = 1
    var isAutoScrolling = false
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        menuPages.append(PlaylistsViewController())
        menuPages.append(SongsViewController())
        menuPages.append(ArtistsViewController())
        menuPages.append(AlbumsViewController())
        
        setUpCollectionView()
        setUpGradient()
        setUpMenuBar()
        setUpQuickBar()
    }
    
    func scrollToMenuIndex(index: Int) {
        let path = IndexPath(item: index, section: 0)
        collectionView?.scrollToItem(at: path, at: .centeredHorizontally, animated: true)
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        menuBar.horizontalBarLeadingConstraint?.constant = scrollView.contentOffset.x/4 + view.frame.width/16
    }
    
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let currentPageIndex = targetContentOffset.pointee.x / view.frame.width
        menuBar.selectItemAtIndex(index: Int(currentPageIndex))
    }
    
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return view.frame.size
    }
    
    
    
    func quickBarWasTapped(sender: NowPlayingQuickBar) {
        if musicManager.itemNowPlaying == nil {
            return
        }
        if let nowPlayingVC = storyboard!.instantiateViewController(withIdentifier: "NowPlayingViewController") as? NowPlayingViewController {
            nowPlayingVC.transitioningDelegate = self
            nowPlayingVC.interactor = slideDownInteractor
            present(nowPlayingVC, animated: true, completion: nil)
        }
        
        
    }

}
