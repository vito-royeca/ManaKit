//
//  CMCardPricing+CoreDataProperties.swift
//  Pods
//
//  Created by Jovito Royeca on 10/11/2018.
//
//

import Foundation
import CoreData


extension CMCardPricing {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CMCardPricing> {
        return NSFetchRequest<CMCardPricing>(entityName: "CMCardPricing")
    }

    @NSManaged public var average: Double
    @NSManaged public var foil: Double
    @NSManaged public var high: Double
    @NSManaged public var id: Int64
    @NSManaged public var lastUpdate: NSDate?
    @NSManaged public var link: String?
    @NSManaged public var low: Double
    @NSManaged public var cards: NSSet?
    @NSManaged public var collections: NSSet?
    @NSManaged public var decks: NSSet?

}

// MARK: Generated accessors for cards
extension CMCardPricing {

    @objc(addCardsObject:)
    @NSManaged public func addToCards(_ value: CMCard)

    @objc(removeCardsObject:)
    @NSManaged public func removeFromCards(_ value: CMCard)

    @objc(addCards:)
    @NSManaged public func addToCards(_ values: NSSet)

    @objc(removeCards:)
    @NSManaged public func removeFromCards(_ values: NSSet)

}

// MARK: Generated accessors for collections
extension CMCardPricing {

    @objc(addCollectionsObject:)
    @NSManaged public func addToCollections(_ value: CMCollection)

    @objc(removeCollectionsObject:)
    @NSManaged public func removeFromCollections(_ value: CMCollection)

    @objc(addCollections:)
    @NSManaged public func addToCollections(_ values: NSSet)

    @objc(removeCollections:)
    @NSManaged public func removeFromCollections(_ values: NSSet)

}

// MARK: Generated accessors for decks
extension CMCardPricing {

    @objc(addDecksObject:)
    @NSManaged public func addToDecks(_ value: CMDeck)

    @objc(removeDecksObject:)
    @NSManaged public func removeFromDecks(_ value: CMDeck)

    @objc(addDecks:)
    @NSManaged public func addToDecks(_ values: NSSet)

    @objc(removeDecks:)
    @NSManaged public func removeFromDecks(_ values: NSSet)

}
