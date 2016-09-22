//
//  SideKicK.swift
//  SideKicK Helper Methods
//
//  Created by Magfurul Abeer on 9/4/16.
//  Copyright © 2016 Magfurul Abeer. All rights reserved.
//
// SideKicK is a collection of helper methods to speed up the development process


import UIKit



extension TimeInterval {
    func stringFormat() -> String {
        let interval = self
        let seconds = Int( interval.truncatingRemainder(dividingBy: 60).rounded() )
        let minutes = Int( interval / 60 ) % 60
        let hours = minutes/60
        if hours > 0 {
            return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        }
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

/*
slider.addTarget(self, action: #selector(self.sliderWasTouched(sender:withEvent:)), for: UIControlEvents.touchDown)
func sliderWasTouched(sender: UISlider, withEvent event: UIEvent) {
    print("\n\n\nWAS TOUCHED\n\n\n")
    //UITouch *touch = [[event allTouches] anyObject];
    guard let touch = event.allTouches?.first else {
        return
    }
    let touchPoint = touch.preciseLocation(in: sender)
    slider.value = Float(touchPoint.x / sender.bounds.width)
}

*/






