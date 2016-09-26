//
//  SlideDownAnimator.swift
//  eminenceMusicPlayer
//
//  Created by Magfurul Abeer on 9/25/16.
//  Copyright © 2016 Magfurul Abeer. All rights reserved.
//

import UIKit

class SlideDownAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    let duration = 0.5
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from),
              let toVC = transitionContext.viewController(forKey: .to) else {
                return
        }
        
        let containerView = transitionContext.containerView
        containerView.insertSubview(toVC.view, belowSubview: fromVC.view)
        
        let screenBounds = UIScreen.main.bounds
        let bottomCorner = CGPoint(x: 0, y: screenBounds.height)// - tabBarHeight - quickBarHeight)
        let finalFrame = CGRect(origin: bottomCorner, size: screenBounds.size)
        toVC.view.alpha = 0.2
        UIView.animate(withDuration: duration, animations: {
            toVC.view.alpha = 1
            fromVC.view.frame = finalFrame
        }) { (_) in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
        
    }
}
