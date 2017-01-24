//
//  EMArtist+CoreDataProperties.swift
//  eminenceMusicPlayer
//
//  Created by Magfurul Abeer on 1/24/17.
//  Copyright © 2017 Magfurul Abeer. All rights reserved.
//

import Foundation
import CoreData


extension EMArtist {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<EMArtist> {
        return NSFetchRequest<EMArtist>(entityName: "EMArtist");
    }

    @NSManaged public var summary: String?
    @NSManaged public var id: String?

}
