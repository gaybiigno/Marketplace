//
//  Pictures+CoreDataProperties.swift
//  Marketplace
//
//  Created by student on 12/8/17.
//  Copyright © 2017 SSU. All rights reserved.
//
//

import Foundation
import CoreData


extension Pictures {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Pictures> {
        return NSFetchRequest<Pictures>(entityName: "Pictures")
    }

    @NSManaged public var img_data: NSData?
    @NSManaged public var img_id: Int32
    @NSManaged public var item_id: Int32
    @NSManaged public var item: Item?

}
