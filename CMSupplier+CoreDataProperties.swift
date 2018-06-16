//
//  CMSupplier+CoreDataProperties.swift
//  Pods
//
//  Created by Jovito Royeca on 16/06/2018.
//
//

import Foundation
import CoreData


extension CMSupplier {

    @nonobjc open override class func fetchRequest() -> NSFetchRequest<NSFetchRequestResult> {
        return NSFetchRequest<CMSupplier>(entityName: "CMSupplier") as! NSFetchRequest<NSFetchRequestResult>
    }

    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var condition: String?
    @NSManaged public var qty: Int32
    @NSManaged public var price: Double
    @NSManaged public var link: String?
    @NSManaged public var card: CMCard?

}
