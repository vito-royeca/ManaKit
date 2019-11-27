//
//  CMColor+CoreDataProperties.swift
//  Pods
//
//  Created by Vito Royeca on 11/26/19.
//
//

import Foundation
import CoreData


extension CMColor {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CMColor> {
        return NSFetchRequest<CMColor>(entityName: "CMColor")
    }

    @NSManaged public var name: String?
    @NSManaged public var symbol: String?
    @NSManaged public var nameSection: String?
    @NSManaged public var cards: NSSet?
    @NSManaged public var identities: NSSet?
    @NSManaged public var indicators: NSSet?

}

// MARK: Generated accessors for cards
extension CMColor {

    @objc(addCardsObject:)
    @NSManaged public func addToCards(_ value: CMCard)

    @objc(removeCardsObject:)
    @NSManaged public func removeFromCards(_ value: CMCard)

    @objc(addCards:)
    @NSManaged public func addToCards(_ values: NSSet)

    @objc(removeCards:)
    @NSManaged public func removeFromCards(_ values: NSSet)

}

// MARK: Generated accessors for identities
extension CMColor {

    @objc(addIdentitiesObject:)
    @NSManaged public func addToIdentities(_ value: CMCard)

    @objc(removeIdentitiesObject:)
    @NSManaged public func removeFromIdentities(_ value: CMCard)

    @objc(addIdentities:)
    @NSManaged public func addToIdentities(_ values: NSSet)

    @objc(removeIdentities:)
    @NSManaged public func removeFromIdentities(_ values: NSSet)

}

// MARK: Generated accessors for indicators
extension CMColor {

    @objc(addIndicatorsObject:)
    @NSManaged public func addToIndicators(_ value: CMCard)

    @objc(removeIndicatorsObject:)
    @NSManaged public func removeFromIndicators(_ value: CMCard)

    @objc(addIndicators:)
    @NSManaged public func addToIndicators(_ values: NSSet)

    @objc(removeIndicators:)
    @NSManaged public func removeFromIndicators(_ values: NSSet)

}
