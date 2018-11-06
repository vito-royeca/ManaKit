//
//  CMStorePricing+CoreDataProperties.swift
//  Pods
//
//  Created by Jovito Royeca on 05/11/2018.
//
//

import Foundation
import CoreData


extension CMStorePricing {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CMStorePricing> {
        return NSFetchRequest<CMStorePricing>(entityName: "CMStorePricing")
    }

    @NSManaged public var id: String?
    @NSManaged public var lastUpdate: NSDate?
    @NSManaged public var notes: String?
    @NSManaged public var cards: NSSet?
    @NSManaged public var suppliers: NSSet?

}

// MARK: Generated accessors for cards
extension CMStorePricing {

    @objc(addCardsObject:)
    @NSManaged public func addToCards(_ value: CMCard)

    @objc(removeCardsObject:)
    @NSManaged public func removeFromCards(_ value: CMCard)

    @objc(addCards:)
    @NSManaged public func addToCards(_ values: NSSet)

    @objc(removeCards:)
    @NSManaged public func removeFromCards(_ values: NSSet)

}

// MARK: Generated accessors for suppliers
extension CMStorePricing {

    @objc(addSuppliersObject:)
    @NSManaged public func addToSuppliers(_ value: CMStoreSupplier)

    @objc(removeSuppliersObject:)
    @NSManaged public func removeFromSuppliers(_ value: CMStoreSupplier)

    @objc(addSuppliers:)
    @NSManaged public func addToSuppliers(_ values: NSSet)

    @objc(removeSuppliers:)
    @NSManaged public func removeFromSuppliers(_ values: NSSet)

}
