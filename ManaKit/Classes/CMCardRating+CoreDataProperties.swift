//
//  CMCardRating+CoreDataProperties.swift
//  Pods
//
//  Created by Jovito Royeca on 05/11/2018.
//
//

import Foundation
import CoreData


extension CMCardRating {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CMCardRating> {
        return NSFetchRequest<CMCardRating>(entityName: "CMCardRating")
    }

    @NSManaged public var rating: Double
    @NSManaged public var card: CMCard?
    @NSManaged public var user: CMUser?

}
