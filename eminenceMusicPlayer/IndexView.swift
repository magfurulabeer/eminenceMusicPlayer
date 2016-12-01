//
//  IndexView.swift
//  eminenceMusicPlayer
//
//  Created by Magfurul Abeer on 10/2/16.
//  Copyright © 2016 Magfurul Abeer. All rights reserved.
//

import UIKit

/// This protocol is the common denominator between TableViews and CollectionViews. It includes methods that are generally available in both but not from same inheritance chain.
protocol IndexView {
    
    
    
    // MARK: Properties
    
    
    
    /// The actual view itself.
    var view: UIView { get}
    
    /// An array of all the visible cells.
    var visibleIndexViewCells: [IndexViewCell] { get }
    
    
    
    /// MARK: Methods
    
    
    
    /**
     Index Path for cell/time at given point on screen.
     
     - Parameters:
     - point: Where the users finger is touching the screen
     
     - Returns: Appropriate index path
     */
    func indexPathForCell(at point: CGPoint) -> IndexPath?
    
    
    /**
     Wrapper around cellForRow and cellForItem.
     
     - Parameters:
     - inputView: View to snapshot
     
     - Returns: Appropriate index view cell
     */
    func cell(atIndexPath indexPath: IndexPath) -> IndexViewCell?
    
    
    /**
     Simple enumerator for visible cells.
     
     - Parameters:
     - closure: What you want to happen to each cell
     */
    func forEachVisibleCell(closure: (IndexViewCell) -> Void)
    
    
    /**
     Wrapper around reloadData to prevent unnecessary downcasting
     */
    func reload()
}

/// This extension is for all conforming views.
extension IndexView where Self : UIView {
    
    /// Returns self as a UIView
    final var view: UIView {
        return self
    }
}

extension UITableView: IndexView {

    /// An array of all the visible cells.
    final var visibleIndexViewCells: [IndexViewCell] {
        return self.visibleCells
    }
    
    
    /**
     Index Path for cell/time at given point on screen.
     
     - Parameters:
     - point: Where the users finger is touching the screen
     
     - Returns: Appropriate index path
     */
    final func indexPathForCell(at point: CGPoint) -> IndexPath? {
        return self.indexPathForRow(at: point)
    }
    
    
    /**
     Wrapper around cellForRow and cellForItem.
     
     - Parameters:
     - inputView: View to snapshot
     
     - Returns: Appropriate index view cell
     */
    final func cell(atIndexPath indexPath: IndexPath) -> IndexViewCell? {
        return self.cellForRow(at: indexPath)
    }
    
    
    /**
     Simple enumerator for visible cells.
     
     - Parameters:
     - closure: What you want to happen to each cell
     */
    final func forEachVisibleCell(closure: (IndexViewCell) -> Void) {
        for cell in self.visibleCells {
            closure(cell)
        }
    }

    
    /**
     Wrapper around reloadData to prevent unnecessary downcasting
     */
    final func reload() {
        self.reloadData()
    }
}

extension UICollectionView: IndexView {
    
    /// An array of all the visible cells.
    final var visibleIndexViewCells: [IndexViewCell] {
        return self.visibleCells
    }
    
    
    /**
     Index Path for cell/time at given point on screen.
     
     - Parameters:
     - point: Where the users finger is touching the screen
     
     - Returns: Appropriate index path
     */
    final func indexPathForCell(at point: CGPoint) -> IndexPath? {
        return self.indexPathForItem(at: point)
    }
    
    
    /**
     Wrapper around cellForRow and cellForItem.
     
     - Parameters:
     - inputView: View to snapshot
     
     - Returns: Appropriate index view cell
     */
    final func cell(atIndexPath indexPath: IndexPath) -> IndexViewCell? {
        return self.cellForItem(at: indexPath)
    }
    
    
    /**
     Simple enumerator for visible cells.
     
     - Parameters:
     - closure: What you want to happen to each cell
     */
    final func forEachVisibleCell(closure: (IndexViewCell) -> Void) {
        for cell in self.visibleCells {
            closure(cell)
        }
    }
    
    
    /**
     Wrapper around reloadData to prevent unnecessary downcasting
     */
    final func reload() {
        self.reloadData()
    }
}
