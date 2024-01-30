//
//  SearchResult+CoreDataProperties.swift
//
//
//  Created by Vito Royeca on 1/29/24.
//

import Foundation
import CoreData


extension SearchResult {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SearchResult> {
        return NSFetchRequest<SearchResult>(entityName: "SearchResult")
    }

    @NSManaged public var newID: String
    @NSManaged public var pageOffset: Int64

}
