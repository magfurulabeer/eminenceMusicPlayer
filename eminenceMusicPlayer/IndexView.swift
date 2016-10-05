//
//  IndexView.swift
//  eminenceMusicPlayer
//
//  Created by Magfurul Abeer on 10/2/16.
//  Copyright © 2016 Magfurul Abeer. All rights reserved.
//

import UIKit

protocol IndexView {
    var view: UIView { get}
    var visibleIndexViewCells: [IndexViewCell] { get }
    func indexPathForCell(at point: CGPoint) -> IndexPath?
    func cell(atIndexPath indexPath: IndexPath) -> IndexViewCell?
    func forEachVisibleCell(closure: (IndexViewCell) -> Void)
    func reload()
}

extension IndexView where Self : UIView {
    final var view: UIView {
        return self
    }
}

extension UITableView: IndexView {

    final var visibleIndexViewCells: [IndexViewCell] {
        return self.visibleCells
    }
    
    final func indexPathForCell(at point: CGPoint) -> IndexPath? {
        return self.indexPathForRow(at: point)
    }
    
    final func cell(atIndexPath indexPath: IndexPath) -> IndexViewCell? {
        return self.cellForRow(at: indexPath)
    }
    
    final func forEachVisibleCell(closure: (IndexViewCell) -> Void) {
        for cell in self.visibleCells {
            closure(cell)
        }
    }

    final func reload() {
        self.reloadData()
    }
}

extension UICollectionView: IndexView {
    
    final var visibleIndexViewCells: [IndexViewCell] {
        return self.visibleCells
    }
    
    final func indexPathForCell(at point: CGPoint) -> IndexPath? {
        return self.indexPathForItem(at: point)
    }
    
    final func cell(atIndexPath indexPath: IndexPath) -> IndexViewCell? {
        return self.cellForItem(at: indexPath)
    }
    
    final func forEachVisibleCell(closure: (IndexViewCell) -> Void) {
        for cell in self.visibleCells {
            closure(cell)
        }
    }
    
    final func reload() {
        self.reloadData()
    }
}
