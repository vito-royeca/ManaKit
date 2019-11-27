//
//  CMLayout+CoreDataProperties.swift
//  Pods
//
//  Created by Vito Royeca on 11/26/19.
//
//

import Foundation
import CoreData


extension CMLayout {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CMLayout> {
        return NSFetchRequest<CMLayout>(entityName: "CMLayout")
    }

    @NSManaged public var name: String?
    @NSManaged public var nameSection: String?
    @NSManaged public var description_: String?
    @NSManaged public var cards: NSSet?

}

// MARK: Generated accessors for cards
extension CMLayout {

    @objc(addCardsObject:)
    @NSManaged public func addToCards(_ value: CMCard)

    @objc(removeCardsObject:)
    @NSManaged public func removeFromCards(_ value: CMCard)

    @objc(addCards:)
    @NSManaged public func addToCards(_ values: NSSet)

    @objc(removeCards:)
    @NSManaged public func removeFromCards(_ values: NSSet)

}
