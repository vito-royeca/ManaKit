//
//  MGFrame+CoreDataClass.swift
//  ManaKit
//
//  Created by Vito Royeca on 12/17/21.
//

import CoreData

class MGFrame: MGEntity {
    enum CodingKeys: CodingKey {
        case description_,
             name,
             nameSection,
             cards
    }

    required convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
          throw DecoderConfigurationError.missingManagedObjectContext
        }

        self.init(context: context)

        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // description_
        if let description_ = try container.decodeIfPresent(String.self, forKey: .description_),
           self.description_ != description_ {
            self.description_ = description_
        }
        
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
        
//        if let cards = try container.decodeIfPresent(Set<MGCard>.self, forKey: .cards) {
////            addToCards(cards)
//            cards.forEach {
//                $0.frame = self
//            }
//        }
    }
    
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(description_, forKey: .description_)
        try container.encode(name, forKey: .name)
        try container.encode(nameSection, forKey: .nameSection)
        if let cards = cards as? Set<MGCard> {
            try container.encode(cards, forKey: .cards)
        }
    }
    
    func toModel() -> MFrame {
        return MFrame(description_: description_,
                      name: name,
                      nameSection: nameSection)
    }
}
