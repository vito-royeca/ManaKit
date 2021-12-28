//
//  MGRuling+CoreDataProperties.swift
//  
//
//  Created by Vito Royeca on 12/27/21.
//
//

import Foundation
import CoreData


extension MGRuling {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MGRuling> {
        return NSFetchRequest<MGRuling>(entityName: "MGRuling")
    }

    @NSManaged public var datePublished: Date?
    @NSManaged public var id: String?
    @NSManaged public var oracleId: String?
    @NSManaged public var text: String?

}
