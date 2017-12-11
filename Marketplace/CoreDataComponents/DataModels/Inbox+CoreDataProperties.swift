//
//  Inbox+CoreDataProperties.swift
//  
//
//  Created by student on 12/10/17.
//
//

import Foundation
import CoreData


extension Inbox {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Inbox> {
        return NSFetchRequest<Inbox>(entityName: "Inbox")
    }

    @NSManaged public var message: String?
    @NSManaged public var msg_id: NSNumber?
    @NSManaged public var recipient_email: String?
    @NSManaged public var sender_email: String?
    @NSManaged public var subject: String?
    @NSManaged public var item: Item?
    @NSManaged public var user: User?

}
