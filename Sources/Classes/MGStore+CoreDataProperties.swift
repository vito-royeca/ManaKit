//
//  MGStore+CoreDataProperties.swift
//  Pods
//
//  Created by Vito Royeca on 12/14/19.
//
//

import Foundation
import CoreData


extension MGStore {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MGStore> {
        return NSFetchRequest<MGStore>(entityName: "MGStore")
    }

    @NSManaged public var name: String?
    @NSManaged public var nameSection: String?

}

// MARK: Generated accessors for prices
extension MGStore {

    @objc(addPricesObject:)
    @NSManaged public func addToPrices(_ value: MGCardPrice)

    @objc(removePricesObject:)
    @NSManaged public func removeFromPrices(_ value: MGCardPrice)

    @objc(addPrices:)
    @NSManaged public func addToPrices(_ values: NSSet)

    @objc(removePrices:)
    @NSManaged public func removeFromPrices(_ values: NSSet)

}
