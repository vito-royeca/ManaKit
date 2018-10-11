//
//  CMList+CoreDataProperties.swift
//  ManaKit
//
//  Created by Jovito Royeca on 23.08.18.
//
//

import Foundation
import CoreData


extension CMList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CMList> {
        return NSFetchRequest<CMList>(entityName: "CMList")
    }

    @NSManaged public var createdOn: NSDate?
    @NSManaged public var description_: String?
    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var nameSection: String?
    @NSManaged public var query: Data?
    @NSManaged public var updatedOn: NSDate?
    @NSManaged public var pricing: CMCardPricing?
    @NSManaged public var user: CMUser?

}

// MARK: Generated accessors for cards
extension CMList {

}
