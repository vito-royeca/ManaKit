//
//  CMCardArtist+CoreDataProperties.swift
//  Pods
//
//  Created by Jovito Royeca on 05/11/2018.
//
//

import Foundation
import CoreData


extension CMCardArtist {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CMCardArtist> {
        return NSFetchRequest<CMCardArtist>(entityName: "CMCardArtist")
    }

    @NSManaged public var firstName: String?
    @NSManaged public var lastName: String?
    @NSManaged public var name: String?
    @NSManaged public var nameSection: String?
    @NSManaged public var cards: NSSet?

}

// MARK: Generated accessors for cards
extension CMCardArtist {

    @objc(addCardsObject:)
    @NSManaged public func addToCards(_ value: CMCard)

    @objc(removeCardsObject:)
    @NSManaged public func removeFromCards(_ value: CMCard)

    @objc(addCards:)
    @NSManaged public func addToCards(_ values: NSSet)

    @objc(removeCards:)
    @NSManaged public func removeFromCards(_ values: NSSet)

}
