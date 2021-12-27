//
//  MGColor+Codable.swift
//  ManaKit
//
//  Created by Vito Royeca on 12/17/21.
//

import CoreData

public class MGColor: MGEntity {
    enum CodingKeys: CodingKey {
        case name,
             nameSection,
             symbol/*,
             cards,
             identities,
             indicators*/
    }

    public required convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
          throw DecoderConfigurationError.missingManagedObjectContext
        }

        self.init(context: context)

        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        name = try container.decodeIfPresent(String.self, forKey: .name)
        nameSection = try container.decodeIfPresent(String.self, forKey: .nameSection)
        symbol = try container.decodeIfPresent(String.self, forKey: .symbol)
//        cards = try container.decodeIfPresent(Set<MGCard>.self, forKey: .cards) as NSSet?
//        identities = try container.decodeIfPresent(Set<MGCard>.self, forKey: .identities) as NSSet?
//        indicators = try container.decodeIfPresent(Set<MGCard>.self, forKey: .indicators) as NSSet?
    }
    
    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(name, forKey: .name)
        try container.encode(nameSection, forKey: .nameSection)
        try container.encode(symbol, forKey: .symbol)
//        try container.encode(cards as! Set<MGCard>, forKey: .cards)
//        try container.encode(identities as! Set<MGCard>, forKey: .identities)
//        try container.encode(indicators as! Set<MGCard>, forKey: .indicators)
    }
}
