//
//  CMBorder+CoreDataProperties.swift
//  Pods
//
//  Created by Jovito Royeca on 15/04/2017.
//
//

import Foundation
import CoreData


extension CMBorder {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CMBorder> {
        return NSFetchRequest<CMBorder>(entityName: "CMBorder")
    }

    @NSManaged public var name: String?
    @NSManaged public var cards: NSSet?
    @NSManaged public var sets: NSSet?

}

// MARK: Generated accessors for cards
extension CMBorder {

    @objc(addCardsObject:)
    @NSManaged public func addToCards(_ value: CMCard)

    @objc(removeCardsObject:)
    @NSManaged public func removeFromCards(_ value: CMCard)

    @objc(addCards:)
    @NSManaged public func addToCards(_ values: NSSet)

    @objc(removeCards:)
    @NSManaged public func removeFromCards(_ values: NSSet)

}

// MARK: Generated accessors for sets
extension CMBorder {

    @objc(addSetsObject:)
    @NSManaged public func addToSets(_ value: CMSet)

    @objc(removeSetsObject:)
    @NSManaged public func removeFromSets(_ value: CMSet)

    @objc(addSets:)
    @NSManaged public func addToSets(_ values: NSSet)

    @objc(removeSets:)
    @NSManaged public func removeFromSets(_ values: NSSet)

}
