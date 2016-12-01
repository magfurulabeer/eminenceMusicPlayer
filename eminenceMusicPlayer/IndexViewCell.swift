//
//  IndexViewCell.swift
//  eminenceMusicPlayer
//
//  Created by Magfurul Abeer on 10/2/16.
//  Copyright © 2016 Magfurul Abeer. All rights reserved.
//

import UIKit

/// This protocol is the common denominator between TableViewCells and CollectionViewCells.
protocol IndexViewCell {
    
    /// The actual view itself.
    var cell: UIView { get}
    
    
    /// Background color of the content view
    var contentBackgroundColor: UIColor? { get set }
}

extension UITableViewCell: IndexViewCell {
    /// The actual view itself.
    var cell: UIView {
        return self
    }
    
    /// Background color of the content view
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
    /// The actual view itself.
    var cell: UIView {
        return self
    }
    
    /// Background color of the content view
    var contentBackgroundColor: UIColor? {
        get {
            return self.contentView.backgroundColor
        }
        set {
            self.contentView.backgroundColor = newValue
        }
    }
}

