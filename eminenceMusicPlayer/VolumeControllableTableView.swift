//
//  VolumeControllableTableView.swift
//  eminenceMusicPlayer
//
//  Created by Magfurul Abeer on 12/8/16.
//  Copyright © 2016 Magfurul Abeer. All rights reserved.
//

import UIKit

/// This class is a last resort to replace two finger scroll with volume controls. The original plan was to keep all the in IndexView. Unfortunately, due to various issues with Protocols and extensions, it was not doable. Future attemps to DRY this code will be made.
class VolumeControllableTableView: UITableView, VolumeControllable {

    
    
    // MARK: VolumeControllable Properties
    
    
    
    /// Reference to view
    var controllableView: UIView { get { return view } }
    
    /// The last location of the drag
    var lastLocation: CGPoint = CGPoint(x: 0, y: 0)
    
    // TODO: Move this to init method
    /// This is necessary because the tableview/collectionview two finger gesture has higher priority than the view controller views above it
    func disableTwoFingerScroll() {
        guard let gestureRecognizers = gestureRecognizers else { return }
        for gesture in gestureRecognizers {
            if gesture.isKind(of: UIPanGestureRecognizer.self) {
                let panGesture = gesture as! UIPanGestureRecognizer
                panGesture.maximumNumberOfTouches = 1
            }
        }
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(twoFingerScrolled(sender:)))
            pan.maximumNumberOfTouches = 2
            pan.minimumNumberOfTouches = 2
            addGestureRecognizer(pan)
    }
    
    func twoFingerScrolled(sender: UIPanGestureRecognizer) {
        didTwoFingerDrag(sender: sender)
    }
    
    
    
}
