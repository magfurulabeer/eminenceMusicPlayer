//
//  SongTappedAnimator.swift
//  eminenceMusicPlayer
//
//  Created by Magfurul Abeer on 9/25/16.
//  Copyright © 2016 Magfurul Abeer. All rights reserved.
//

import UIKit

class SongTappedAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    let duration = 0.4
    var tableCellFrame = CGRect.zero
    var cell = SongCell()
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let containerView = transitionContext.containerView
        let toView = transitionContext.view(forKey: UITransitionContextViewKey.to)!
        
        let imageView = UIImageView(image: cell.albumImage)
        if imageView.image == nil {
            imageView.image = #imageLiteral(resourceName: "NoAlbumImage")
        }
        // 0.9 should be constant
        let albumHeightWidth = tableCellFrame.height * 0.9
        let albumCenterOffset = (tableCellFrame.height - albumHeightWidth)/2
        imageView.frame = CGRect(x: tableCellFrame.origin.x, y: tableCellFrame.origin.y + albumCenterOffset, width: albumHeightWidth, height: albumHeightWidth)
        
        containerView.addSubview(toView)
        toView.alpha = 0
        containerView.addSubview(imageView)
        
        let newWidthHeight = containerView.frame.width * 0.85
        let centerX = containerView.frame.width/2
        let centerY = FauxBarHeight + 34 + newWidthHeight/2
        let scale = newWidthHeight/albumHeightWidth
        
        
        UIView.animate(withDuration: duration/3, delay: duration/3 * 2, options: .curveEaseOut, animations: {
            toView.alpha = 1
            }, completion: nil)
        UIView.animate(withDuration: duration, delay: 0.0,
                       usingSpringWithDamping: 0.8, initialSpringVelocity: 0.0,
                       options: [], animations: {
                imageView.transform = CGAffineTransform.init(scaleX: scale, y: scale)
                imageView.center = CGPoint(x: centerX, y: centerY)

            }, completion: {_ in
                imageView.removeFromSuperview()
                transitionContext.completeTransition(
                    !transitionContext.transitionWasCancelled
                )
        })
        
        
    }
}
