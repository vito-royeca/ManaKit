//
//  MGSet+CoreDataProperties.swift
//  
//
//  Created by Vito Royeca on 01/08/22.
//
//

import Foundation

public struct MSet {

    public var cardCount: Int32
    public var code: String
    public var isFoilOnly: Bool
    public var isOnlineOnly: Bool
    public var keyruneClass: String?
    public var keyruneUnicode: String?
    public var mtgoCode: String?
    public var myNameSection: String?
    public var myYearSection: String?
    public var name: String?
    public var releaseDate: String?
    public var tcgPlayerId: Int32
//    public var cards: [MCard]
    public var children: [MSet]
    public var languages: [MLanguage]
//    public var parent: MSet?
    public var setBlock: MSetBlock?
    public var setType: MSetType?

}

// MARK: - Identifiable

extension MSet: MEntity {
    public var id: String {
        return code
    }
}


