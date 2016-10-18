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
    var deleteLabel: UILabel? { get set }
    func snapshopOfCell(inputView: UIView) -> UIView
    func handleLongPress(sender: UILongPressGestureRecognizer)
    func handleLongPressDragging(sender: UILongPressGestureRecognizer, indexPath: IndexPath?)
    func startDragging(sender: UILongPressGestureRecognizer, indexPath: IndexPath)
    func changeDragging(sender: UILongPressGestureRecognizer)
    func endDragging()
    func cancelDragging()
    func draggingOffset() -> CGFloat
    func canDelete() -> Bool
    func didDeleteItemAtPath(indexPath: IndexPath)
}

extension PreviewableDraggable {
    func canDelete() -> Bool {
        return false
    }
    
    func didDeleteItemAtPath(indexPath: IndexPath) {
        
    }
    
    final func handleLongPress(sender: UILongPressGestureRecognizer) {
        let point = sender.location(in: indexView.view)
        let indexPath = indexView.indexPathForCell(at: point)
        
        if indexPath == nil && !currentlyDragging {
            if musicManager.currentlyPreviewing {
                musicManager.player.pause()
                endPreviewingMusic()
                return
            }
            return
        }

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
        
        if sender.state == UIGestureRecognizerState.began && point.x <= draggingOffset()  {
            handleLongPressDragging(sender: sender, indexPath: indexPath)
        } else if sender.state != UIGestureRecognizerState.began && musicManager.currentlyPreviewing == false {
            handleLongPressDragging(sender: sender, indexPath: indexPath)
        } else {
            handleLongPressPreviewing(sender: sender, indexPath: indexPath!)
        }
    }
    
    final func handleLongPressDragging(sender: UILongPressGestureRecognizer, indexPath: IndexPath?) {
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
    
    final func startDragging(sender: UILongPressGestureRecognizer, indexPath: IndexPath) {
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
            if self.canDelete() {
                guard let deleteLabel = self.deleteLabel else { return }
                deleteLabel.isHidden = false
            }
            }, completion: { (finished) -> Void in
                if finished {
                    cell.isHidden = true
                }
        })

    }
    
    final func changeDragging(sender: UILongPressGestureRecognizer) {
        cellSnapshot.center.y = sender.location(in: viewController?.view).y
        
        if cellSnapshot.center.y < FauxBarHeight + SongCellHeight/4 {
            if cellSnapshot.tag == 0 {
                cellSnapshot.tag = 5
                (viewController as! MusicPlayerViewController).menuBar.highlightCell(index: 0)
                UIView.animate(withDuration: 0.3, animations: {
                    self.cellSnapshot.transform = CGAffineTransform.init(scaleX: 0.5, y: 0.5).concatenating(CGAffineTransform.init(translationX: -self.viewController!.view.frame.width/6, y: 0))
                })
            }
        } else if canDelete() && cellSnapshot.center.y > viewController!.view.frame.size.height - quickBarHeight {
            if cellSnapshot.tag == 0 {
                cellSnapshot.tag = -5
                (viewController as! MusicPlayerViewController).menuBar.highlightCell(index: 0)
                UIView.animate(withDuration: 0.3, animations: {
                    self.deleteLabel!.backgroundColor = #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1)
                    self.cellSnapshot.transform = CGAffineTransform.init(scaleX: 1.5, y: 1.5).concatenating(CGAffineTransform.init(translationX: self.viewController!.view.frame.width/4, y: 0))
                })
            }
        } else {
            if cellSnapshot.tag != 0 {
                (viewController as! MusicPlayerViewController).menuBar.unhighlightCell(index: 0, wasSuccessful: false)
                cellSnapshot.tag = 0
                UIView.animate(withDuration: 0.3, animations: {
                    self.cellSnapshot.transform = CGAffineTransform.identity
                    if let deleteLabel = self.deleteLabel, self.canDelete() == true {
                        deleteLabel.backgroundColor = #colorLiteral(red: 0.3176470697, green: 0.07450980693, blue: 0.02745098062, alpha: 1)
                    }
                })
            }
        }

    }
    
    final func endDragging() {
        let wasSuccessful = cellSnapshot.center.y < FauxBarHeight + SongCellHeight/4
        let wasDeleted = cellSnapshot.center.y > (viewController?.view.frame.size.height)! - FauxBarHeight - SongCellHeight/4
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
        
        if canDelete() {
            if let deleteLabel = self.deleteLabel {
                deleteLabel.isHidden = true
            }
            
            if wasDeleted {
                didDeleteItemAtPath(indexPath: initialIndexPath!)
            }
        }
        
        print(musicManager.quickQueue)
    }
    
    final func cancelDragging() {
        cellSnapshot.removeFromSuperview()
        (viewController as! MusicPlayerViewController).menuBar.unhighlightCell(index: 0, wasSuccessful: false)
        let cell = indexView.cell(atIndexPath: initialIndexPath!)
        cell?.cell.isHidden = false
        cell?.cell.alpha = 1.0
        currentlyDragging = false
        if let deleteLabel = self.deleteLabel {
            deleteLabel.isHidden = true
        }
    }
    
    
    final func snapshopOfCell(inputView: UIView) -> UIView {
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
