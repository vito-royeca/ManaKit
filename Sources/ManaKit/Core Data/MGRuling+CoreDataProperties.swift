//
//  MGRuling+CoreDataProperties.swift
//  
//
//  Created by Vito Royeca on 12/27/21.
//
//

import Foundation
import CoreData


extension MGRuling {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MGRuling> {
        return NSFetchRequest<MGRuling>(entityName: "MGRuling")
    }

    @NSManaged public var datePublished: String?
    @NSManaged public var id: String?
    @NSManaged public var oracleId: String?
    @NSManaged public var text: String?
    @NSManaged public var cards: NSSet?

}

// MARK: Generated accessors for cards
extension MGRuling {

    @objc(addCardsObject:)
    @NSManaged public func addToCards(_ value: MGCard)

    @objc(removeCardsObject:)
    @NSManaged public func removeFromCards(_ value: MGCard)

    @objc(addCards:)
    @NSManaged public func addToCards(_ values: NSSet)

    @objc(removeCards:)
    @NSManaged public func removeFromCards(_ values: NSSet)

}
