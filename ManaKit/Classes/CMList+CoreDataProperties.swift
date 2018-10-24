//
//  CMList+CoreDataProperties.swift
//  Pods
//
//  Created by Jovito Royeca on 23/10/2018.
//
//

import Foundation
import CoreData


extension CMList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CMList> {
        return NSFetchRequest<CMList>(entityName: "CMList")
    }

    @NSManaged public var createdOn: NSDate?
    @NSManaged public var description_: String?
    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var nameSection: String?
    @NSManaged public var query: NSData?
    @NSManaged public var updatedOn: NSDate?
    @NSManaged public var views: Int64
    @NSManaged public var cards: NSSet?
    @NSManaged public var user: CMUser?

}

// MARK: Generated accessors for cards
extension CMList {

    @objc(addCardsObject:)
    @NSManaged public func addToCards(_ value: CMCardInventory)

    @objc(removeCardsObject:)
    @NSManaged public func removeFromCards(_ value: CMCardInventory)

    @objc(addCards:)
    @NSManaged public func addToCards(_ values: NSSet)

    @objc(removeCards:)
    @NSManaged public func removeFromCards(_ values: NSSet)

}
