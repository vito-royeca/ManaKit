//
//  LocalQuery+CoreDataProperties.swift
//
//
//  Created by Vito Royeca on 3/2/24.
//

import Foundation
import CoreData


extension LocalQuery {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LocalQuery> {
        return NSFetchRequest<LocalQuery>(entityName: "LocalQuery")
    }

    @NSManaged public var id: UUID
    @NSManaged public var key: String
    @NSManaged public var value: String
    @NSManaged public var localCache: LocalCache?

}
