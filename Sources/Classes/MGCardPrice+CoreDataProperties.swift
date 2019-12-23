//
//  MGCardPrice+CoreDataProperties.swift
//  Pods
//
//  Created by Vito Royeca on 12/23/19.
//
//

import Foundation
import CoreData

extension MGCardPrice {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MGCardPrice> {
        return NSFetchRequest<MGCardPrice>(entityName: "MGCardPrice")
    }

    @NSManaged public var low: Double
    @NSManaged public var median: Double
    @NSManaged public var high: Double
    @NSManaged public var directLow: Double
    @NSManaged public var market: Double
    @NSManaged public var dateUpdated: Date?
    @NSManaged public var condition: String?
    @NSManaged public var isFoil: Bool
    @NSManaged public var card: MGCard?
    @NSManaged public var store: MGStore?

}
