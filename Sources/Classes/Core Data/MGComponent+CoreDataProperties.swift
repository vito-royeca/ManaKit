//
//  MGComponent+CoreDataProperties.swift
//  
//
//  Created by Vito Royeca on 12/27/21.
//
//

import Foundation
import CoreData


extension MGComponent {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MGComponent> {
        return NSFetchRequest<MGComponent>(entityName: "MGComponent")
    }

    @NSManaged public var name: String?
    @NSManaged public var nameSection: String?
    @NSManaged public var componentParts: NSSet?

}

// MARK: Generated accessors for componentParts
extension MGComponent {

    @objc(addComponentPartsObject:)
    @NSManaged public func addToComponentParts(_ value: MGCardComponentPart)

    @objc(removeComponentPartsObject:)
    @NSManaged public func removeFromComponentParts(_ value: MGCardComponentPart)

    @objc(addComponentParts:)
    @NSManaged public func addToComponentParts(_ values: NSSet)

    @objc(removeComponentParts:)
    @NSManaged public func removeFromComponentParts(_ values: NSSet)

}
