//
//  MGWatermark+CoreDataProperties.swift
//  
//
//  Created by Vito Royeca on 12/27/21.
//
//

import Foundation
import CoreData


extension MGWatermark {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MGWatermark> {
        return NSFetchRequest<MGWatermark>(entityName: "MGWatermark")
    }

    @NSManaged public var name: String?
    @NSManaged public var nameSection: String?
    @NSManaged public var cards: NSSet?

}

// MARK: Generated accessors for cards
extension MGWatermark {

    @objc(addCardsObject:)
    @NSManaged public func addToCards(_ value: MGCard)

    @objc(removeCardsObject:)
    @NSManaged public func removeFromCards(_ value: MGCard)

    @objc(addCards:)
    @NSManaged public func addToCards(_ values: NSSet)

    @objc(removeCards:)
    @NSManaged public func removeFromCards(_ values: NSSet)

}
