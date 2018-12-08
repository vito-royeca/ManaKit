//
//  CMCardFrameEffect+CoreDataProperties.swift
//  Pods
//
//  Created by Jovito Royeca on 07/12/2018.
//
//

import Foundation
import CoreData


extension CMCardFrameEffect {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CMCardFrameEffect> {
        return NSFetchRequest<CMCardFrameEffect>(entityName: "CMCardFrameEffect")
    }

    @NSManaged public var name: String?
    @NSManaged public var nameSection: String?
    @NSManaged public var cards: NSSet?

}

// MARK: Generated accessors for cards
extension CMCardFrameEffect {

    @objc(addCardsObject:)
    @NSManaged public func addToCards(_ value: CMCard)

    @objc(removeCardsObject:)
    @NSManaged public func removeFromCards(_ value: CMCard)

    @objc(addCards:)
    @NSManaged public func addToCards(_ values: NSSet)

    @objc(removeCards:)
    @NSManaged public func removeFromCards(_ values: NSSet)

}
