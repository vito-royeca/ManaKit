//
//  CMSetBlock+CoreDataProperties.swift
//  Pods
//
//  Created by Jovito Royeca on 10/11/2018.
//
//

import Foundation
import CoreData


extension CMSetBlock {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CMSetBlock> {
        return NSFetchRequest<CMSetBlock>(entityName: "CMSetBlock")
    }

    @NSManaged public var code: String?
    @NSManaged public var name: String?
    @NSManaged public var nameSection: String?
    @NSManaged public var sets: NSSet?

}

// MARK: Generated accessors for sets
extension CMSetBlock {

    @objc(addSetsObject:)
    @NSManaged public func addToSets(_ value: CMSet)

    @objc(removeSetsObject:)
    @NSManaged public func removeFromSets(_ value: CMSet)

    @objc(addSets:)
    @NSManaged public func addToSets(_ values: NSSet)

    @objc(removeSets:)
    @NSManaged public func removeFromSets(_ values: NSSet)

}
