//
//  CMDeck+CoreDataProperties.swift
//  Pods
//
//  Created by Jovito Royeca on 10/11/2018.
//
//

import Foundation
import CoreData


extension CMDeck {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CMDeck> {
        return NSFetchRequest<CMDeck>(entityName: "CMDeck")
    }

    @NSManaged public var colors: String?
    @NSManaged public var createdOn: NSDate?
    @NSManaged public var description_: String?
    @NSManaged public var id: String?
    @NSManaged public var mainboard: Int32
    @NSManaged public var name: String?
    @NSManaged public var nameSection: String?
    @NSManaged public var originalCreator: String?
    @NSManaged public var sideboard: Int32
    @NSManaged public var updatedOn: NSDate?
    @NSManaged public var views: Int64
    @NSManaged public var cards: NSSet?
    @NSManaged public var format: CMCardFormat?
    @NSManaged public var heroCard: CMCard?
    @NSManaged public var pricing: CMCardPricing?
    @NSManaged public var user: CMUser?

}

// MARK: Generated accessors for cards
extension CMDeck {

    @objc(addCardsObject:)
    @NSManaged public func addToCards(_ value: CMInventory)

    @objc(removeCardsObject:)
    @NSManaged public func removeFromCards(_ value: CMInventory)

    @objc(addCards:)
    @NSManaged public func addToCards(_ values: NSSet)

    @objc(removeCards:)
    @NSManaged public func removeFromCards(_ values: NSSet)

}
