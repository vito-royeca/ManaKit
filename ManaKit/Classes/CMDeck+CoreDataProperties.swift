//
//  CMDeck+CoreDataProperties.swift
//  ManaKit
//
//  Created by Jovito Royeca on 23.08.18.
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
    @NSManaged public var name: String?
    @NSManaged public var nameSection: String?
    @NSManaged public var originalCreator: String?
    @NSManaged public var updatedOn: NSDate?
    @NSManaged public var format: CMFormat?
    @NSManaged public var heroCard: CMCard?
    @NSManaged public var mainboard: Int32
    @NSManaged public var pricing: CMCardPricing?
    @NSManaged public var sideboard: Int32
    @NSManaged public var views: Int64
    @NSManaged public var user: CMUser?
    @NSManaged public var cards: NSSet?

}

// MARK: Generated accessors for cards
extension CMDeck {

    @objc(addCardsObject:)
    @NSManaged public func addToCards(_ value: CMCardInventory)

    @objc(removeCardsObject:)
    @NSManaged public func removeFromCards(_ value: CMCardInventory)

    @objc(addCards:)
    @NSManaged public func addToCards(_ values: NSSet)

    @objc(removeCards:)
    @NSManaged public func removeFromCards(_ values: NSSet)

}
