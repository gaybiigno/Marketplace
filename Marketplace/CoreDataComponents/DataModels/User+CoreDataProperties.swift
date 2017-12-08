//
//  User+CoreDataProperties.swift
//  Marketplace
//
//  Created by student on 12/7/17.
//  Copyright © 2017 SSU. All rights reserved.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var bday: Int16
    @NSManaged public var bmonth: Int16
    @NSManaged public var byear: Int16
    @NSManaged public var city: String?
    @NSManaged public var first_name: String?
    @NSManaged public var last_name: String?
    @NSManaged public var payment: String?
    @NSManaged public var profilePicture: NSData?
    @NSManaged public var rating: Int16
    @NSManaged public var state: String?
    @NSManaged public var street: String?
    @NSManaged public var zip: String?
    @NSManaged public var email: String?
    @NSManaged public var item: NSSet?

}

// MARK: Generated accessors for item
extension User {

    @objc(addItemObject:)
    @NSManaged public func addToItem(_ value: Item)

    @objc(removeItemObject:)
    @NSManaged public func removeFromItem(_ value: Item)

    @objc(addItem:)
    @NSManaged public func addToItem(_ values: NSSet)

    @objc(removeItem:)
    @NSManaged public func removeFromItem(_ values: NSSet)

}
