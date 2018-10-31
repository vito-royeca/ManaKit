//
//  CMCardWatermark+CoreDataProperties.swift
//  Pods
//
//  Created by Jovito Royeca on 30/10/2018.
//
//

import Foundation
import CoreData


extension CMCardWatermark {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CMCardWatermark> {
        return NSFetchRequest<CMCardWatermark>(entityName: "CMCardWatermark")
    }

    @NSManaged public var name: String?
    @NSManaged public var nameSection: String?
    @NSManaged public var cards: NSSet?

}

// MARK: Generated accessors for cards
extension CMCardWatermark {

    @objc(addCardsObject:)
    @NSManaged public func addToCards(_ value: CMCard)

    @objc(removeCardsObject:)
    @NSManaged public func removeFromCards(_ value: CMCard)

    @objc(addCards:)
    @NSManaged public func addToCards(_ values: NSSet)

    @objc(removeCards:)
    @NSManaged public func removeFromCards(_ values: NSSet)

}
