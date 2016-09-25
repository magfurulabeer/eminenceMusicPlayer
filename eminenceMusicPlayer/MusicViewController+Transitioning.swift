//
//  MusicViewController+Transitioning.swift
//  eminenceMusicPlayer
//
//  Created by Magfurul Abeer on 9/25/16.
//  Copyright © 2016 Magfurul Abeer. All rights reserved.
//

import UIKit

extension MusicViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let animator = SongTappedAnimator()

        var cellRect = tableView.rectForRow(at: tableView.indexPathForSelectedRow!)
        cellRect = cellRect.offsetBy(dx: -tableView.contentOffset.x, dy: -tableView.contentOffset.y)
        animator.tableCellFrame = cellRect
        let cell = tableView.cellForRow(at: tableView.indexPathForSelectedRow!)
        animator.cell = cell as! SongCell
        return animator
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return nil
    }
}
