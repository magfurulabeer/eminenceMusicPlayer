//
//  SongsCollectionCell+Dragging.swift
//  eminenceMusicPlayer
//
//  Created by Magfurul Abeer on 9/30/16.
//  Copyright © 2016 Magfurul Abeer. All rights reserved.
//

import UIKit

extension SongsCollectionCell {
    func snapshopOfCell(inputView: UIView) -> UIView {
        UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, false, 0.0)
        inputView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()! as UIImage
        UIGraphicsEndImageContext()
        let cellSnapshot : UIView = UIImageView(image: image)
        cellSnapshot.layer.masksToBounds = false
        cellSnapshot.layer.cornerRadius = 0.0
        cellSnapshot.layer.shadowOffset = CGSize(width: -5, height: 0)
        cellSnapshot.layer.shadowRadius = 5.0
        cellSnapshot.layer.shadowOpacity = 0.4
        return cellSnapshot
    }
    
    func handleLongPressDragging(sender: UILongPressGestureRecognizer, indexPath: IndexPath?) {
        if sender.state == UIGestureRecognizerState.began {
            initialIndexPath = indexPath!
            let cell = tableView.cellForRow(at: indexPath!) as UITableViewCell!
            cellSnapshot  = snapshopOfCell(inputView: cell!)
            var center = cell!.center
            cellSnapshot.center = center
            cellSnapshot.alpha = 0.0
            viewController?.view.addSubview(cellSnapshot)
            
            UIView.animate(withDuration: 0.25, animations: { () -> Void in
                center.y = sender.location(in: self.viewController?.view).y
                self.cellSnapshot.center = center
                self.cellSnapshot.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
                self.cellSnapshot.alpha = 0.98
                cell!.alpha = 0.0
                
                }, completion: { (finished) -> Void in
                    if finished {
                        cell!.isHidden = true
                    }
            })
        }
        if sender.state == UIGestureRecognizerState.changed {
            cellSnapshot.center.y = sender.location(in: viewController?.view).y
            
            if cellSnapshot.center.y < FauxBarHeight + SongCellHeight/4 {
                if cellSnapshot.tag == 0 {
                    cellSnapshot.tag = 5
                    (viewController as! MusicPlayerViewController).menuBar.highlightCell(index: 0)
                    UIView.animate(withDuration: 0.3, animations: {
                        self.cellSnapshot.transform = CGAffineTransform.init(scaleX: 0.5, y: 0.5).concatenating(CGAffineTransform.init(translationX: -self.frame.width/6, y: 0))
                    })
                }
            } else {
                if cellSnapshot.tag != 0 {
                    (viewController as! MusicPlayerViewController).menuBar.unhighlightCell(index: 0)
                    cellSnapshot.tag = 0
                    UIView.animate(withDuration: 0.3, animations: {
                        self.cellSnapshot.transform = CGAffineTransform.identity
                    })
                }
            }
        }
        if sender.state == UIGestureRecognizerState.ended {
            cellSnapshot.removeFromSuperview()
            (viewController as! MusicPlayerViewController).menuBar.unhighlightCell(index: 0)
            let cell = tableView.cellForRow(at: initialIndexPath)!
            cell.isHidden = false
            cell.alpha = 1.0
            let song = musicManager.songList[initialIndexPath.row]
            musicManager.quickQueue.append(song)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "AddedToQueue"), object: nil)
        }
        
        if sender.state == UIGestureRecognizerState.cancelled {
            cellSnapshot.removeFromSuperview()
            (viewController as! MusicPlayerViewController).menuBar.unhighlightCell(index: 0)
            let cell = tableView.cellForRow(at: initialIndexPath)!
            cell.isHidden = false
            cell.alpha = 1.0
        }
    }
}
