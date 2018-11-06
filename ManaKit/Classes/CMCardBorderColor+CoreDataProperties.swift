//
//  CMCardBorderColor+CoreDataProperties.swift
//  Pods
//
//  Created by Jovito Royeca on 05/11/2018.
//
//

import Foundation
import CoreData


extension CMCardBorderColor {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CMCardBorderColor> {
        return NSFetchRequest<CMCardBorderColor>(entityName: "CMCardBorderColor")
    }

    @NSManaged public var name: String?
    @NSManaged public var nameSection: String?
    @NSManaged public var cards: NSSet?

}

// MARK: Generated accessors for cards
extension CMCardBorderColor {

    @objc(addCardsObject:)
    @NSManaged public func addToCards(_ value: CMCard)

    @objc(removeCardsObject:)
    @NSManaged public func removeFromCards(_ value: CMCard)

    @objc(addCards:)
    @NSManaged public func addToCards(_ values: NSSet)

    @objc(removeCards:)
    @NSManaged public func removeFromCards(_ values: NSSet)

}
