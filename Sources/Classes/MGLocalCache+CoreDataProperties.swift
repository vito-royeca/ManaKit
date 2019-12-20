//
//  MGLocalCache+CoreDataProperties.swift
//  Pods
//
//  Created by Vito Royeca on 12/14/19.
//
//

import Foundation
import CoreData


extension MGLocalCache {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MGLocalCache> {
        return NSFetchRequest<MGLocalCache>(entityName: "MGLocalCache")
    }

    @NSManaged public var dateUpdated: Date?
    @NSManaged public var name: String?
    @NSManaged public var objectFinder: Data?
    @NSManaged public var query: String?

}
