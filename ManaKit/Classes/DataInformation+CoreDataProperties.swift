//
//  DataInformation+CoreDataProperties.swift
//  Pods
//
//  Created by Vito Royeca on 11/27/19.
//
//

import Foundation
import CoreData


extension DataInformation {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DataInformation> {
        return NSFetchRequest<DataInformation>(entityName: "DataInformation")
    }

    @NSManaged public var name: String?
    @NSManaged public var query: String?
    @NSManaged public var dateUpdated: Date?

}
