//
//  CMBooster+CoreDataProperties.swift
//  Pods
//
//  Created by Jovito Royeca on 15/04/2017.
//
//

import Foundation
import CoreData


extension CMBooster {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CMBooster> {
        return NSFetchRequest<CMBooster>(entityName: "CMBooster")
    }

    @NSManaged public var name: String?
    @NSManaged public var setBoosters: NSSet?

}

// MARK: Generated accessors for setBoosters
extension CMBooster {

    @objc(addSetBoostersObject:)
    @NSManaged public func addToSetBoosters(_ value: CMSetBooster)

    @objc(removeSetBoostersObject:)
    @NSManaged public func removeFromSetBoosters(_ value: CMSetBooster)

    @objc(addSetBoosters:)
    @NSManaged public func addToSetBoosters(_ values: NSSet)

    @objc(removeSetBoosters:)
    @NSManaged public func removeFromSetBoosters(_ values: NSSet)

}
