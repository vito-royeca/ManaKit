//
//  MGKeyword+CoreDataProperties.swift
//
//
//  Created by Vito Royeca on 12/13/23.
//

import Foundation
import CoreData


extension MGKeyword {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MGKeyword> {
        return NSFetchRequest<MGKeyword>(entityName: "MGKeyword")
    }

    @NSManaged public var name: String?
    @NSManaged public var nameSection: String?
    @NSManaged public var cards: NSSet?

}

// MARK: Generated accessors for cards
extension MGKeyword {

    @objc(addCardsObject:)
    @NSManaged public func addToCards(_ value: MGCard)

    @objc(removeCardsObject:)
    @NSManaged public func removeFromCards(_ value: MGCard)

    @objc(addCards:)
    @NSManaged public func addToCards(_ values: NSSet)

    @objc(removeCards:)
    @NSManaged public func removeFromCards(_ values: NSSet)

}
