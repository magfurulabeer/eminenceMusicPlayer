//
//  Seekbar.swift
//  eminenceMusicPlayer
//
//  Created by Magfurul Abeer on 10/20/16.
//  Copyright © 2016 Magfurul Abeer. All rights reserved.
//

import UIKit

protocol SeekbarDelegate {
    func seekbarDidChangeValue()
}

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
    
    func addTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.didTapSlider(sender:)))
        addGestureRecognizer(tapGesture)
    }
    
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        var newBounds = super.trackRect(forBounds: bounds)
        newBounds.size.height = 7
        return newBounds
    }

    func didTapSlider(sender: UITapGestureRecognizer) {
        let location = sender.location(in: self)
        let percent = location.x / frame.width
        value = Float(percent)
        didChangeValue(forKey: "value")
        delegate?.seekbarDidChangeValue()
    }
}
