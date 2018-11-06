//
//  CMCardRuling+CoreDataProperties.swift
//  Pods
//
//  Created by Jovito Royeca on 05/11/2018.
//
//

import Foundation
import CoreData


extension CMCardRuling {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CMCardRuling> {
        return NSFetchRequest<CMCardRuling>(entityName: "CMCardRuling")
    }

    @NSManaged public var date: String?
    @NSManaged public var text: String?
    @NSManaged public var card: CMCard?

}
