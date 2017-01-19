//
//  EMMediaItem+CoreDataProperties.swift
//  eminenceMusicPlayer
//
//  Created by Magfurul Abeer on 1/19/17.
//  Copyright © 2017 Magfurul Abeer. All rights reserved.
//

import Foundation
import CoreData

extension EMMediaItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<EMMediaItem> {
        return NSFetchRequest<EMMediaItem>(entityName: "EMMediaItem");
    }

    @NSManaged public var id: Int64
    @NSManaged public var index: Int32
    @NSManaged public var playlist: EMMediaPlaylist?

}
