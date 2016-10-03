//
//  ViewControllerCollectionCell.swift
//  eminenceMusicPlayer
//
//  Created by Magfurul Abeer on 10/3/16.
//  Copyright © 2016 Magfurul Abeer. All rights reserved.
//

import UIKit

class ViewControllerCollectionCell: UICollectionViewCell {
    
    var currentView: UIView?
    
    func addView(view: UIView) {
        if currentView != nil {
            currentView?.removeFromSuperview()
        }
        contentView.addSubview(view)
        currentView = view
    }
    
    
}
