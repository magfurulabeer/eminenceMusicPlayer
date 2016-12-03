//
//  Seekbar.swift
//  eminenceMusicPlayer
//
//  Created by Magfurul Abeer on 10/20/16.
//  Copyright © 2016 Magfurul Abeer. All rights reserved.
//

import UIKit

/// This protocol allows the seekbar to update its delegate when changed.
protocol SeekbarDelegate {
    func seekbarWillChangeValue()
    func seekbarDidChangeValue()
}

/// A subclass of UISlider that also observes where it is tapped.
class Seekbar: UISlider {
    
    var delegate: SeekbarDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addTapGesture()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addTapGesture()
    }
    
    
    /**
     Sets up and adds a tap gesture to the seekbar.
     */
    func addTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.didTapSlider(sender:)))
        addGestureRecognizer(tapGesture)
    }
    
    
    /**
     Override making the track 7 units high.
     
     - Parameters:
     - bounds: CGRect representing bounds of view
     */
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        var newBounds = super.trackRect(forBounds: bounds)
        newBounds.size.height = 7
        return newBounds
    }
    

    /**
     When tapped, the seekbar should change values according to where it was tapped.
     
     - Parameters:
     - sender: Activated tap gesture recognizer
     */
    func didTapSlider(sender: UITapGestureRecognizer) {
        delegate?.seekbarWillChangeValue()
        let location = sender.location(in: self)
        let percent = location.x / frame.width
        value = Float(percent)
        didChangeValue(forKey: "value")
        delegate?.seekbarDidChangeValue()
    }
}
