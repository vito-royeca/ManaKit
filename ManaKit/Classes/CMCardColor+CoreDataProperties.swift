//
//  CMCardColor+CoreDataProperties.swift
//  Pods
//
//  Created by Jovito Royeca on 05/11/2018.
//
//

import Foundation
import CoreData


extension CMCardColor {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CMCardColor> {
        return NSFetchRequest<CMCardColor>(entityName: "CMCardColor")
    }

    @NSManaged public var name: String?
    @NSManaged public var symbol: String?
    @NSManaged public var cardColors: NSSet?
    @NSManaged public var cardIdentities: NSSet?
    @NSManaged public var cardIndicators: NSSet?

}

// MARK: Generated accessors for cardColors
extension CMCardColor {

    @objc(addCardColorsObject:)
    @NSManaged public func addToCardColors(_ value: CMCard)

    @objc(removeCardColorsObject:)
    @NSManaged public func removeFromCardColors(_ value: CMCard)

    @objc(addCardColors:)
    @NSManaged public func addToCardColors(_ values: NSSet)

    @objc(removeCardColors:)
    @NSManaged public func removeFromCardColors(_ values: NSSet)

}

// MARK: Generated accessors for cardIdentities
extension CMCardColor {

    @objc(addCardIdentitiesObject:)
    @NSManaged public func addToCardIdentities(_ value: CMCard)

    @objc(removeCardIdentitiesObject:)
    @NSManaged public func removeFromCardIdentities(_ value: CMCard)

    @objc(addCardIdentities:)
    @NSManaged public func addToCardIdentities(_ values: NSSet)

    @objc(removeCardIdentities:)
    @NSManaged public func removeFromCardIdentities(_ values: NSSet)

}

// MARK: Generated accessors for cardIndicators
extension CMCardColor {

    @objc(addCardIndicatorsObject:)
    @NSManaged public func addToCardIndicators(_ value: CMCard)

    @objc(removeCardIndicatorsObject:)
    @NSManaged public func removeFromCardIndicators(_ value: CMCard)

    @objc(addCardIndicators:)
    @NSManaged public func addToCardIndicators(_ values: NSSet)

    @objc(removeCardIndicators:)
    @NSManaged public func removeFromCardIndicators(_ values: NSSet)

}
