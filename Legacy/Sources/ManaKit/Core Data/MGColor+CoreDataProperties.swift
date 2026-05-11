//
//  MGColor+CoreDataProperties.swift
//  
//
//  Created by Vito Royeca on 12/27/21.
//
//

import Foundation
import CoreData


extension MGColor {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MGColor> {
        return NSFetchRequest<MGColor>(entityName: "MGColor")
    }

    @NSManaged public var name: String?
    @NSManaged public var nameSection: String?
    @NSManaged public var symbol: String?
    @NSManaged public var cards: NSSet?
    @NSManaged public var identities: NSSet?
    @NSManaged public var indicators: NSSet?

}

// MARK: Generated accessors for cards
extension MGColor {

    @objc(addCardsObject:)
    @NSManaged public func addToCards(_ value: MGCard)

    @objc(removeCardsObject:)
    @NSManaged public func removeFromCards(_ value: MGCard)

    @objc(addCards:)
    @NSManaged public func addToCards(_ values: NSSet)

    @objc(removeCards:)
    @NSManaged public func removeFromCards(_ values: NSSet)

}

// MARK: Generated accessors for identities
extension MGColor {

    @objc(addIdentitiesObject:)
    @NSManaged public func addToIdentities(_ value: MGCard)

    @objc(removeIdentitiesObject:)
    @NSManaged public func removeFromIdentities(_ value: MGCard)

    @objc(addIdentities:)
    @NSManaged public func addToIdentities(_ values: NSSet)

    @objc(removeIdentities:)
    @NSManaged public func removeFromIdentities(_ values: NSSet)

}

// MARK: Generated accessors for indicators
extension MGColor {

    @objc(addIndicatorsObject:)
    @NSManaged public func addToIndicators(_ value: MGCard)

    @objc(removeIndicatorsObject:)
    @NSManaged public func removeFromIndicators(_ value: MGCard)

    @objc(addIndicators:)
    @NSManaged public func addToIndicators(_ values: NSSet)

    @objc(removeIndicators:)
    @NSManaged public func removeFromIndicators(_ values: NSSet)

}
