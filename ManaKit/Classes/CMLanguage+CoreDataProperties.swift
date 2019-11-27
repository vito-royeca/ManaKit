//
//  CMLanguage+CoreDataProperties.swift
//  Pods
//
//  Created by Vito Royeca on 11/26/19.
//
//

import Foundation
import CoreData


extension CMLanguage {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CMLanguage> {
        return NSFetchRequest<CMLanguage>(entityName: "CMLanguage")
    }

    @NSManaged public var code: String?
    @NSManaged public var displayCode: String?
    @NSManaged public var name: String?
    @NSManaged public var nameSection: String?
    @NSManaged public var sets: NSSet?
    @NSManaged public var cards: NSSet?

}

// MARK: Generated accessors for sets
extension CMLanguage {

    @objc(addSetsObject:)
    @NSManaged public func addToSets(_ value: CMSet)

    @objc(removeSetsObject:)
    @NSManaged public func removeFromSets(_ value: CMSet)

    @objc(addSets:)
    @NSManaged public func addToSets(_ values: NSSet)

    @objc(removeSets:)
    @NSManaged public func removeFromSets(_ values: NSSet)

}

// MARK: Generated accessors for cards
extension CMLanguage {

    @objc(addCardsObject:)
    @NSManaged public func addToCards(_ value: CMCard)

    @objc(removeCardsObject:)
    @NSManaged public func removeFromCards(_ value: CMCard)

    @objc(addCards:)
    @NSManaged public func addToCards(_ values: NSSet)

    @objc(removeCards:)
    @NSManaged public func removeFromCards(_ values: NSSet)

}
