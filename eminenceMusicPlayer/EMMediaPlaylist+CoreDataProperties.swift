//
//  EMMediaPlaylist+CoreDataProperties.swift
//  eminenceMusicPlayer
//
//  Created by Magfurul Abeer on 1/19/17.
//  Copyright © 2017 Magfurul Abeer. All rights reserved.
//

import Foundation
import CoreData

extension EMMediaPlaylist {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<EMMediaPlaylist> {
        return NSFetchRequest<EMMediaPlaylist>(entityName: "EMMediaPlaylist");
    }

    @NSManaged public var name: String?
    @NSManaged public var items: NSOrderedSet?

}

// MARK: Generated accessors for items
extension EMMediaPlaylist {

    @objc(insertObject:inItemsAtIndex:)
    @NSManaged public func insertIntoItems(_ value: EMMediaItem, at idx: Int)

    @objc(removeObjectFromItemsAtIndex:)
    @NSManaged public func removeFromItems(at idx: Int)

    @objc(insertItems:atIndexes:)
    @NSManaged public func insertIntoItems(_ values: [EMMediaItem], at indexes: NSIndexSet)

    @objc(removeItemsAtIndexes:)
    @NSManaged public func removeFromItems(at indexes: NSIndexSet)

    @objc(replaceObjectInItemsAtIndex:withObject:)
    @NSManaged public func replaceItems(at idx: Int, with value: EMMediaItem)

    @objc(replaceItemsAtIndexes:withItems:)
    @NSManaged public func replaceItems(at indexes: NSIndexSet, with values: [EMMediaItem])

    @objc(addItemsObject:)
    @NSManaged public func addToItems(_ value: EMMediaItem)

    @objc(removeItemsObject:)
    @NSManaged public func removeFromItems(_ value: EMMediaItem)

    @objc(addItems:)
    @NSManaged public func addToItems(_ values: NSOrderedSet)

    @objc(removeItems:)
    @NSManaged public func removeFromItems(_ values: NSOrderedSet)

}
