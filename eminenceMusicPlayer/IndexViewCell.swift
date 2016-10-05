//
//  IndexViewCell.swift
//  eminenceMusicPlayer
//
//  Created by Magfurul Abeer on 10/2/16.
//  Copyright © 2016 Magfurul Abeer. All rights reserved.
//

import UIKit

protocol IndexViewCell {
    var cell: UIView { get}
    var contentBackgroundColor: UIColor? { get set }
}

extension UITableViewCell: IndexViewCell {
    var cell: UIView {
        return self
    }
    
    var contentBackgroundColor: UIColor? {
        get {
            return self.contentView.backgroundColor
        }
        set {
            self.contentView.backgroundColor = newValue
        }
    }
}


extension UICollectionViewCell: IndexViewCell {
    var cell: UIView {
        return self
    }
    
    var contentBackgroundColor: UIColor? {
        get {
            return self.contentView.backgroundColor
        }
        set {
            self.contentView.backgroundColor = newValue
        }
    }
}

