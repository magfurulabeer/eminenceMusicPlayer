//
//  OpenTabBarController.swift
//  eminenceMusicPlayer
//
//  Created by Magfurul Abeer on 9/22/16.
//  Copyright © 2016 Magfurul Abeer. All rights reserved.
//

import UIKit

class OpenTabBarController: UITabBarController {

    var quickBar: NowPlayingQuickBar?
    var blackOverlay = UIView()
    var fadeTimer = Timer()
    var fadeAnimator = UIViewPropertyAnimator()
    let deselectedColor = UIColor(red: 92/255.0, green: 46/255.0, blue: 46/255.0, alpha: 1)
    let selectedColor = UIColor.white.withAlphaComponent(0.8)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.backgroundImage = UIImage()
        self.tabBar.backgroundColor = QuickBarBackgroundColor
        self.tabBar.shadowImage = UIImage()
        self.tabBar.layer.zPosition = 0
        self.tabBar.tintColor = UIColor.blue
        UITabBar.appearance().barTintColor = QuickBarBackgroundColor
        UITabBar.appearance().tintColor = UIColor.white
        
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(OpenTabBarController.fadeOut), name: NSNotification.Name(rawValue: "SamplingDidBegin"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(OpenTabBarController.fadeIn), name: NSNotification.Name(rawValue: "SamplingDidEnd"), object: nil)
        
        setUpBlackOverlay()
    }
    
    func setUpBlackOverlay() {
        self.blackOverlay.backgroundColor = UIColor.black
        self.blackOverlay.alpha = 0

        view.addSubview(blackOverlay)
        
        self.blackOverlay.translatesAutoresizingMaskIntoConstraints = false
        self.blackOverlay.leadingAnchor.constraint(equalTo: self.tabBar.leadingAnchor).isActive = true
        self.blackOverlay.trailingAnchor.constraint(equalTo: self.tabBar.trailingAnchor).isActive = true
        self.blackOverlay.bottomAnchor.constraint(equalTo: self.tabBar.bottomAnchor).isActive = true
        self.blackOverlay.heightAnchor.constraint(equalToConstant: quickBarHeight + 49).isActive = true
    }

    
    func fadeOut() {
        fadeTimer.invalidate()
        let duration = fadeAnimator.fractionComplete
        fadeAnimator = UIViewPropertyAnimator(duration: TimeInterval(duration), curve: .easeOut) {
            self.blackOverlay.alpha = 0.5
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
                if self.fadeAnimator.fractionComplete >= 0.99 {
                    
                    self.fadeTimer.invalidate()
                }
            }
        })
    }
}
