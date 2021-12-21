//
//  MGLanguage+Codable.swift
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
        cards = try container.decodeIfPresent(Set<MGCard>.self, forKey: .cards) as NSSet?
        sets = try container.decodeIfPresent(Set<MGSet>.self, forKey: .sets) as NSSet?
    }
    
    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(code, forKey: .code)
        try container.encode(displayCode, forKey: .displayCode)
        try container.encode(name, forKey: .name)
        try container.encode(nameSection, forKey: .nameSection)
        try container.encode(cards as! Set<MGCard>, forKey: .cards)
        try container.encode(sets as! Set<MGSet>, forKey: .sets)
    }
}
