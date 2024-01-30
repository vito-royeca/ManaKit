//
//  LocalCache+CoreDataProperties.swift
//  
//
//  Created by Vito Royeca on 12/27/21.
//
//

import Foundation
import CoreData


extension LocalCache {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LocalCache> {
        return NSFetchRequest<LocalCache>(entityName: "LocalCache")
    }

    @NSManaged public var lastUpdated: Date?
    @NSManaged public var url: String

}
