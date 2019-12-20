//
//  MGLegality+CoreDataProperties.swift
//  Pods
//
//  Created by Vito Royeca on 12/14/19.
//
//

import Foundation
import CoreData


extension MGLegality {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MGLegality> {
        return NSFetchRequest<MGLegality>(entityName: "MGLegality")
    }

    @NSManaged public var name: String?
    @NSManaged public var nameSection: String?
    @NSManaged public var cardFormatLegalities: NSSet?

}

// MARK: Generated accessors for cardFormatLegalities
extension MGLegality {

    @objc(addCardFormatLegalitiesObject:)
    @NSManaged public func addToCardFormatLegalities(_ value: MGCardFormatLegality)

    @objc(removeCardFormatLegalitiesObject:)
    @NSManaged public func removeFromCardFormatLegalities(_ value: MGCardFormatLegality)

    @objc(addCardFormatLegalities:)
    @NSManaged public func addToCardFormatLegalities(_ values: NSSet)

    @objc(removeCardFormatLegalities:)
    @NSManaged public func removeFromCardFormatLegalities(_ values: NSSet)

}
