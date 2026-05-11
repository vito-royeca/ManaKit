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
    @NSManaged public var pageCount: Int32
    @NSManaged public var pageNumber: Int32
    @NSManaged public var url: String
    @NSManaged public var queries: NSSet?
    @NSManaged public var sorters: NSSet?

}

// MARK: Generated accessors for queries
extension LocalCache {

    @objc(addQueriesObject:)
    @NSManaged public func addToQueries(_ value: LocalQuery)

    @objc(removeQueriesObject:)
    @NSManaged public func removeFromQueries(_ value: LocalQuery)

    @objc(addQueries:)
    @NSManaged public func addToQueries(_ values: NSSet)

    @objc(removeQueries:)
    @NSManaged public func removeFromQueries(_ values: NSSet)

}

// MARK: Generated accessors for sorters
extension LocalCache {

    @objc(addSortersObject:)
    @NSManaged public func addToSorters(_ value: LocalSorter)

    @objc(removeSortersObject:)
    @NSManaged public func removeFromSorters(_ value: LocalSorter)

    @objc(addSorters:)
    @NSManaged public func addToSorters(_ values: NSSet)

    @objc(removeSorters:)
    @NSManaged public func removeFromSorters(_ values: NSSet)

}
