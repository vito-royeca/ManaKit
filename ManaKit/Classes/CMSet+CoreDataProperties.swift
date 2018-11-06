//
//  CMSet+CoreDataProperties.swift
//  Pods
//
//  Created by Jovito Royeca on 05/11/2018.
//
//

import Foundation
import CoreData


extension CMSet {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CMSet> {
        return NSFetchRequest<CMSet>(entityName: "CMSet")
    }

    @NSManaged public var cardCount: Int32
    @NSManaged public var code: String?
    @NSManaged public var isFoilOnly: Bool
    @NSManaged public var isOnlineOnly: Bool
    @NSManaged public var mtgoCode: String?
    @NSManaged public var myKeyruneCode: String?
    @NSManaged public var myNameSection: String?
    @NSManaged public var myYearSection: String?
    @NSManaged public var name: String?
    @NSManaged public var releaseDate: String?
    @NSManaged public var tcgplayerName: String?
    @NSManaged public var block: CMSetBlock?
    @NSManaged public var cards: NSSet?
    @NSManaged public var children: NSSet?
    @NSManaged public var languages: NSSet?
    @NSManaged public var parent: CMSet?
    @NSManaged public var setType: CMSetType?

}

// MARK: Generated accessors for cards
extension CMSet {

    @objc(addCardsObject:)
    @NSManaged public func addToCards(_ value: CMCard)

    @objc(removeCardsObject:)
    @NSManaged public func removeFromCards(_ value: CMCard)

    @objc(addCards:)
    @NSManaged public func addToCards(_ values: NSSet)

    @objc(removeCards:)
    @NSManaged public func removeFromCards(_ values: NSSet)

}

// MARK: Generated accessors for children
extension CMSet {

    @objc(addChildrenObject:)
    @NSManaged public func addToChildren(_ value: CMSet)

    @objc(removeChildrenObject:)
    @NSManaged public func removeFromChildren(_ value: CMSet)

    @objc(addChildren:)
    @NSManaged public func addToChildren(_ values: NSSet)

    @objc(removeChildren:)
    @NSManaged public func removeFromChildren(_ values: NSSet)

}

// MARK: Generated accessors for languages
extension CMSet {

    @objc(addLanguagesObject:)
    @NSManaged public func addToLanguages(_ value: CMLanguage)

    @objc(removeLanguagesObject:)
    @NSManaged public func removeFromLanguages(_ value: CMLanguage)

    @objc(addLanguages:)
    @NSManaged public func addToLanguages(_ values: NSSet)

    @objc(removeLanguages:)
    @NSManaged public func removeFromLanguages(_ values: NSSet)

}
