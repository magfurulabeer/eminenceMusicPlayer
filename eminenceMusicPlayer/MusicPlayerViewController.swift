//
//  MusicPlayerViewController.swift
//  eminenceMusicPlayer
//
//  Created by Magfurul Abeer on 10/3/16.
//  Copyright © 2016 Magfurul Abeer. All rights reserved.
//

import UIKit

class MusicPlayerViewController: UIPageViewController, UIScrollViewDelegate {

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

        
        delegate = self
        dataSource = self
        
        
        setUpGradient()
        setUpMenuBar()
        setUpQuickBar()
        setViewControllers([menuPages[1]], direction: .forward, animated: false, completion: nil)
        
        for subview in view.subviews {
            guard let page = subview as? UIScrollView else { continue }
            page.delegate = self
        }
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(isAutoScrolling)
        if isAutoScrolling == false {
            let point = scrollView.contentOffset
            let quarterWidth = view.frame.width/4
            let correctionalOffset = view.frame.width/16
            let percentComplete = (point.x - view.frame.size.width)/view.frame.size.width
            if percentComplete != 0 {
                print("should not print")
                menuBar.horizontalBarLeadingConstraint?.constant = (percentComplete * quarterWidth) + (quarterWidth * CGFloat(currentIndex)) + correctionalOffset
            }
        }
    }
    
    func changePage(direction: UIPageViewControllerNavigationDirection) {
        if direction == .forward {
            currentIndex += 1
        } else {
            currentIndex -= 1
        }
        
        let vc = menuPages[currentIndex]
        
        setViewControllers([vc], direction: direction, animated: true, completion: nil)
    }
}
