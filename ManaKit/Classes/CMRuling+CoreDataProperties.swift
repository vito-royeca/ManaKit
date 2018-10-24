//
//  CMRuling+CoreDataProperties.swift
//  Pods
//
//  Created by Jovito Royeca on 23/10/2018.
//
//

import Foundation
import CoreData


extension CMRuling {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CMRuling> {
        return NSFetchRequest<CMRuling>(entityName: "CMRuling")
    }

    @NSManaged public var date: String?
    @NSManaged public var id: Int64
    @NSManaged public var text: String?
    @NSManaged public var card: CMCard?

}
