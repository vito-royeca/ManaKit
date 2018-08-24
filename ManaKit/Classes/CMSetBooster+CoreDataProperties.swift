//
//  CMSetBooster+CoreDataProperties.swift
//  Pods
//
//  Created by Jovito Royeca on 15/04/2017.
//
//

import Foundation
import CoreData


extension CMSetBooster {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CMSetBooster> {
        return NSFetchRequest<CMSetBooster>(entityName: "CMSetBooster")
    }

    @NSManaged public var count: Int32
    @NSManaged public var id: Int64
    @NSManaged public var booster: CMBooster?
    @NSManaged public var set: CMSet?

}
