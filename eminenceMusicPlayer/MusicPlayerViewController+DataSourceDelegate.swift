//
//  MusicPlayerViewController+DataSourceDelegate.swift
//  eminenceMusicPlayer
//
//  Created by Magfurul Abeer on 10/3/16.
//  Copyright © 2016 Magfurul Abeer. All rights reserved.
//

import UIKit

extension MusicPlayerViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {

        let currentPage = viewController as! MenuViewController
        
        if currentPage.index > 0 {
            return menuPages[currentPage.index - 1]
        }
        
        return nil
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        let currentPage = viewController as! MenuViewController
        
        if currentPage.index < menuPages.count - 1 {
            return menuPages[currentPage.index + 1]
        }
        
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let currentPage = self.viewControllers?.first as! MenuViewController
        currentIndex = currentPage.index
        menuBar.selectItemAtIndex(index: currentPage.index)
    }
    
    

}
