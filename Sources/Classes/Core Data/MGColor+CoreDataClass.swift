//
//  MGColor+CoreDataClass.swift
//  ManaKit
//
//  Created by Vito Royeca on 12/17/21.
//

import CoreData

class MGColor: MGEntity {
    enum CodingKeys: CodingKey {
        case name,
             nameSection,
             symbol/*,
             cards,
             identities,
             indicators*/
    }

    required convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
          throw DecoderConfigurationError.missingManagedObjectContext
        }

        self.init(context: context)

        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // name
        if let name = try container.decodeIfPresent(String.self, forKey: .name),
           self.name != name {
            self.name = name
        }
        
        // nameSection
        if let nameSection = try container.decodeIfPresent(String.self, forKey: .nameSection),
           self.nameSection != nameSection {
            self.nameSection = nameSection
        }
        
        // symbol
        if let symbol = try container.decodeIfPresent(String.self, forKey: .symbol),
           self.symbol != symbol {
            self.symbol = symbol
        }
        
//        cards = try container.decodeIfPresent(Set<MGCard>.self, forKey: .cards) as NSSet?
//        identities = try container.decodeIfPresent(Set<MGCard>.self, forKey: .identities) as NSSet?
//        indicators = try container.decodeIfPresent(Set<MGCard>.self, forKey: .indicators) as NSSet?
    }
    
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(name, forKey: .name)
        try container.encode(nameSection, forKey: .nameSection)
        try container.encode(symbol, forKey: .symbol)
        
//        try container.encode(cards as! Set<MGCard>, forKey: .cards)
//        try container.encode(identities as! Set<MGCard>, forKey: .identities)
//        try container.encode(indicators as! Set<MGCard>, forKey: .indicators)
    }
    
    func toModel() -> MColor {
        return MColor(name: name,
                      nameSection: nameSection,
                      symbol: symbol)
    }
}
