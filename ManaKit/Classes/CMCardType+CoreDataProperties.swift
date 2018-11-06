//
//  CMCardType+CoreDataProperties.swift
//  Pods
//
//  Created by Jovito Royeca on 05/11/2018.
//
//

import Foundation
import CoreData


extension CMCardType {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CMCardType> {
        return NSFetchRequest<CMCardType>(entityName: "CMCardType")
    }

    @NSManaged public var name: String?
    @NSManaged public var nameSection: String?
    @NSManaged public var cardPrintedTypes: NSSet?
    @NSManaged public var cards: NSSet?
    @NSManaged public var language: CMLanguage?

}

// MARK: Generated accessors for cardPrintedTypes
extension CMCardType {

    @objc(addCardPrintedTypesObject:)
    @NSManaged public func addToCardPrintedTypes(_ value: CMCard)

    @objc(removeCardPrintedTypesObject:)
    @NSManaged public func removeFromCardPrintedTypes(_ value: CMCard)

    @objc(addCardPrintedTypes:)
    @NSManaged public func addToCardPrintedTypes(_ values: NSSet)

    @objc(removeCardPrintedTypes:)
    @NSManaged public func removeFromCardPrintedTypes(_ values: NSSet)

}

// MARK: Generated accessors for cards
extension CMCardType {

    @objc(addCardsObject:)
    @NSManaged public func addToCards(_ value: CMCard)

    @objc(removeCardsObject:)
    @NSManaged public func removeFromCards(_ value: CMCard)

    @objc(addCards:)
    @NSManaged public func addToCards(_ values: NSSet)

    @objc(removeCards:)
    @NSManaged public func removeFromCards(_ values: NSSet)

}
