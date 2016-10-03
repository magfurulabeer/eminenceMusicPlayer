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
}

extension IndexView where Self : UIView {
    var view: UIView {
        return self
    }
}

extension UITableView: IndexView {

    var visibleIndexViewCells: [IndexViewCell] {
        return self.visibleCells
    }
    
    func indexPathForCell(at point: CGPoint) -> IndexPath? {
        return self.indexPathForRow(at: point)
    }
    
    func cell(atIndexPath indexPath: IndexPath) -> IndexViewCell? {
        return self.cellForRow(at: indexPath)
    }
    
    func forEachVisibleCell(closure: (IndexViewCell) -> Void) {
        for cell in self.visibleCells {
            closure(cell)
        }
    }

}

extension UICollectionView: IndexView {
    
    var visibleIndexViewCells: [IndexViewCell] {
        return self.visibleCells
    }
    
    func indexPathForCell(at point: CGPoint) -> IndexPath? {
        return self.indexPathForItem(at: point)
    }
    
    func cell(atIndexPath indexPath: IndexPath) -> IndexViewCell? {
        return self.cellForItem(at: indexPath)
    }
    
    func forEachVisibleCell(closure: (IndexViewCell) -> Void) {
        for cell in self.visibleCells {
            closure(cell)
        }
    }
}
