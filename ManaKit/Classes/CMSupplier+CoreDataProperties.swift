//
//  CMSupplier+CoreDataProperties.swift
//  Pods
//
//  Created by Jovito Royeca on 23/10/2018.
//
//

import Foundation
import CoreData


extension CMSupplier {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CMSupplier> {
        return NSFetchRequest<CMSupplier>(entityName: "CMSupplier")
    }

    @NSManaged public var condition: String?
    @NSManaged public var id: String?
    @NSManaged public var link: String?
    @NSManaged public var name: String?
    @NSManaged public var price: Double
    @NSManaged public var qty: Int32
    @NSManaged public var storePricing: CMStorePricing?

}
