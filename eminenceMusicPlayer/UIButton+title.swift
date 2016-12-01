//
//  UIButton+title.swift
//  eminenceMusicPlayer
//
//  Created by Magfurul Abeer on 11/30/16.
//  Copyright © 2016 Magfurul Abeer. All rights reserved.
//

import UIKit

/// This extension adds a title property to easily get the title and change the title.
extension UIButton {
    
    /// The title of the titleLabel. Setting it changes it visually and in memory.
    var title: String {
        get {
            return self.titleLabel?.text ?? ""
        }
        set {
            self.titleLabel?.text = newValue
            self.setTitle(newValue, for: .normal)
            self.setTitle(newValue, for: .highlighted)
        }
    }
}
