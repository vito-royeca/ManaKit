//
//  DataCache+CoreDataProperties.swift
//  Pods
//
//  Created by Vito Royeca on 11/30/19.
//
//

import Foundation
import CoreData


extension DataCache {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DataCache> {
        return NSFetchRequest<DataCache>(entityName: "DataCache")
    }

    @NSManaged public var dateUpdated: Date?
    @NSManaged public var name: String?
    @NSManaged public var objectFinder: Data?
    @NSManaged public var query: String?

}
