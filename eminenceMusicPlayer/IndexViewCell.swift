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
//    var bgColor: UIColor? { get set }
    var contentBackgroundColor: UIColor? { get set }
//    var alphaValue: CGFloat { get set }
}

extension UITableViewCell: IndexViewCell {
    var cell: UIView {
        return self
    }

//    var bgColor: UIColor? {
//        get {
//            return self.backgroundColor
//        }
//        set {
//            self.backgroundColor = newValue
//        }
//    }
    
    var contentBackgroundColor: UIColor? {
        get {
            return self.contentView.backgroundColor
        }
        set {
            self.contentView.backgroundColor = newValue
        }
    }
    
//    var alphaValue: CGFloat {
//        get {
//            return self.alpha
//        }
//        set {
//            self.alpha = newValue
//        }
//    }
}


extension UICollectionViewCell: IndexViewCell {
    var cell: UIView {
        return self
    }

//    var bgColor: UIColor? {
//        get {
//            return self.backgroundColor
//        }
//        set {
//            self.backgroundColor = newValue
//        }
//    }
    
    var contentBackgroundColor: UIColor? {
        get {
            return self.contentView.backgroundColor
        }
        set {
            self.contentView.backgroundColor = newValue
        }
    }
    
//    var alphaValue: CGFloat {
//        get {
//            return self.alpha
//        }
//        set {
//            self.alpha = newValue
//        }
//    }
}

