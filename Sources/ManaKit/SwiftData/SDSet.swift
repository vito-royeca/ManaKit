//
//  SDSet.swift
//
//
//  Created by Vito Royeca on 2/8/24.
//

import Foundation
import SwiftData

@Model
public class SDSet {
    // MARK: - Properties

    public var cardCount: Int32

    @Attribute(.unique)
    public var code: String

    public var isFoilOnly: Bool
    public var isOnlineOnly: Bool
    public var keyruneClass: String?
    public var keyruneUnicode: String?
    public var logoCode: String?
    public var mtgoCode: String?
    public var nameSection: String?
    public var yearSection: String?
    public var name: String
    public var releaseDate: Date?
    public var tcgPlayerID: Int32

    // MARK: - Relationships

    @Relationship(deleteRule: .cascade, inverse: \SDCard.set)
    public var cards: [SDCard]
    
    @Relationship(deleteRule: .cascade, inverse: \SDSet.parent)
    public var children: [SDSet]
    public var parent: SDSet?

    @Relationship(inverse: \SDLanguage.sets)
    public var languages: [SDLanguage]

    public var setBlock: SDSetBlock?
    public var setType: SDSetType?
    
    init(cardCount: Int32,
         code: String,
         isFoilOnly: Bool,
         isOnlineOnly: Bool,
         keyruneClass: String? = nil,
         keyruneUnicode: String? = nil,
         logoCode: String? = nil,
         mtgoCode: String? = nil,
         nameSection: String? = nil,
         yearSection: String? = nil,
         name: String,
         releaseDate: Date? = nil,
         tcgPlayerID: Int32,
         cards: [SDCard],
         children: [SDSet],
         parent: SDSet? = nil,
         languages: [SDLanguage],
         setBlock: SDSetBlock? = nil,
         setType: SDSetType? = nil) {
        self.cardCount = cardCount
        self.code = code
        self.isFoilOnly = isFoilOnly
        self.isOnlineOnly = isOnlineOnly
        self.keyruneClass = keyruneClass
        self.keyruneUnicode = keyruneUnicode
        self.logoCode = logoCode
        self.mtgoCode = mtgoCode
        self.nameSection = nameSection
        self.yearSection = yearSection
        self.name = name
        self.releaseDate = releaseDate
        self.tcgPlayerID = tcgPlayerID
        self.cards = cards
        self.children = children
        self.parent = parent
        self.languages = languages
        self.setBlock = setBlock
        self.setType = setType
    }
}
