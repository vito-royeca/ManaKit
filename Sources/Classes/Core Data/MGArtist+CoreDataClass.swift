//
//  MGArtist+CoreDataClass.swift
//  ManaKit
//
//  Created by Vito Royeca on 12/16/21.
//

import CoreData

public class MGArtist: MGEntity {
    enum CodingKeys: CodingKey {
        case firstName,
             lastName,
             name,
             nameSection,
             cards
    }

    public required convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
          throw DecoderConfigurationError.missingManagedObjectContext
        }

        self.init(context: context)

        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        firstName = try container.decodeIfPresent(String.self, forKey: .firstName)
        lastName = try container.decodeIfPresent(String.self, forKey: .lastName)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        nameSection = try container.decodeIfPresent(String.self, forKey: .nameSection)
        if let cards = try container.decodeIfPresent(Set<MGCard>.self, forKey: .cards) as NSSet? {
            addToCards(cards)
        }
    }
    
    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(firstName, forKey: .firstName)
        try container.encode(lastName, forKey: .lastName)
        try container.encode(name, forKey: .name)
        try container.encode(nameSection, forKey: .nameSection)
        if let cards = cards as? Set<MGCard> {
            try container.encode(cards, forKey: .cards)
        }
    }
}
