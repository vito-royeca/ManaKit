//
//  MGCardType+CoreDataProperties.swift
//  
//
//  Created by Vito Royeca on 12/27/21.
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
    @NSManaged public var children: NSSet?
    @NSManaged public var parent: MGCardType?
    @NSManaged public var subtypes: NSSet?
    @NSManaged public var supertypes: NSSet?

}

// MARK: Generated accessors for children
extension MGCardType {

    @objc(addChildrenObject:)
    @NSManaged public func addToChildren(_ value: MGCardType)

    @objc(removeChildrenObject:)
    @NSManaged public func removeFromChildren(_ value: MGCardType)

    @objc(addChildren:)
    @NSManaged public func addToChildren(_ values: NSSet)

    @objc(removeChildren:)
    @NSManaged public func removeFromChildren(_ values: NSSet)

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

// MARK: Generated accessors for supertypes
extension MGCardType {

    @objc(addSupertypesObject:)
    @NSManaged public func addToSupertypes(_ value: MGCard)

    @objc(removeSupertypesObject:)
    @NSManaged public func removeFromSupertypes(_ value: MGCard)

    @objc(addSupertypes:)
    @NSManaged public func addToSupertypes(_ values: NSSet)

    @objc(removeSupertypes:)
    @NSManaged public func removeFromSupertypes(_ values: NSSet)

}
