//
//  MGSetBlock+CoreDataProperties.swift
//  Pods
//
//  Created by Vito Royeca on 12/14/19.
//
//

import Foundation
import CoreData


extension MGSetBlock {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MGSetBlock> {
        return NSFetchRequest<MGSetBlock>(entityName: "MGSetBlock")
    }

    @NSManaged public var code: String?
    @NSManaged public var name: String?
    @NSManaged public var nameSection: String?
    @NSManaged public var sets: NSSet?

}

// MARK: Generated accessors for sets
extension MGSetBlock {

    @objc(addSetsObject:)
    @NSManaged public func addToSets(_ value: MGSet)

    @objc(removeSetsObject:)
    @NSManaged public func removeFromSets(_ value: MGSet)

    @objc(addSets:)
    @NSManaged public func addToSets(_ values: NSSet)

    @objc(removeSets:)
    @NSManaged public func removeFromSets(_ values: NSSet)

}
