//
//  MGLanguage+CoreDataClass.swift
//  ManaKit
//
//  Created by Vito Royeca on 12/17/21.
//

import CoreData

public class MGLanguage: MGEntity {
    enum CodingKeys: CodingKey {
        case code,
             displayCode,
             name,
             nameSection,
             cards,
             sets
    }

    public required convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
          throw DecoderConfigurationError.missingManagedObjectContext
        }

        self.init(context: context)

        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        code = try container.decodeIfPresent(String.self, forKey: .code)
        displayCode = try container.decodeIfPresent(String.self, forKey: .displayCode)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        nameSection = try container.decodeIfPresent(String.self, forKey: .nameSection)
        
        if let cards = try container.decodeIfPresent(Set<MGCard>.self, forKey: .cards) as NSSet? {
            addToCards(cards)
        }
        if let sets = try container.decodeIfPresent(Set<MGSet>.self, forKey: .sets) as NSSet? {
            addToSets(sets)
        }
    }
    
    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(code, forKey: .code)
        try container.encode(displayCode, forKey: .displayCode)
        try container.encode(name, forKey: .name)
        try container.encode(nameSection, forKey: .nameSection)
        if let cards = cards as? Set<MGCard> {
            try container.encode(cards, forKey: .cards)
        }
        if let sets = sets as? Set<MGSet> {
            try container.encode(sets, forKey: .sets)
        }
    }
}
