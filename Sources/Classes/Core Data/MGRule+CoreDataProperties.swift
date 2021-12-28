//
//  MGRule+CoreDataProperties.swift
//  
//
//  Created by Vito Royeca on 12/27/21.
//
//

import Foundation
import CoreData


extension MGRule {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MGRule> {
        return NSFetchRequest<MGRule>(entityName: "MGRule")
    }

    @NSManaged public var definition: String?
    @NSManaged public var id: String?
    @NSManaged public var order: Double
    @NSManaged public var term: String?
    @NSManaged public var termSection: String?
    @NSManaged public var children: NSSet?
    @NSManaged public var parent: MGRule?

}

// MARK: Generated accessors for children
extension MGRule {

    @objc(addChildrenObject:)
    @NSManaged public func addToChildren(_ value: MGRule)

    @objc(removeChildrenObject:)
    @NSManaged public func removeFromChildren(_ value: MGRule)

    @objc(addChildren:)
    @NSManaged public func addToChildren(_ values: NSSet)

    @objc(removeChildren:)
    @NSManaged public func removeFromChildren(_ values: NSSet)

}
