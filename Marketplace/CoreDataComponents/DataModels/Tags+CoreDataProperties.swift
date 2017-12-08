//
//  Tags+CoreDataProperties.swift
//  Marketplace
//
//  Created by student on 12/8/17.
//  Copyright © 2017 SSU. All rights reserved.
//
//

import Foundation
import CoreData


extension Tags {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Tags> {
        return NSFetchRequest<Tags>(entityName: "Tags")
    }

    @NSManaged public var item_id: Int32
    @NSManaged public var tag: String?
    @NSManaged public var item: Item?

}
