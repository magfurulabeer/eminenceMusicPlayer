//
//  PreviewableDraggable.swift
//  eminenceMusicPlayer
//
//  Created by Magfurul Abeer on 10/2/16.
//  Copyright © 2016 Magfurul Abeer. All rights reserved.
//

import UIKit

protocol PreviewableDraggable: Previewable {
    weak var viewController: UIViewController? { get set }
    var cellSnapshot: UIView { get set }
    var initialIndexPath: IndexPath? { get set }
    var currentlyDragging: Bool { get set }
    func snapshopOfCell(inputView: UIView) -> UIView
    func handleLongPress(sender: UILongPressGestureRecognizer)
    func handleLongPressDragging(sender: UILongPressGestureRecognizer, indexPath: IndexPath?)
    func startDragging(sender: UILongPressGestureRecognizer, indexPath: IndexPath)
    func changeDragging(sender: UILongPressGestureRecognizer)
    func endDragging()
    func cancelDragging()
    func draggingOffset() -> CGFloat
}

extension PreviewableDraggable {
    func handleLongPress(sender: UILongPressGestureRecognizer) {
        let point = sender.location(in: indexView.view)
        let indexPath = indexView.indexPathForCell(at: point)
        
        print("1")
        if indexPath == nil && !currentlyDragging {
            if musicManager.currentlyPreviewing {
                musicManager.player.pause()
                endPreviewingMusic()
                return
            }
            return
        }
        print("2")

        if indexPathIsExcluded(indexPath: indexPath) {
            if musicManager.currentlyPreviewing {
                musicManager.player.pause()
                endPreviewingMusic()
                return
            }
            if !currentlyDragging {
                return
            }
        }
        
        print("3")

        if sender.state == UIGestureRecognizerState.began && point.x <= draggingOffset()  {
            handleLongPressDragging(sender: sender, indexPath: indexPath)
        } else if sender.state != UIGestureRecognizerState.began && musicManager.currentlyPreviewing == false {
            handleLongPressDragging(sender: sender, indexPath: indexPath)
        } else {
            handleLongPressPreviewing(sender: sender, indexPath: indexPath!)
        }
    }
    
    func handleLongPressDragging(sender: UILongPressGestureRecognizer, indexPath: IndexPath?) {
        if sender.state == UIGestureRecognizerState.began {
            startDragging(sender: sender, indexPath: indexPath!)
        }
        if sender.state == UIGestureRecognizerState.changed {
            changeDragging(sender: sender)
        }
        if sender.state == UIGestureRecognizerState.ended {
            endDragging()
        }
        
        if sender.state == UIGestureRecognizerState.cancelled {
            cancelDragging()
        }
    }
    
    func startDragging(sender: UILongPressGestureRecognizer, indexPath: IndexPath) {
        initialIndexPath = indexPath
        let cell = indexView.cell(atIndexPath: indexPath) as! UITableViewCell
        cellSnapshot  = snapshopOfCell(inputView: cell)
        var center = cell.center
        cellSnapshot.center = center
        cellSnapshot.alpha = 0.0
        viewController?.view.addSubview(cellSnapshot)
        currentlyDragging = true
        
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
    
    func changeDragging(sender: UILongPressGestureRecognizer) {
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
    
    func endDragging() {
        let wasSuccessful = cellSnapshot.center.y < FauxBarHeight + SongCellHeight/4
        cellSnapshot.removeFromSuperview()
        (viewController as! MusicPlayerViewController).menuBar.unhighlightCell(index: 0, wasSuccessful: wasSuccessful)
        let cell = indexView.cell(atIndexPath: initialIndexPath!) as! UITableViewCell
        
        cell.isHidden = false
        cell.alpha = 1.0
        currentlyDragging = false

        if wasSuccessful {
            let song = selectedSongForPreview(indexPath: initialIndexPath!)
            musicManager.quickQueue.append(song)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "AddedToQueue"), object: nil)
        }
    }
    
    func cancelDragging() {
        cellSnapshot.removeFromSuperview()
        (viewController as! MusicPlayerViewController).menuBar.unhighlightCell(index: 0, wasSuccessful: false)
        let cell = indexView.cell(atIndexPath: initialIndexPath!)
        cell?.cell.isHidden = false
        cell?.cell.alpha = 1.0
        currentlyDragging = false
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
