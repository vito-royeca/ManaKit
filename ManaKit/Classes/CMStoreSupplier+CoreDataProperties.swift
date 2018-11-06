//
//  CMStoreSupplier+CoreDataProperties.swift
//  Pods
//
//  Created by Jovito Royeca on 05/11/2018.
//
//

import Foundation
import CoreData


extension CMStoreSupplier {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CMStoreSupplier> {
        return NSFetchRequest<CMStoreSupplier>(entityName: "CMStoreSupplier")
    }

    @NSManaged public var condition: String?
    @NSManaged public var id: String?
    @NSManaged public var link: String?
    @NSManaged public var name: String?
    @NSManaged public var price: Double
    @NSManaged public var qty: Int32
    @NSManaged public var storePricing: CMStorePricing?

}
