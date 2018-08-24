//
//  CMSystem+CoreDataProperties.swift
//  
//
//  Created by Jovito Royeca on 08/12/2017.
//
//

import Foundation
import CoreData


extension CMSystem {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<CMSystem> {
        return NSFetchRequest<CMSystem>(entityName: "CMSystem")
    }
    
    @NSManaged public var version: String?
    @NSManaged public var date: NSDate?
    @NSManaged public var description_: String?

}
