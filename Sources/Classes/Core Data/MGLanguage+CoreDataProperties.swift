//
//  MGLanguage+CoreDataProperties.swift
//  
//
//  Created by Vito Royeca on 12/27/21.
//
//

import Foundation
import CoreData


extension MGLanguage {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MGLanguage> {
        return NSFetchRequest<MGLanguage>(entityName: "MGLanguage")
    }

    @NSManaged public var code: String?
    @NSManaged public var displayCode: String?
    @NSManaged public var name: String?
    @NSManaged public var nameSection: String?
    @NSManaged public var cards: NSSet?
    @NSManaged public var sets: NSSet?

}

// MARK: Generated accessors for cards
extension MGLanguage {

    @objc(addCardsObject:)
    @NSManaged public func addToCards(_ value: MGCard)

    @objc(removeCardsObject:)
    @NSManaged public func removeFromCards(_ value: MGCard)

    @objc(addCards:)
    @NSManaged public func addToCards(_ values: NSSet)

    @objc(removeCards:)
    @NSManaged public func removeFromCards(_ values: NSSet)

}

// MARK: Generated accessors for sets
extension MGLanguage {

    @objc(addSetsObject:)
    @NSManaged public func addToSets(_ value: MGSet)

    @objc(removeSetsObject:)
    @NSManaged public func removeFromSets(_ value: MGSet)

    @objc(addSets:)
    @NSManaged public func addToSets(_ values: NSSet)

    @objc(removeSets:)
    @NSManaged public func removeFromSets(_ values: NSSet)

}
