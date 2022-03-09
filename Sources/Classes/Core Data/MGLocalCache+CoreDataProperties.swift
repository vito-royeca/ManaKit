//
//  MGLocalCache+CoreDataProperties.swift
//  
//
//  Created by Vito Royeca on 12/27/21.
//
//

import Foundation
import CoreData


extension MGLocalCache {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MGLocalCache> {
        return NSFetchRequest<MGLocalCache>(entityName: "MGLocalCache")
    }

    @NSManaged public var lastUpdated: Date?
    @NSManaged public var url: String

}
