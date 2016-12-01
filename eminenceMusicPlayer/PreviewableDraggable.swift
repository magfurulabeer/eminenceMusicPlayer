//
//  PreviewableDraggable.swift
//  eminenceMusicPlayer
//
//  Created by Magfurul Abeer on 10/2/16.
//  Copyright © 2016 Magfurul Abeer. All rights reserved.
//

import UIKit

// TODO: Replace chains of if statements with switch statement. Consider refactoring further if possible.

/// This protocol is for any class that needs it's displayed songs to be previewable AND draggable. Holding onto the cell/items album thumbnail should allow you to drag it and drop it onto the Playlist tab to add it to the quick queue it.
protocol PreviewableDraggable: Previewable {
    
    
    
    // MARK: Properties
    
    
    
    /// Reference to the view controller upon which the PreviewableDraggable object sits (the view controller can be the object).
    weak var viewController: UIViewController? { get set }
    
    
    /// A snapshot taken of the cell mainly to drag around.
    var cellSnapshot: UIView { get set }
    
    
    /// The index path of cell being dragged.
    var initialIndexPath: IndexPath? { get set }
    
    
    /// Whether or not a cell is being dragged.
    var currentlyDragging: Bool { get set }
    
    
    /// A label that functions as a delete button.
    var deleteLabel: UILabel? { get set }
    
    
    
    // MARK: Properties
    
    
    
    /**
     Handles whether to end previewing or send to the appropriate handler (previewing or dragging).
     
     - Parameters:
     - sender: Activated long press gesture recognizer
     */
    func handleLongPress(sender: UILongPressGestureRecognizer)
    
    
    /**
     Decides and prepares for whether to begin, change, end, or cancel dragging.
     
     - Parameters:
     - sender: Activated long press gesture recognizer
     - indexPath: IndexPath of the selected cell/item
     */
    func handleLongPressDragging(sender: UILongPressGestureRecognizer, indexPath: IndexPath?)
    
    
    /**
     Starts dragging the cell.
     
     - Parameters:
     - indexPath: IndexPath of the selected cell/item
     */
    func startDragging(sender: UILongPressGestureRecognizer, indexPath: IndexPath)
    
    
    /**
     Moves the dragged cell.
     
     - Parameters:
     - indexPath: IndexPath of the selected cell/item
     */
    func changeDragging(sender: UILongPressGestureRecognizer)
    
    
    /**
     Ends dragging the cell. Any quick queueing or deleting is applied.
     
     - Parameters:
     - indexPath: IndexPath of the selected cell/item
     */
    func endDragging()
    
    
    /**
     Cancels dragging the cell. No quick queueing or deleting considered.
     
     - Parameters:
     - indexPath: IndexPath of the selected cell/item
     */
    func cancelDragging()
    
    
    /**
     Offset of the cell that can trigger a drag AKA contains the album image.

     - Returns: CGFloat of the offset that contains the album image
     */
    func draggingOffset() -> CGFloat
    
    
    /**
     Whether or not the item has a delete option.
     
     - Returns: Boolean representing whether or not selected item can be deleted
     */
    func canDelete() -> Bool
    
    
    /**
     What happens when an item is deleted.
     
     - Parameters:
     - indexPath: IndexPath of the selected cell/item
     */
    func didDeleteItemAtPath(indexPath: IndexPath)
}

extension PreviewableDraggable {
    
    
    /**
     Whether or not the item has a delete option. Only PreviewableDraggable objects that require the delete function should override this. Otherwise it defaults to false.
     
     - Returns: Boolean representing whether or not selected item can be deleted
     */
    func canDelete() -> Bool {
        return false
    }
    
    
    /**
     What happens when an item is deleted. Only PreviewableDraggable objects that require the delete function should override this. Otherwise it defaults to an empty function.
     
     - Parameters:
     - indexPath: IndexPath of the selected cell/item
     */
    func didDeleteItemAtPath(indexPath: IndexPath) {}
    
    
    /**
     Handles whether to end previewing or send to the appropriate handler (previewing or dragging).
     
     - Parameters:
     - sender: Activated long press gesture recognizer
     */
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
    
    
    /**
     Decides and prepares for whether to begin, change, end, or cancel dragging.
     
     - Parameters:
     - sender: Activated long press gesture recognizer
     - indexPath: IndexPath of the selected cell/item
     */
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
    
    
    /**
     Starts dragging the cell.
     
     - Parameters:
     - indexPath: IndexPath of the selected cell/item
     */
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
            if self.currentlyDragging {
                cell.isHidden = true
            }
        })

    }
    
    
    /**
     Moves the dragged cell.
     
     - Parameters:
     - indexPath: IndexPath of the selected cell/item
     */
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
    
    
    /**
     Ends dragging the cell. Any quick queueing or deleting is applied.
     
     - Parameters:
     - indexPath: IndexPath of the selected cell/item
     */
    final func endDragging() {
        currentlyDragging = false

        let wasSuccessful = cellSnapshot.center.y < FauxBarHeight + SongCellHeight/4
        let wasDeleted = cellSnapshot.center.y > (viewController?.view.frame.size.height)! - FauxBarHeight - SongCellHeight/4
        cellSnapshot.removeFromSuperview()
        (viewController as! MusicPlayerViewController).menuBar.unhighlightCell(index: 0, wasSuccessful: wasSuccessful)
        // TODO: When does this not exist
        let cell = indexView.cell(atIndexPath: initialIndexPath!) as! UITableViewCell
        
        cell.isHidden = false
        cell.alpha = 1.0

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
    }
    
    
    /**
     Cancels dragging the cell. No quick queueing or deleting considered.
     
     - Parameters:
     - indexPath: IndexPath of the selected cell/item
     */
    final func cancelDragging() {
        cellSnapshot.removeFromSuperview()
        (viewController as! MusicPlayerViewController).menuBar.unhighlightCell(index: 0, wasSuccessful: false)
        let cell = indexView.cell(atIndexPath: initialIndexPath!)
        print(initialIndexPath?.row)
        cell?.cell.isHidden = false
        cell?.cell.alpha = 1.0
        currentlyDragging = false
        if let deleteLabel = self.deleteLabel {
            deleteLabel.isHidden = true
        }
    }
    
    
    /**
     Creates a snapshot of the cell at given indexPath.
     
     - Parameters:
     - inputView: View to snapshot
     
     - Returns: Snapshot of cell
     */
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
