//
//  SDLanguage.swift
//
//
//  Created by Vito Royeca on 2/8/24.
//

import SwiftData

@Model
public class SDLanguage {
    // MARK: - Properties
    
    @Attribute(.unique)
    public var code: String

    public var displayCode: String?
    public var name: String
    public var nameSection: String?
    
    // MARK: - Relationships

    @Relationship(deleteRule: .cascade, inverse: \SDCard.set)
    public var cards: [SDCard]

    public var cardOtherLanguagess: [SDCard]
    public var sets: [SDSet]

    // MARK: - Initializers

    init(code: String,
         displayCode: String? = nil,
         name: String,
         nameSection: String? = nil,
         cards: [SDCard],
         cardOtherLanguagess: [SDCard],
         sets: [SDSet]) {
        self.code = code
        self.displayCode = displayCode
        self.name = name
        self.nameSection = nameSection
        self.cards = cards
        self.cardOtherLanguagess = cardOtherLanguagess
        self.sets = sets
    }
}
