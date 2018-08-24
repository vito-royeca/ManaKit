//
//  CMCardPricing+CoreDataProperties.swift
//  
//
//  Created by Jovito Royeca on 04/11/2017.
//
//

import Foundation
import CoreData


extension CMCardPricing {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CMCardPricing> {
        return NSFetchRequest<CMCardPricing>(entityName: "CMCardPricing")
    }
    
    @NSManaged public var id: Int64
    @NSManaged public var low: Double
    @NSManaged public var average: Double
    @NSManaged public var high: Double
    @NSManaged public var foil: Double
    @NSManaged public var lastUpdate: NSDate?
    @NSManaged public var link: String?
    @NSManaged public var cards: NSSet?
    
}

// MARK: Generated accessors for cards
extension CMCardPricing {
    
    @objc(addCardsObject:)
    @NSManaged public func addToCards(_ value: CMCard)
    
    @objc(removeCardsObject:)
    @NSManaged public func removeFromCards(_ value: CMCard)
    
    @objc(addCards:)
    @NSManaged public func addToCards(_ values: NSSet)
    
    @objc(removeCards:)
    @NSManaged public func removeFromCards(_ values: NSSet)
    
}
