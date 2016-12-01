//
//  TimeInterval+StringFormat.swift
//  eminenceMusicPlayer
//
//  Created by Magfurul Abeer on 11/30/16.
//  Copyright © 2016 Magfurul Abeer. All rights reserved.
//

import Foundation

/// This extension adds a convenience method for getting string values in HH:mm:SS format.
extension TimeInterval {
    
    /// Returns the date as a String in HH:mm:SS format.
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
