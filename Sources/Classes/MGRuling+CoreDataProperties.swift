//
//  MGRuling+CoreDataProperties.swift
//  Pods
//
//  Created by Vito Royeca on 12/14/19.
//
//

import Foundation
import CoreData


extension MGRuling {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MGRuling> {
        return NSFetchRequest<MGRuling>(entityName: "MGRuling")
    }

    @NSManaged public var id: Int32
    @NSManaged public var datePublished: Date?
    @NSManaged public var oracleId: String?
    @NSManaged public var text: String?

}
