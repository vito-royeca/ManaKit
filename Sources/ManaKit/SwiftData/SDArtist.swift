//
//  SDArtist.swift
//
//
//  Created by Vito Royeca on 2/8/24.
//

import SwiftData

@Model
public final class SDArtist: SDEntity {

    // MARK: - Properties

    public var firstName: String?
    public var lastName: String?
    public var name: String
    public var nameSection: String?
    public var info: String?
    
    // MARK: - Relationships

    public var cards: [SDCard]

    // MARK: - Initializers

    init(firstName: String? = nil,
         lastName: String? = nil,
         name: String,
         nameSection: String? = nil,
         info: String? = nil,
         cards: [SDCard] = []) {
        self.firstName = firstName
        self.lastName = lastName
        self.name = name
        self.nameSection = nameSection
        self.info = info
        self.cards = cards
    }
}
