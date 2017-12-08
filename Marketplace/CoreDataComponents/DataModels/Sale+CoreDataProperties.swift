//
//  Sale+CoreDataProperties.swift
//  Marketplace
//
//  Created by student on 12/8/17.
//  Copyright © 2017 SSU. All rights reserved.
//
//

import Foundation
import CoreData


extension Sale {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Sale> {
        return NSFetchRequest<Sale>(entityName: "Sale")
    }

    @NSManaged public var item_id: NSNumber?
    @NSManaged public var buyer_email: String?
    @NSManaged public var sale_num: NSNumber?
    @NSManaged public var item: Item?
    @NSManaged public var seller: User?

}
