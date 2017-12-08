//
//  Inbox+CoreDataProperties.swift
//  Marketplace
//
//  Created by student on 12/8/17.
//  Copyright © 2017 SSU. All rights reserved.
//
//

import Foundation
import CoreData


extension Inbox {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Inbox> {
        return NSFetchRequest<Inbox>(entityName: "Inbox")
    }

    @NSManaged public var recipient_email: String?
    @NSManaged public var msg_id: NSNumber?
    @NSManaged public var sender_email: String?
    @NSManaged public var message: String?
    @NSManaged public var item: Item?
    @NSManaged public var user: User?

}
