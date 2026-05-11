//
//  MGFrameEffect+CoreDataProperties.swift
//  
//
//  Created by Vito Royeca on 12/27/21.
//
//

import Foundation
import CoreData


extension MGFrameEffect {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MGFrameEffect> {
        return NSFetchRequest<MGFrameEffect>(entityName: "MGFrameEffect")
    }

    @NSManaged public var description_: String?
    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var nameSection: String?
    @NSManaged public var cards: NSSet?

}

// MARK: Generated accessors for cards
extension MGFrameEffect {

    @objc(addCardsObject:)
    @NSManaged public func addToCards(_ value: MGCard)

    @objc(removeCardsObject:)
    @NSManaged public func removeFromCards(_ value: MGCard)

    @objc(addCards:)
    @NSManaged public func addToCards(_ values: NSSet)

    @objc(removeCards:)
    @NSManaged public func removeFromCards(_ values: NSSet)

}
