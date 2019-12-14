//
//  LocalCache+CoreDataProperties.swift
//  Pods
//
//  Created by Vito Royeca on 12/7/19.
//
//

import Foundation
import CoreData


extension LocalCache {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LocalCache> {
        return NSFetchRequest<LocalCache>(entityName: "LocalCache")
    }

    @NSManaged public var dateUpdated: Date?
    @NSManaged public var name: String?
    @NSManaged public var objectFinder: Data?
    @NSManaged public var query: String?

}
