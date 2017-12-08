//
//  Item+CoreDataProperties.swift
//  Marketplace
//
//  Created by student on 12/8/17.
//  Copyright © 2017 SSU. All rights reserved.
//
//

import Foundation
import CoreData


extension Item {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Item> {
        return NSFetchRequest<Item>(entityName: "Item")
    }

    @NSManaged public var item_category: String?
    @NSManaged public var item_description: String?
    @NSManaged public var item_id: Int32
    @NSManaged public var item_name: String?
    @NSManaged public var minAge: Int16
    @NSManaged public var price: Double
    @NSManaged public var quantity: Int16
    @NSManaged public var seller_email: String?
    @NSManaged public var picture: NSSet?
    @NSManaged public var tag: NSSet?
    @NSManaged public var user: User?

}

// MARK: Generated accessors for picture
extension Item {

    @objc(addPictureObject:)
    @NSManaged public func addToPicture(_ value: Pictures)

    @objc(removePictureObject:)
    @NSManaged public func removeFromPicture(_ value: Pictures)

    @objc(addPicture:)
    @NSManaged public func addToPicture(_ values: NSSet)

    @objc(removePicture:)
    @NSManaged public func removeFromPicture(_ values: NSSet)

}

// MARK: Generated accessors for tag
extension Item {

    @objc(addTagObject:)
    @NSManaged public func addToTag(_ value: Tags)

    @objc(removeTagObject:)
    @NSManaged public func removeFromTag(_ value: Tags)

    @objc(addTag:)
    @NSManaged public func addToTag(_ values: NSSet)

    @objc(removeTag:)
    @NSManaged public func removeFromTag(_ values: NSSet)

}
