//
//  MGSearchResult+CoreDataProperties.swift
//
//
//  Created by Vito Royeca on 1/29/24.
//

import Foundation
import CoreData


extension MGSearchResult {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MGSearchResult> {
        return NSFetchRequest<MGSearchResult>(entityName: "MGSearchResult")
    }

    @NSManaged public var newID: String
    @NSManaged public var pageOffset: Int64
    @NSManaged public var url: String
}
