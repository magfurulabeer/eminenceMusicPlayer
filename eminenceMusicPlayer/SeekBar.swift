//
//  SeekBar.swift
//  eminenceMusicPlayer
//
//  Created by Magfurul Abeer on 9/9/16.
//  Copyright © 2016 Magfurul Abeer. All rights reserved.
//

import UIKit
import MediaPlayer


@IBDesignable
class SeekBar: UIControl {

    @IBInspectable
    var value: Double = 0 {
        didSet {
            let ratio = CGFloat( value / maximumValue )
            let width = ratio * frame.size.width
            bar.frame = CGRect(x: 0, y: 0, width: width, height: frame.height)
        }
    }
    
    @IBInspectable
    var minimumValue: Double = 0
    
    @IBInspectable
    var maximumValue: Double = 0
    
    @IBInspectable
    var barColor: UIColor = UIColor.clear
    
    var bar = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isUserInteractionEnabled = true
        
        bar.backgroundColor = barColor
        bar.frame = frame//CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        addSubview(bar)
        
        bar.translatesAutoresizingMaskIntoConstraints = false
        bar.topAnchor.constraint(equalTo: topAnchor).isActive = true
        bar.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        bar.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        bar.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
        /*
        // Posted when the playback state changes, either programatically or by the user.
        public static let MPMusicPlayerControllerPlaybackStateDidChange: NSNotification.Name
        
        
        // Posted when the currently playing media item changes.
        public static let MPMusicPlayerControllerNowPlayingItemDidChange: NSNotification.Name
        
        
        // Posted when the current volume changes.
        public static let MPMusicPlayerControllerVolumeDidChange: NSNotification.Name
 */
        
        //NotificationCenter.default.addObserver(self, selector: #selector(SeekBar.hi), name: , object: nil)
        
        addTapGestureRecognizer()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func hi() {
        
    }
    
    private func addTapGestureRecognizer() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleBarTapped(sender:)))
        addGestureRecognizer(tapGestureRecognizer)
    }
    
    func handleBarTapped(sender: UITapGestureRecognizer) {
        sendActions(for: UIControlEvents.touchUpInside)
    }
 
    
    
    
}
