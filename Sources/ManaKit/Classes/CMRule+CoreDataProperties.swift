//
//  CMRule+CoreDataProperties.swift
//  Pods
//
//  Created by Vito Royeca on 11/26/19.
//
//

import Foundation
import CoreData


extension CMRule {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CMRule> {
        return NSFetchRequest<CMRule>(entityName: "CMRule")
    }

    @NSManaged public var definition: String?
    @NSManaged public var order: Double
    @NSManaged public var term: String?
    @NSManaged public var termSection: String?
    @NSManaged public var children: NSSet?
    @NSManaged public var parent: CMRule?

}

// MARK: Generated accessors for children
extension CMRule {

    @objc(addChildrenObject:)
    @NSManaged public func addToChildren(_ value: CMRule)

    @objc(removeChildrenObject:)
    @NSManaged public func removeFromChildren(_ value: CMRule)

    @objc(addChildren:)
    @NSManaged public func addToChildren(_ values: NSSet)

    @objc(removeChildren:)
    @NSManaged public func removeFromChildren(_ values: NSSet)

}