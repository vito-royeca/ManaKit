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
    @NSManaged public var componentParts: NSSet?

}

// MARK: Generated accessors for cardComponentParts
extension CMComponent {

    @objc(addComponentPartsObject:)
    @NSManaged public func addToComponentParts(_ value: CMCardComponentPart)

    @objc(removeComponentPartsObject:)
    @NSManaged public func removeFromComponentParts(_ value: CMCardComponentPart)

    @objc(addComponentParts:)
    @NSManaged public func addToComponentParts(_ values: NSSet)

    @objc(removeComponentParts:)
    @NSManaged public func removeFromComponentParts(_ values: NSSet)

}
