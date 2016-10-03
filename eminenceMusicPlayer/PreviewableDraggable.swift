//
//  PreviewableDraggable.swift
//  eminenceMusicPlayer
//
//  Created by Magfurul Abeer on 10/2/16.
//  Copyright © 2016 Magfurul Abeer. All rights reserved.
//

import UIKit

protocol PreviewableDraggable: Previewable {
    func handleLongPress(sender: UILongPressGestureRecognizer)
    func handleLongPressDragging(sender: UILongPressGestureRecognizer, indexPath: IndexPath?)
    func snapshopOfCell(inputView: UIView) -> UIView
    weak var viewController: UIViewController? { get set }
    var cellSnapshot: UIView { get set }
    var initialIndexPath: IndexPath? { get set }

}

extension PreviewableDraggable {
    func handleLongPress(sender: UILongPressGestureRecognizer) {
        let point = sender.location(in: indexView.view)
        let indexPath = indexView.indexPathForCell(at: point)
        
        if sender.state == UIGestureRecognizerState.began && point.x <= SongCellHeight * 0.9  {
            handleLongPressDragging(sender: sender, indexPath: indexPath)
        } else if sender.state != UIGestureRecognizerState.began && musicManager.currentlySampling == false {
            handleLongPressDragging(sender: sender, indexPath: indexPath)
        } else {
            handleLongPressSampling(sender: sender, indexPath: indexPath!)
        }
    }
    
    func handleLongPressDragging(sender: UILongPressGestureRecognizer, indexPath: IndexPath?) {
        if sender.state == UIGestureRecognizerState.began {
            initialIndexPath = indexPath!
            let cell = indexView.cell(atIndexPath: indexPath!) as! UITableViewCell
            cellSnapshot  = snapshopOfCell(inputView: cell)
            var center = cell.center
            cellSnapshot.center = center
            cellSnapshot.alpha = 0.0
            viewController?.view.addSubview(cellSnapshot)
            
            UIView.animate(withDuration: 0.25, animations: { () -> Void in
                center.y = sender.location(in: self.viewController?.view).y
                self.cellSnapshot.center = center
                self.cellSnapshot.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
                self.cellSnapshot.alpha = 0.98
                cell.alpha = 0.0
                
                }, completion: { (finished) -> Void in
                    if finished {
                        cell.isHidden = true
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
                        self.cellSnapshot.transform = CGAffineTransform.init(scaleX: 0.5, y: 0.5).concatenating(CGAffineTransform.init(translationX: -self.viewController!.view.frame.width/6, y: 0))
                    })
                }
            } else {
                if cellSnapshot.tag != 0 {
                    (viewController as! MusicPlayerViewController).menuBar.unhighlightCell(index: 0, wasSuccessful: false)
                    cellSnapshot.tag = 0
                    UIView.animate(withDuration: 0.3, animations: {
                        self.cellSnapshot.transform = CGAffineTransform.identity
                    })
                }
            }
        }
        if sender.state == UIGestureRecognizerState.ended {
            let wasSuccessful = cellSnapshot.center.y < FauxBarHeight + SongCellHeight/4
            cellSnapshot.removeFromSuperview()
            (viewController as! MusicPlayerViewController).menuBar.unhighlightCell(index: 0, wasSuccessful: wasSuccessful)
            let cell = indexView.cell(atIndexPath: initialIndexPath!) as! UITableViewCell

            cell.isHidden = false
            cell.alpha = 1.0
            if wasSuccessful {
                let song = musicManager.songList[initialIndexPath!.row]
                musicManager.quickQueue.append(song)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "AddedToQueue"), object: nil)
            }
        }
        
        if sender.state == UIGestureRecognizerState.cancelled {
            cellSnapshot.removeFromSuperview()
            (viewController as! MusicPlayerViewController).menuBar.unhighlightCell(index: 0, wasSuccessful: false)
            let cell = indexView.cell(atIndexPath: indexPath!)
            cell?.cell.isHidden = false
            cell?.cell.alpha = 1.0
        }
    }
    
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

}
