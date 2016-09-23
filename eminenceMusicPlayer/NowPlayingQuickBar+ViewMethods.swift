//
//  NowPlayingQuickBar+ViewMethods.swift
//  eminenceMusicPlayer
//
//  Created by Magfurul Abeer on 9/22/16.
//  Copyright © 2016 Magfurul Abeer. All rights reserved.
//

import UIKit

extension NowPlayingQuickBar {
    func fadeOut() {
        fadeTimer.invalidate()
        let duration = fadeAnimator.fractionComplete
        fadeAnimator = UIViewPropertyAnimator(duration: TimeInterval(duration), curve: .easeOut) {
            self.blackOverlay.alpha = 0.3
        }
        fadeTimer = Timer.scheduledTimer(withTimeInterval: timerInterval, repeats: true, block: { (timer) in
            OperationQueue.main.addOperation {
                self.fadeAnimator.fractionComplete += 0.05 //CGFloat(timerInterval)
                if self.fadeAnimator.fractionComplete == 1.0 {
                    self.fadeTimer.invalidate()
                }
            }
        })
    }
    
    func fadeIn() {
        fadeTimer.invalidate()
        let duration = fadeAnimator.fractionComplete
        fadeAnimator = UIViewPropertyAnimator(duration: TimeInterval(duration), curve: .easeOut) {
            self.blackOverlay.alpha = 0.0
        }
        fadeTimer = Timer.scheduledTimer(withTimeInterval: timerInterval, repeats: true, block: { (timer) in
            OperationQueue.main.addOperation {
                self.fadeAnimator.fractionComplete += 0.05//CGFloat(timerInterval)
                if self.fadeAnimator.fractionComplete == 1.0 {
                    self.fadeTimer.invalidate()
                }
            }
        })
    }
}
