//
//  MGLayout+CoreDataProperties.swift
//  Pods
//
//  Created by Vito Royeca on 12/14/19.
//
//

import Foundation
import CoreData


extension MGLayout {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MGLayout> {
        return NSFetchRequest<MGLayout>(entityName: "MGLayout")
    }

    @NSManaged public var description_: String?
    @NSManaged public var name: String?
    @NSManaged public var nameSection: String?
    @NSManaged public var cards: NSSet?

}

// MARK: - Generated accessors for cards
extension MGLayout {

    @objc(addCardsObject:)
    @NSManaged public func addToCards(_ value: MGCard)

    @objc(removeCardsObject:)
    @NSManaged public func removeFromCards(_ value: MGCard)

    @objc(addCards:)
    @NSManaged public func addToCards(_ values: NSSet)

    @objc(removeCards:)
    @NSManaged public func removeFromCards(_ values: NSSet)

}
