//
//  CMRule+CoreDataProperties.swift
//  
//
//  Created by Jovito Royeca on 06/08/2017.
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
    @NSManaged public var parent: CMRule?
    @NSManaged public var children: NSSet?

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
