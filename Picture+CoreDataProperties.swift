//
//  Picture+CoreDataProperties.swift
//  Marketplace
//
//  Created by student on 12/6/17.
//  Copyright © 2017 SSU. All rights reserved.
//
//

import Foundation
import CoreData


extension Picture {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Picture> {
        return NSFetchRequest<Picture>(entityName: "Picture")
    }

    @NSManaged public var img_data: NSData?
    @NSManaged public var img_id: Int32
    @NSManaged public var item_id: Int32
    @NSManaged public var item: Item?

}
