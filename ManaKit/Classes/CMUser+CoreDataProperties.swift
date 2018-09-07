//
//  CMUser+CoreDataProperties.swift
//  ManaKit
//
//  Created by Jovito Royeca on 23.08.18.
//
//

import Foundation
import CoreData


extension CMUser {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CMUser> {
        return NSFetchRequest<CMUser>(entityName: "CMUser")
    }

    @NSManaged public var avatarURL: String?
    @NSManaged public var displayName: String?
    @NSManaged public var id: String?
    @NSManaged public var decks: NSSet?
    @NSManaged public var favorites: NSSet?
    @NSManaged public var ratings: NSSet?
    @NSManaged public var lists: NSSet?

}

// MARK: Generated accessors for decks
extension CMUser {

    @objc(addDecksObject:)
    @NSManaged public func addToDecks(_ value: CMDeck)

    @objc(removeDecksObject:)
    @NSManaged public func removeFromDecks(_ value: CMDeck)

    @objc(addDecks:)
    @NSManaged public func addToDecks(_ values: NSSet)

    @objc(removeDecks:)
    @NSManaged public func removeFromDecks(_ values: NSSet)

}

// MARK: Generated accessors for favorites
extension CMUser {

    @objc(addFavoritesObject:)
    @NSManaged public func addToFavorites(_ value: CMCard)

    @objc(removeFavoritesObject:)
    @NSManaged public func removeFromFavorites(_ value: CMCard)

    @objc(addFavorites:)
    @NSManaged public func addToFavorites(_ values: NSSet)

    @objc(removeFavorites:)
    @NSManaged public func removeFromFavorites(_ values: NSSet)

}

// MARK: Generated accessors for favorites
extension CMUser {
    
    @objc(addRatingsObject:)
    @NSManaged public func addToRatings(_ value: CMCardRating)
    
    @objc(removeRatingsObject:)
    @NSManaged public func removeFromRatings(_ value: CMCardRating)
    
    @objc(addRatings:)
    @NSManaged public func addToRatings(_ values: NSSet)
    
    @objc(removeRatings:)
    @NSManaged public func removeFromRatings(_ values: NSSet)
    
}

// MARK: Generated accessors for lists
extension CMUser {

    @objc(addListsObject:)
    @NSManaged public func addToLists(_ value: CMList)

    @objc(removeListsObject:)
    @NSManaged public func removeFromLists(_ value: CMList)

    @objc(addLists:)
    @NSManaged public func addToLists(_ values: NSSet)

    @objc(removeLists:)
    @NSManaged public func removeFromLists(_ values: NSSet)

}
