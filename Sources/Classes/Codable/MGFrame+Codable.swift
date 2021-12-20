//
//  MGFrame+Codable.swift
//  ManaKit
//
//  Created by Vito Royeca on 12/17/21.
//

import CoreData

public class MGFrame: NSManagedObject, Codable {
    enum CodingKeys: CodingKey {
        case description_,
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
        
        description_ = try container.decodeIfPresent(String.self, forKey: .description_)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        nameSection = try container.decodeIfPresent(String.self, forKey: .nameSection)
        cards = try container.decodeIfPresent(Set<MGCard>.self, forKey: .cards) as NSSet?
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(description_, forKey: .description_)
        try container.encode(name, forKey: .name)
        try container.encode(nameSection, forKey: .nameSection)
        try container.encode(cards as! Set<MGCard>, forKey: .cards)
    }
}
