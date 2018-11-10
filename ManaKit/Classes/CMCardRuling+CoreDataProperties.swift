//
//  CMCardRuling+CoreDataProperties.swift
//  Pods
//
//  Created by Jovito Royeca on 10/11/2018.
//
//

import Foundation
import CoreData


extension CMCardRuling {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CMCardRuling> {
        return NSFetchRequest<CMCardRuling>(entityName: "CMCardRuling")
    }

    @NSManaged public var card: CMCard?
    @NSManaged public var ruling: CMRuling?

}
