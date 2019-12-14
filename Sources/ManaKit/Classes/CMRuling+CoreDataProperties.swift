//
//  CMRuling+CoreDataProperties.swift
//  Pods
//
//  Created by Vito Royeca on 11/26/19.
//
//

import Foundation
import CoreData


extension CMRuling {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CMRuling> {
        return NSFetchRequest<CMRuling>(entityName: "CMRuling")
    }

    @NSManaged public var datePublished: Date?
    @NSManaged public var text: String?
    @NSManaged public var oracleId: String?

}
