//
//  SelectedSongCell.swift
//  eminenceMusicPlayer
//
//  Created by Magfurul Abeer on 9/27/16.
//  Copyright © 2016 Magfurul Abeer. All rights reserved.
//

import UIKit

class SelectedSongCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var artistAlbumLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var albumImageView: UIImageView!
    
    var hasGradient = false
    
    var albumImage: UIImage? = #imageLiteral(resourceName: "NoAlbumImage") {
        didSet {
            if self.albumImage != nil {
                self.albumImageView.image = self.albumImage
            } else {
                self.albumImageView.image = #imageLiteral(resourceName: "NoAlbumImage")
            }
        }
    }
    
    var artist: String = "" {
        didSet {
            self.artistAlbumLabel.text = "\(self.artist) - \(self.album)"
        }
    }
    var album: String = "" {
        didSet {
            self.artistAlbumLabel.text = "\(self.artist) - \(self.album)"
        }
    }
    
    let gradientLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        // Configure the gradient here
        gradientLayer.backgroundColor = UIColor.white.cgColor
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        
        gradientLayer.locations = [0.25, 0.5, 0.75]
        gradientLayer.colors = [
            UIColor.white,
            UIColor.black,
            UIColor.white
            
            ].map { color in color.cgColor }
        
        return gradientLayer
    }()
    
    func imageWithText(text: String) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(titleLabel.frame.size, false, 0)
        text.draw(in: titleLabel.bounds, withAttributes: textAttributes)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    let textAttributes: [String: AnyObject] = {
        let style = NSMutableParagraphStyle()
        style.alignment = .left
        return [
            NSFontAttributeName:UIFont(name: "Avenir", size: 18)!,
            NSParagraphStyleAttributeName: style
        ]
    }()
    
    func addGradient() {
        gradientLayer.frame = bounds
        titleLabel.layer.addSublayer(gradientLayer)
        
        gradientLayer.frame = CGRect(
            x: -bounds.size.width,
            y: bounds.origin.y,
            width: 3 * bounds.size.width,
            height: bounds.size.height
        )
        
        let gradientAnimation = CABasicAnimation(keyPath: "locations")
        gradientAnimation.fromValue = [0.0, 0.0, 0.25]
        gradientAnimation.toValue = [0.75, 1.0, 1.0]
        gradientAnimation.duration = 3.0
        gradientAnimation.repeatCount = Float.infinity
        gradientLayer.add(gradientAnimation, forKey: nil)
        
        titleLabel.mask = UIImageView(image: imageWithText(text: titleLabel.text!))
        hasGradient = true
    }
    
    func removeGradientIfApplicable() {
        if hasGradient {
            gradientLayer.isHidden = true
            //            gradientLayer.removeFromSuperlayer()
            hasGradient = false
        }
    }
    
}
