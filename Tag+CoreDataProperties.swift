//
//  Tag+CoreDataProperties.swift
//  Marketplace
//
//  Created by student on 12/6/17.
//  Copyright © 2017 SSU. All rights reserved.
//
//

import Foundation
import CoreData


extension Tag {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Tag> {
        return NSFetchRequest<Tag>(entityName: "Tag")
    }

    @NSManaged public var item_id: Int32
    @NSManaged public var tag: String?
    @NSManaged public var item: Item?

}
