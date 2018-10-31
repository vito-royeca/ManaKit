//
//  CMCardFormat+CoreDataProperties.swift
//  Pods
//
//  Created by Jovito Royeca on 30/10/2018.
//
//

import Foundation
import CoreData


extension CMCardFormat {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CMCardFormat> {
        return NSFetchRequest<CMCardFormat>(entityName: "CMCardFormat")
    }

    @NSManaged public var name: String?
    @NSManaged public var nameSection: String?
    @NSManaged public var cardLegalities: NSSet?
    @NSManaged public var decks: NSSet?

}

// MARK: Generated accessors for cardLegalities
extension CMCardFormat {

    @objc(addCardLegalitiesObject:)
    @NSManaged public func addToCardLegalities(_ value: CMCardLegality)

    @objc(removeCardLegalitiesObject:)
    @NSManaged public func removeFromCardLegalities(_ value: CMCardLegality)

    @objc(addCardLegalities:)
    @NSManaged public func addToCardLegalities(_ values: NSSet)

    @objc(removeCardLegalities:)
    @NSManaged public func removeFromCardLegalities(_ values: NSSet)

}

// MARK: Generated accessors for decks
extension CMCardFormat {

    @objc(addDecksObject:)
    @NSManaged public func addToDecks(_ value: CMDeck)

    @objc(removeDecksObject:)
    @NSManaged public func removeFromDecks(_ value: CMDeck)

    @objc(addDecks:)
    @NSManaged public func addToDecks(_ values: NSSet)

    @objc(removeDecks:)
    @NSManaged public func removeFromDecks(_ values: NSSet)

}
