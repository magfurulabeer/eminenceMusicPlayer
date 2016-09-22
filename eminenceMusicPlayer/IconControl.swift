//
//  IconControl.swift
//  eminenceMusicPlayer
//
//  Created by Magfurul Abeer on 9/9/16.
//  Copyright © 2016 Magfurul Abeer. All rights reserved.
//

import UIKit

class IconControl: UIView {
    
    lazy var imageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 30.0, weight: UIFontWeightLight)
        return label
    }()
    
}

extension IconControl {
    private func sharedInitialization() {
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        addSubview(imageView)
        
//        NSLayoutConstraint.activateConstraints([
//            imageView.leadingAnchor.constraintEqualToAnchor(layoutMarginsGuide.leadingAnchor),
//            imageView.
//            ])
    }
}

