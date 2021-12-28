//
//  MGStore+CoreDataProperties.swift
//  
//
//  Created by Vito Royeca on 12/27/21.
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
    @NSManaged public var prices: NSSet?

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
