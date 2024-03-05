//
//  LocalSorter+CoreDataProperties.swift
//
//
//  Created by Vito Royeca on 3/2/24.
//

import Foundation
import CoreData


extension LocalSorter {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LocalSorter> {
        return NSFetchRequest<LocalSorter>(entityName: "LocalSorter")
    }

    @NSManaged public var id: UUID
    @NSManaged public var key: String
    @NSManaged public var isAscending: Bool
    @NSManaged public var localCache: LocalCache?

}
