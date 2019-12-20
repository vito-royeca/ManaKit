//
//  MGCardType+CoreDataProperties.swift
//  Pods
//
//  Created by Vito Royeca on 12/14/19.
//
//

import Foundation
import CoreData


extension MGCardType {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MGCardType> {
        return NSFetchRequest<MGCardType>(entityName: "MGCardType")
    }

    @NSManaged public var name: String?
    @NSManaged public var nameSection: String?
    @NSManaged public var children: MGCardType?
    @NSManaged public var parent: NSSet?
    @NSManaged public var subtypes: NSSet?
    @NSManaged public var supertypes: MGCard?

}

// MARK: Generated accessors for parent
extension MGCardType {

    @objc(addParentObject:)
    @NSManaged public func addToParent(_ value: MGCardType)

    @objc(removeParentObject:)
    @NSManaged public func removeFromParent(_ value: MGCardType)

    @objc(addParent:)
    @NSManaged public func addToParent(_ values: NSSet)

    @objc(removeParent:)
    @NSManaged public func removeFromParent(_ values: NSSet)

}

// MARK: Generated accessors for subtypes
extension MGCardType {

    @objc(addSubtypesObject:)
    @NSManaged public func addToSubtypes(_ value: MGCard)

    @objc(removeSubtypesObject:)
    @NSManaged public func removeFromSubtypes(_ value: MGCard)

    @objc(addSubtypes:)
    @NSManaged public func addToSubtypes(_ values: NSSet)

    @objc(removeSubtypes:)
    @NSManaged public func removeFromSubtypes(_ values: NSSet)

}
