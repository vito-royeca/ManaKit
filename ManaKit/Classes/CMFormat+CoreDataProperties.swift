//
//  CMFormat+CoreDataProperties.swift
//  Pods
//
//  Created by Vito Royeca on 11/26/19.
//
//

import Foundation
import CoreData


extension CMFormat {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CMFormat> {
        return NSFetchRequest<CMFormat>(entityName: "CMFormat")
    }

    @NSManaged public var name: String?
    @NSManaged public var nameSection: String?
    @NSManaged public var cardFormatLegalities: NSSet?

}

// MARK: Generated accessors for cardFormatLegalities
extension CMFormat {

    @objc(addCardFormatLegalitiesObject:)
    @NSManaged public func addToCardFormatLegalities(_ value: CMCardFormatLegality)

    @objc(removeCardFormatLegalitiesObject:)
    @NSManaged public func removeFromCardFormatLegalities(_ value: CMCardFormatLegality)

    @objc(addCardFormatLegalities:)
    @NSManaged public func addToCardFormatLegalities(_ values: NSSet)

    @objc(removeCardFormatLegalities:)
    @NSManaged public func removeFromCardFormatLegalities(_ values: NSSet)

}
