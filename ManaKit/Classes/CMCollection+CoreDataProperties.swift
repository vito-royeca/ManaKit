//
//  CMCollection+CoreDataProperties.swift
//  Pods
//
//  Created by Jovito Royeca on 23/10/2018.
//
//

import Foundation
import CoreData


extension CMCollection {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CMCollection> {
        return NSFetchRequest<CMCollection>(entityName: "CMCollection")
    }

    @NSManaged public var createdOn: NSDate?
    @NSManaged public var description_: String?
    @NSManaged public var id: String?
    @NSManaged public var isPrivate: Bool
    @NSManaged public var name: String?
    @NSManaged public var nameSection: String?
    @NSManaged public var updatedOn: NSDate?
    @NSManaged public var views: Int64
    @NSManaged public var cards: NSSet?
    @NSManaged public var pricing: CMCardPricing?

}

// MARK: Generated accessors for cards
extension CMCollection {

    @objc(addCardsObject:)
    @NSManaged public func addToCards(_ value: CMCardInventory)

    @objc(removeCardsObject:)
    @NSManaged public func removeFromCards(_ value: CMCardInventory)

    @objc(addCards:)
    @NSManaged public func addToCards(_ values: NSSet)

    @objc(removeCards:)
    @NSManaged public func removeFromCards(_ values: NSSet)

}
