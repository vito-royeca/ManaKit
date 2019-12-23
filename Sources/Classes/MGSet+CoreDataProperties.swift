//
//  MGSet+CoreDataProperties.swift
//  Pods
//
//  Created by Vito Royeca on 12/14/19.
//
//

import Foundation
import CoreData


extension MGSet {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MGSet> {
        return NSFetchRequest<MGSet>(entityName: "MGSet")
    }

    @NSManaged public var cardCount: Int32
    @NSManaged public var code: String?
    @NSManaged public var dateCreated: Date?
    @NSManaged public var dateUpdated: Date?
    @NSManaged public var isFoilOnly: Bool
    @NSManaged public var isOnlineOnly: Bool
    @NSManaged public var mtgoCode: String?
    @NSManaged public var myKeyruneCode: String?
    @NSManaged public var myNameSection: String?
    @NSManaged public var myYearSection: String?
    @NSManaged public var name: String?
    @NSManaged public var releaseDate: String?
    @NSManaged public var tcgplayerId: Int32
    @NSManaged public var cards: NSSet?
    @NSManaged public var children: NSSet?
    @NSManaged public var languages: NSSet?
    @NSManaged public var parent: MGSet?
    @NSManaged public var setBlock: MGSetBlock?
    @NSManaged public var setType: MGSetType?

}

// MARK: Generated accessors for cards
extension MGSet {

    @objc(addCardsObject:)
    @NSManaged public func addToCards(_ value: MGCard)

    @objc(removeCardsObject:)
    @NSManaged public func removeFromCards(_ value: MGCard)

    @objc(addCards:)
    @NSManaged public func addToCards(_ values: NSSet)

    @objc(removeCards:)
    @NSManaged public func removeFromCards(_ values: NSSet)

}

// MARK: Generated accessors for children
extension MGSet {

    @objc(addChildrenObject:)
    @NSManaged public func addToChildren(_ value: MGSet)

    @objc(removeChildrenObject:)
    @NSManaged public func removeFromChildren(_ value: MGSet)

    @objc(addChildren:)
    @NSManaged public func addToChildren(_ values: NSSet)

    @objc(removeChildren:)
    @NSManaged public func removeFromChildren(_ values: NSSet)

}

// MARK: Generated accessors for languages
extension MGSet {

    @objc(addLanguagesObject:)
    @NSManaged public func addToLanguages(_ value: MGLanguage)

    @objc(removeLanguagesObject:)
    @NSManaged public func removeFromLanguages(_ value: MGLanguage)

    @objc(addLanguages:)
    @NSManaged public func addToLanguages(_ values: NSSet)

    @objc(removeLanguages:)
    @NSManaged public func removeFromLanguages(_ values: NSSet)

}
