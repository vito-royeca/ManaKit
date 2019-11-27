//
//  CMComponent+CoreDataProperties.swift
//  Pods
//
//  Created by Vito Royeca on 11/26/19.
//
//

import Foundation
import CoreData


extension CMComponent {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CMComponent> {
        return NSFetchRequest<CMComponent>(entityName: "CMComponent")
    }

    @NSManaged public var name: String?
    @NSManaged public var nameSection: String?
    @NSManaged public var cardComponentParts: NSSet?

}

// MARK: Generated accessors for cardComponentParts
extension CMComponent {

    @objc(addCardComponentPartsObject:)
    @NSManaged public func addToCardComponentParts(_ value: CMCardComponentPart)

    @objc(removeCardComponentPartsObject:)
    @NSManaged public func removeFromCardComponentParts(_ value: CMCardComponentPart)

    @objc(addCardComponentParts:)
    @NSManaged public func addToCardComponentParts(_ values: NSSet)

    @objc(removeCardComponentParts:)
    @NSManaged public func removeFromCardComponentParts(_ values: NSSet)

}
