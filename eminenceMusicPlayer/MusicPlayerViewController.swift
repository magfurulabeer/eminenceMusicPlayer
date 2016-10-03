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
        let point = scrollView.contentOffset
        let quarterWidth = view.frame.width/4
        let correctionalOffset = view.frame.width/16
        let percentComplete = (point.x - view.frame.size.width)/view.frame.size.width
        if percentComplete != 0 {
            menuBar.horizontalBarLeadingConstraint?.constant = (percentComplete * quarterWidth) + (quarterWidth * CGFloat(currentIndex)) + correctionalOffset
        }
        
    }
    
//    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
//        print(targetContentOffset.pointee.x)
//        print(menuBar.horizontalBarLeadingConstraint!.constant)
//        let target = targetContentOffset.pointee.x
//        let width = view.frame.width
//        if target == width {
//            menuBar.selectItemAtIndex(index: currentIndex)
////            print("=")
//        } else if target > width {
//            menuBar.selectItemAtIndex(index: currentIndex + 1)
////            currentIndex += 1
////            print("+")
//        } else if target < width {
//            menuBar.selectItemAtIndex(index: currentIndex - 1)
////            currentIndex -= 1
////            print("-")
//        }
////        print(velocity.x)
////        var index = velocity.x > 0 ? currentIndex + 1 : currentIndex - 1
//////        if velocity.x == 0  {    index = currentIndex    }
////        if fabs(velocity.x) < 0.33     {   index = currentIndex; print("less than")    }
////        print(currentIndex)
////        print(index)
////        print("\n")
////        menuBar.selectItemAtIndex(index: index)
//    }
    
}
