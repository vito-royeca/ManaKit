//
//  CMUser.swift
//  Pods
//
//  Created by Jovito Royeca on 26/12/2018.
//
//

import Foundation
import RealmSwift


public class CMUser: Object {

    @objc public dynamic var avatarURL: String? = nil
    @objc public dynamic var displayName: String? = nil
    @objc public dynamic var id: String? = nil
    
    // MARK: Relationships
    public let decks = List<CMDeck>()
    public let favorites = LinkingObjects(fromType: CMCard.self, property: "firebaseUserFavorites")
    public let lists = List<CMList>()
    public let ratings = List<CMCardRating>()

    // MARK: Primary key
    override public static func primaryKey() -> String? {
        return "id"
    }

}

