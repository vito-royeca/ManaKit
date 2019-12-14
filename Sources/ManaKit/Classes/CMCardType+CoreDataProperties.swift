//
//  CMCardType+CoreDataProperties.swift
//  Pods
//
//  Created by Vito Royeca on 11/26/19.
//
//

import Foundation
import CoreData


extension CMCardType {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CMCardType> {
        return NSFetchRequest<CMCardType>(entityName: "CMCardType")
    }

    @NSManaged public var name: String?
    @NSManaged public var nameSection: String?
    @NSManaged public var parent: NSSet?
    @NSManaged public var children: CMCardType?
    @NSManaged public var subtypes: NSSet?
    @NSManaged public var supertypes: CMCard?

}

// MARK: Generated accessors for parent
extension CMCardType {

    @objc(addParentObject:)
    @NSManaged public func addToParent(_ value: CMCardType)

    @objc(removeParentObject:)
    @NSManaged public func removeFromParent(_ value: CMCardType)

    @objc(addParent:)
    @NSManaged public func addToParent(_ values: NSSet)

    @objc(removeParent:)
    @NSManaged public func removeFromParent(_ values: NSSet)

}

// MARK: Generated accessors for subtypes
extension CMCardType {

    @objc(addSubtypesObject:)
    @NSManaged public func addToSubtypes(_ value: CMCard)

    @objc(removeSubtypesObject:)
    @NSManaged public func removeFromSubtypes(_ value: CMCard)

    @objc(addSubtypes:)
    @NSManaged public func addToSubtypes(_ values: NSSet)

    @objc(removeSubtypes:)
    @NSManaged public func removeFromSubtypes(_ values: NSSet)

}
