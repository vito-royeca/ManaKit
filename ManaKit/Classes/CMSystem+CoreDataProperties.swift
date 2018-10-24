//
//  CMSystem+CoreDataProperties.swift
//  Pods
//
//  Created by Jovito Royeca on 23/10/2018.
//
//

import Foundation
import CoreData


extension CMSystem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CMSystem> {
        return NSFetchRequest<CMSystem>(entityName: "CMSystem")
    }

    @NSManaged public var date: NSDate?
    @NSManaged public var description_: String?
    @NSManaged public var version: String?

}
