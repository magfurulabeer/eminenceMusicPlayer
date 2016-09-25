//
//  NowPlayingViewController+Transitioning.swift
//  eminenceMusicPlayer
//
//  Created by Magfurul Abeer on 9/25/16.
//  Copyright © 2016 Magfurul Abeer. All rights reserved.
//

import UIKit

extension NowPlayingViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return SlideDownAnimator()
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactor!.hasStarted ? interactor! : nil
    }
}
